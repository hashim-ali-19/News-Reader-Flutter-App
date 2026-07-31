import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmering skeleton feed shown while the first page of articles
/// is loading, instead of a plain centered spinner.
class ShimmerFeedList extends StatelessWidget {
  final int itemCount;
  const ShimmerFeedList({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlight = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Shimmer.fromColors(
            baseColor: base,
            highlightColor: highlight,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 12, width: 60, color: Colors.white),
                        const SizedBox(height: 10),
                        Container(height: 14, width: double.infinity, color: Colors.white),
                        const SizedBox(height: 6),
                        Container(height: 14, width: 140, color: Colors.white),
                        const SizedBox(height: 12),
                        Container(height: 10, width: 100, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
