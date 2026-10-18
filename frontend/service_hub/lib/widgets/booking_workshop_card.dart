import 'package:flutter/material.dart';
import 'package:service_hub/models/workshop_models.dart';

class BookingWorkshopCard extends StatelessWidget {
  final WorkshopModel workshop;

  const BookingWorkshopCard({super.key, required this.workshop});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.network(
                workshop.imageUrl,

                height: 180,

                width: double.infinity,

                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              workshop.name,

              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(workshop.address),

            const SizedBox(height: 6),

            Text("⭐ ${workshop.rating}"),
          ],
        ),
      ),
    );
  }
}
