import 'package:flutter/material.dart';

class TimeSlotSelector extends StatelessWidget {
  final List<String> slots;

  final String? selectedTime;

  final Function(String) onChanged;

  const TimeSlotSelector({
    super.key,
    required this.slots,
    required this.selectedTime,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots.map((slot) {
        return ChoiceChip(
          label: Text(slot),
          selected: selectedTime == slot,
          onSelected: (_) {
            onChanged(slot);
          },
        );
      }).toList(),
    );
  }
}
