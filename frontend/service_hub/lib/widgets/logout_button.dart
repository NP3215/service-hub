import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffFEE2E2),
        ),

        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        },

        child: const Text("Keluar", style: TextStyle(color: Colors.red)),
      ),
    );
  }
}
