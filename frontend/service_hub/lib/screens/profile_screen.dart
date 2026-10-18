import 'package:flutter/material.dart';

import '../models/user_models.dart';
import '../services/user_services.dart';

import '../widgets/home_header.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/logout_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserServices userServices = UserServices();

  UserModel? user;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await userServices.getProfile();

      if (!mounted) return;

      setState(() {
        user = profile;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),

      bottomNavigationBar: const CustomBottomNav(selectedIndex: 2),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              const HomeHeader(),

              const SizedBox(height: 20),

              ProfileHeaderCard(
                name: user?.fullName ?? "ServiceHub User",

                email: user?.email ?? "No Email",

                photoUrl: null,
              ),

              const SizedBox(height: 20),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.phone),

                  title: const Text("Nomor HP"),

                  subtitle: Text(user?.phone ?? "-"),
                ),
              ),

              const SizedBox(height: 12),

              ProfileMenuTile(
                icon: Icons.directions_car,

                title: "Data Kendaraan Saya",

                onTap: () {},
              ),

              ProfileMenuTile(
                icon: Icons.location_on,

                title: "Alamat Tersimpan",

                onTap: () {},
              ),

              ProfileMenuTile(
                icon: Icons.credit_card,

                title: "Metode Pembayaran",

                onTap: () {},
              ),

              ProfileMenuTile(
                icon: Icons.settings,

                title: "Pengaturan",

                onTap: () {},
              ),

              ProfileMenuTile(
                icon: Icons.help_outline,

                title: "Pusat Bantuan",

                onTap: () {},
              ),

              const SizedBox(height: 20),

              const LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
