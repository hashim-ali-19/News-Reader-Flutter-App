import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/article_provider.dart';
import '../providers/bookmark_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/category_selector.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/state_widgets.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _searchExpanded = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<ArticleProvider>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            Consumer<ArticleProvider>(
              builder: (context, provider, _) {
                if (provider.isSearching) return const SizedBox.shrink();
                return CategorySelector(
                  selectedCategory: provider.selectedCategory,
                  onSelected: (category) => provider.setCategory(category),
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

Widget _buildHeader(BuildContext context) {
  final theme = Theme.of(context);
  
  // Date format karne ke liye (Aap DateTime formatting use kar sakte hain)
  final now = DateTime.now();
  final formattedDate = "${now.day}/${now.month}/${now.year}"; 
  // Custom format jaise "1 Aug" ke liye: 
  // final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  // final formattedDate = "${now.day} ${months[now.month - 1]}";

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        // 1. Search close hone par Left side par Current Date
        if (!_searchExpanded)
          SizedBox(
            width: 96, // Fixed width taake right side ke icons ke sath layout balance rahe
            child: Text(
              formattedDate,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        Expanded(
          child: _searchExpanded
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: theme.textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'Search articles…',
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) =>
                      context.read<ArticleProvider>().search(value),
                )
              : Column(
                  // 2. Title aur subtitle ko center align kiya gaya hai
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Loop',
                      style: theme.textTheme.displayLarge?.copyWith(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Stay in the loop',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),

        // Right side ke Action Buttons
        IconButton(
          icon: Icon(_searchExpanded ? Icons.close_rounded : Icons.search_rounded),
          onPressed: () {
            setState(() {
              if (_searchExpanded) {
                _searchController.clear();
                context.read<ArticleProvider>().clearSearch();
              }
              _searchExpanded = !_searchExpanded;
            });
          },
        ),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) => IconButton(
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_outlined,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
        ),
      ],
    ),
  );
}

  Widget _buildBody(BuildContext context) {
    return Consumer2<ArticleProvider, BookmarkProvider>(
      builder: (context, articleProvider, bookmarkProvider, _) {
        switch (articleProvider.status) {
          case FeedStatus.initial:
          case FeedStatus.loading:
            return const ShimmerFeedList();

          case FeedStatus.error:
            return ErrorStateWidget(
              message: articleProvider.errorMessage,
              onRetry: () => articleProvider.fetchInitial(),
            );

          case FeedStatus.empty:
            return EmptyStateWidget(
              title: articleProvider.isSearching ? 'No results found' : 'No articles found',
              message: articleProvider.isSearching
                  ? 'Try a different keyword.'
                  : 'Pull down to refresh the feed.',
              icon: articleProvider.isSearching ? Icons.search_off_rounded : Icons.newspaper_rounded,
            );

          case FeedStatus.offlineCached:
          case FeedStatus.loaded:
          case FeedStatus.loadingMore:
            return Column(
              children: [
                if (articleProvider.status == FeedStatus.offlineCached)
                  const OfflineBanner(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: articleProvider.refresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: articleProvider.articles.length +
                          (articleProvider.status == FeedStatus.loadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= articleProvider.articles.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final article = articleProvider.articles[index];
                        return ArticleCard(
                          article: article,
                          index: index,
                          isBookmarked: bookmarkProvider.isBookmarked(article.url),
                          onBookmarkTap: () => bookmarkProvider.toggleBookmark(article),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ArticleDetailScreen(article: article),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}
