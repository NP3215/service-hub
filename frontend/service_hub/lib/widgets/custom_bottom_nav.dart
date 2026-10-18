import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/booking_history_screen.dart';
import '../screens/profile_screen.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNav({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;

      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BookingHistoryScreen()),
        );
        break;

      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,

      onDestinationSelected: (index) {
        _onItemTapped(context, index);
      },

      destinations: const [
        NavigationDestination(icon: Icon(Icons.explore), label: "Explore"),

        NavigationDestination(
          icon: Icon(Icons.calendar_today),
          label: "Bookings",
        ),

        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      ],
    );
  }
}
