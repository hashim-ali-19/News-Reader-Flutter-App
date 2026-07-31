import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../models/article.dart';
import '../utils/app_theme.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final bool isBookmarked;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;
  final int index;

  const ArticleCard({
    super.key,
    required this.article,
    required this.isBookmarked,
    required this.onTap,
    required this.onBookmarkTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = AppTheme.categoryColor(article.category);
    // Every 5th card gets a "featured" wide layout for visual rhythm.
    final bool featured = index % 5 == 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.dividerColor, width: 1),
            ),
            child: featured
                ? _buildFeaturedLayout(context, categoryColor)
                : _buildCompactLayout(context, categoryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedLayout(BuildContext context, Color categoryColor) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildImage(),
                Positioned(
                  left: 12,
                  top: 12,
                  child: _CategoryBadge(category: article.category, color: categoryColor),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: _BookmarkButton(
                    isBookmarked: isBookmarked,
                    onTap: onBookmarkTap,
                    filled: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: theme.textTheme.headlineMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (article.description != null)
                Text(
                  article.description!,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 10),
              _MetaRow(article: article),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLayout(BuildContext context, Color categoryColor) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 96,
              height: 96,
              child: _buildImage(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoryBadge(category: article.category, color: categoryColor, compact: true),
                const SizedBox(height: 6),
                Text(
                  article.title,
                  style: theme.textTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                _MetaRow(article: article),
              ],
            ),
          ),
          _BookmarkButton(isBookmarked: isBookmarked, onTap: onBookmarkTap),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (article.imageUrl == null || article.imageUrl!.isEmpty) {
      return Container(
        color: AppTheme.categoryColor(article.category).withOpacity(0.15),
        child: Icon(Icons.article_outlined,
            color: AppTheme.categoryColor(article.category), size: 32),
      );
    }
    return CachedNetworkImage(
      imageUrl: article.imageUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.15)),
      errorWidget: (context, url, error) => Container(
        color: AppTheme.categoryColor(article.category).withOpacity(0.15),
        child: Icon(Icons.image_not_supported_outlined,
            color: AppTheme.categoryColor(article.category)),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final Article article;
  const _MetaRow({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Flexible(
          child: Text(
            article.sourceName ?? 'Unknown source',
            style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 6),
        Text('•', style: theme.textTheme.labelMedium),
        const SizedBox(width: 6),
        Text(_timeAgo(article.publishedAt), style: theme.textTheme.labelMedium),
      ],
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(date);
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;
  final Color color;
  final bool compact;
  const _CategoryBadge({required this.category, required this.color, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10, vertical: compact ? 3 : 5),
      decoration: BoxDecoration(
        color: compact ? color.withOpacity(0.14) : color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          color: compact ? color : Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onTap;
  final bool filled;
  const _BookmarkButton({required this.isBookmarked, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? Colors.black.withOpacity(0.35) : Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: filled
                ? Colors.white
                : (isBookmarked ? AppTheme.categoryColor('general') : Colors.grey),
            size: 22,
          ),
        ),
      ),
    );
  }
}
