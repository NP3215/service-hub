import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ["Semua", "Terdekat", "Populer"];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          final selected = category == selectedCategory;

          return GestureDetector(
            onTap: () {
              onCategorySelected(category);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              child: Chip(
                backgroundColor: selected
                    ? const Color(0xff7A2E00)
                    : const Color(0xffEEF2FB),
                label: Text(
                  category,
                  style: TextStyle(
                    color: selected ? Colors.orange : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
