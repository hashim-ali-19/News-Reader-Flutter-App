import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bookmark_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/state_widgets.dart';
import 'article_detail_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saved', style: theme.textTheme.displayLarge?.copyWith(fontSize: 30)),
                  Text('Available offline, anytime', style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<BookmarkProvider>(
                builder: (context, bookmarkProvider, _) {
                  final bookmarks = bookmarkProvider.bookmarks;
                  if (bookmarks.isEmpty) {
                    return const EmptyStateWidget(
                      title: 'No bookmarks yet',
                      message: 'Tap the bookmark icon on any article to save it for offline reading.',
                      icon: Icons.bookmark_border_rounded,
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: bookmarks.length,
                    itemBuilder: (context, index) {
                      final article = bookmarks[index];
                      return ArticleCard(
                        article: article,
                        index: index + 1, // avoid forcing featured layout on first item
                        isBookmarked: true,
                        onBookmarkTap: () => bookmarkProvider.toggleBookmark(article),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ArticleDetailScreen(article: article),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
