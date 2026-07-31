import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';
import '../providers/bookmark_provider.dart';
import '../utils/app_theme.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;
  const ArticleDetailScreen({super.key, required this.article});

  Future<void> _openSource(BuildContext context) async {
    final uri = Uri.tryParse(article.url);
    if (uri == null) return;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the article link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = AppTheme.categoryColor(article.category);

    return Scaffold(
      body: Consumer<BookmarkProvider>(
        builder: (context, bookmarkProvider, _) {
          final bookmarked = bookmarkProvider.isBookmarked(article.url);
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 280,
                backgroundColor: theme.scaffoldBackgroundColor,
                surfaceTintColor: Colors.transparent,
                leading: _RoundIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.of(context).pop(),
                ),
                actions: [
                  _RoundIconButton(
                    icon: Icons.share_rounded,
                    onTap: () => Share.share('${article.title}\n${article.url}'),
                  ),
                  const SizedBox(width: 8),
                  _RoundIconButton(
                    icon: bookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    iconColor: bookmarked ? categoryColor : null,
                    onTap: () => bookmarkProvider.toggleBookmark(article),
                  ),
                  const SizedBox(width: 12),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: article.url,
                    child: article.imageUrl != null && article.imageUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: article.imageUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(color: categoryColor.withOpacity(0.2)),
                          )
                        : Container(
                            color: categoryColor.withOpacity(0.2),
                            child: Icon(Icons.article_outlined, size: 64, color: categoryColor),
                          ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: categoryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          article.category.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(article.title, style: theme.textTheme.displayLarge),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: categoryColor.withOpacity(0.2),
                            child: Icon(Icons.public_rounded, size: 14, color: categoryColor),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(article.sourceName ?? 'Unknown source',
                                    style: theme.textTheme.titleMedium),
                                Text(
                                  DateFormat('MMM d, y • h:mm a').format(article.publishedAt),
                                  style: theme.textTheme.labelMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 36),
                      if (article.description != null) ...[
                        Text(
                          article.description!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                      if (article.content != null)
                        Text(
                          _cleanContent(article.content!),
                          style: theme.textTheme.bodyLarge,
                        ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _openSource(context),
                          icon: const Icon(Icons.open_in_new_rounded, size: 18),
                          label: const Text('Read full article'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: categoryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// NewsAPI truncates `content` with a "[+1234 chars]" suffix; strip it
  /// for a cleaner reading experience.
  String _cleanContent(String content) {
    return content.replaceAll(RegExp(r'\[\+\d+ chars\]'), '').trim();
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  const _RoundIconButton({required this.icon, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Material(
        color: Theme.of(context).cardTheme.color,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, size: 20, color: iconColor),
          ),
        ),
      ),
    );
  }
}
