import 'package:flutter/material.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final String? photoUrl;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        gradient: const LinearGradient(
          colors: [Color(0xff071A3D), Color(0xff1B2E59)],
        ),
      ),

      child: Column(
        children: [
          CircleAvatar(
            radius: 40,

            backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,

            child: photoUrl == null ? const Icon(Icons.person, size: 40) : null,
          ),

          const SizedBox(height: 12),

          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(email, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
