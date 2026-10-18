import 'package:flutter/material.dart';
import 'package:service_hub/services/booking_services.dart';
import 'package:service_hub/widgets/booking_date_picker.dart';
import 'package:service_hub/widgets/booking_time_slots.dart';
import 'package:service_hub/widgets/booking_workshop_card.dart';
import 'package:service_hub/widgets/service_selection.dart';

import '../models/workshop_models.dart';
import '../widgets/home_header.dart';

class BookingScreen extends StatefulWidget {
  final WorkshopModel workshop;

  const BookingScreen({super.key, required this.workshop});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? selectedService;
  String? selectedTime;

  DateTime selectedDate = DateTime.now();

  final noteController = TextEditingController();
  final BookingService bookingService = BookingService();

  List<String> slots = [];
  bool isLoadingSlots = true;

  Future<void> loadSlots() async {
    try {
      final availableSlots = await bookingService.getAvailableSlots(
        widget.workshop.id,
        selectedDate,
      );

      setState(() {
        slots = availableSlots;
        isLoadingSlots = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoadingSlots = false;
      });
    }
  }

  Future<void> createBooking() async {
    if (selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih layanan terlebih dahulu")),
      );
      return;
    }

    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih waktu terlebih dahulu")),
      );
      return;
    }

    try {
      await bookingService.createBooking(
        workshopId: widget.workshop.id,
        serviceName: selectedService!,
        date: selectedDate,
        time: selectedTime!,
        notes: noteController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Booking berhasil dibuat"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const HomeHeader(),

              const SizedBox(height: 16),

              BookingWorkshopCard(workshop: widget.workshop),

              const SizedBox(height: 24),

              const Text(
                "Pilih Layanan",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              ServiceSelection(
                services: widget.workshop.services,
                selectedService: selectedService,
                onChanged: (value) {
                  setState(() {
                    selectedService = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              const Text(
                "Pilih Tanggal",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              BookingDatePicker(
                selectedDate: selectedDate,
                onDateChanged: (date) async {
                  setState(() {
                    selectedDate = date;
                    selectedTime = null;
                    isLoadingSlots = true;
                  });

                  await loadSlots();
                },
              ),

              const SizedBox(height: 24),

              const Text(
                "Slot Waktu Tersedia",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              isLoadingSlots
                  ? const Center(child: CircularProgressIndicator())
                  : TimeSlotSelector(
                      slots: slots,
                      selectedTime: selectedTime,
                      onChanged: (time) {
                        setState(() {
                          selectedTime = time;
                        });
                      },
                    ),

              const SizedBox(height: 24),

              const Text(
                "Catatan Tambahan",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: noteController,
                maxLines: 4,

                decoration: InputDecoration(
                  hintText: "Beritahu teknisi jika ada keluhan spesifik...",

                  filled: true,

                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF6B00),

                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),

                  onPressed: () {
                    createBooking();
                  },

                  child: const Text(
                    "Konfirmasi Booking",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
