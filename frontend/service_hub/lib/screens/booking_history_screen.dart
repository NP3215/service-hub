import 'package:flutter/material.dart';
import 'package:service_hub/services/booking_services.dart';

import '../models/booking_models.dart';
import '../widgets/home_header.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/booking_history_card.dart';
import '../widgets/booking_status_tab.dart';

import 'dart:async';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  String selectedTab = "Aktif";

  final BookingService bookingService = BookingService();

  bool isLoading = true;

  List<BookingModel> bookings = [];

  List<BookingModel> filteredBookings = [];

  Timer? refreshTimer;

  Future<void> loadBookings() async {
    try {
      bookings = await bookingService.getMyBookings();

      if (!mounted) return;

      filterBookings(selectedTab);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadBookings();

    // API later
    filterBookings("Aktif");

    refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await loadBookings();
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  void filterBookings(String tab) {
    setState(() {
      selectedTab = tab;

      if (tab == "Aktif") {
        filteredBookings = bookings
            .where(
              (booking) =>
                  booking.status == "Pending" || booking.status == "Confirmed",
            )
            .toList();
      } else {
        filteredBookings = bookings
            .where(
              (booking) =>
                  booking.status == "Completed" ||
                  booking.status == "Cancelled",
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),

      bottomNavigationBar: const CustomBottomNav(selectedIndex: 1),

      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),

            BookingStatusTabs(
              selectedTab: selectedTab,
              onChanged: filterBookings,
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: filteredBookings.length,

                itemBuilder: (context, index) {
                  return BookingHistoryCard(
                    booking: filteredBookings[index],
                    onCancel: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Batalkan Booking"),
                          content: const Text(
                            "Yakin ingin membatalkan booking ini?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Tidak"),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Ya"),
                            ),
                          ],
                        ),
                      );

                      if (confirmed != true) return;

                      await bookingService.cancelBooking(
                        filteredBookings[index].id,
                      );

                      await loadBookings();
                    },
                    onComplete: () async {
                      await bookingService.completeBooking(
                        filteredBookings[index].id,
                      );

                      await loadBookings();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
