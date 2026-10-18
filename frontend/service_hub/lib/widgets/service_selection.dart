import 'package:flutter/material.dart';

class ServiceSelection extends StatelessWidget {
  final List<String> services;

  final String? selectedService;

  final Function(String?) onChanged;

  const ServiceSelection({
    super.key,
    required this.services,
    this.selectedService,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: services.map((service) {
        return RadioListTile<String>(
          value: service,
          groupValue: selectedService,
          onChanged: onChanged,
          title: Text(service),
        );
      }).toList(),
    );
  }
}
