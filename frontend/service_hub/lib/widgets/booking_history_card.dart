import 'package:flutter/material.dart';

import '../models/booking_models.dart';

class BookingHistoryCard extends StatelessWidget {
  final BookingModel booking;

  final VoidCallback? onCancel;
  final VoidCallback? onComplete;
  const BookingHistoryCard({
    super.key,
    required this.booking,
    this.onCancel,
    this.onComplete,
  });

  Color getStatusColor() {
    switch (booking.status) {
      case "Pending":
        return Colors.orange.shade100;

      case "Confirmed":
        return Colors.blue.shade100;

      case "Completed":
        return Colors.green.shade100;

      case "Cancelled":
        return Colors.red.shade100;

      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.network(
                booking.imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Text(
                    booking.workshopName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: getStatusColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(booking.status),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(booking.serviceName),

            const SizedBox(height: 8),

            Text("${booking.bookingDate} • ${booking.bookingTime}"),

            const SizedBox(height: 16),

            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    if (booking.status == "Pending") {
      return OutlinedButton(onPressed: onCancel, child: const Text("Batalkan"));
    }

    if (booking.status == "Confirmed") {
      return ElevatedButton(
        onPressed: onComplete,
        child: const Text("Selesaikan"),
      );
    }

    return const SizedBox.shrink();
  }
}
