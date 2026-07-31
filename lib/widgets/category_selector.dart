import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Center( // 1. Screen ke darmayan karne ke liye
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // 2. Items ko center align karne ke liye
            children: AppConstants.categories.map((category) {
              final bool selected = category == selectedCategory;
              final color = AppTheme.categoryColor(category);

              return Padding(
                padding: const EdgeInsets.only(right: 8), // Gap between chips
                child: GestureDetector(
                  onTap: () => onSelected(category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: selected ? color : Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: selected ? color : Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Text(
                      category[0].toUpperCase() + category.substring(1),
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}