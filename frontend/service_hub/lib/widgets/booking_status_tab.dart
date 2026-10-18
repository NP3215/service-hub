import 'package:flutter/material.dart';

class BookingStatusTabs extends StatelessWidget {
  final String selectedTab;

  final Function(String) onChanged;

  const BookingStatusTabs({
    super.key,
    required this.selectedTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [_buildTab("Aktif"), _buildTab("Selesai & Batal")]);
  }

  Widget _buildTab(String title) {
    final selected = title == selectedTab;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(title),

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),

          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: selected ? Colors.orange : Colors.transparent,
              ),
            ),
          ),

          child: Text(title, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
