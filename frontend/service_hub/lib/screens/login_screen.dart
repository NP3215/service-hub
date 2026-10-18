import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:service_hub/screens/home_screen.dart';
import 'package:service_hub/widgets/social_button.dart';

import '../services/auth_services.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/password_text_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final authService = AuthService();

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Login berhasil"),
        ),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Login gagal";
      switch (e.code) {
        case "user-not-found":
          message = "Email tidak ditemukan";
          break;
        case "wrong-password":
          message = "Password salah";
          break;
        case "invalid-credential":
          message = "Email atau password salah";
          break;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  const SizedBox(height: 20),

                  const Text(
                    "Selamat Datang",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Silakan masuk ke akun Anda",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  CustomTextField(
                    label: "Alamat Email",
                    hint: "nama@email.com",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email wajib diisi";
                      }

                      final emailRegex = RegExp(
                        r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
                      );

                      if (!emailRegex.hasMatch(value.trim())) {
                        return "Format email tidak valid";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Kata Sandi"),
                  ),

                  const SizedBox(height: 8),

                  PasswordTextField(
                    controller: passwordController,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password wajib diisi";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  CustomButton(text: "Masuk", onPressed: login),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      const Expanded(child: Divider()),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: const Text("ATAU"),
                      ),

                      const Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      SocialButton(
                        text: "Google",
                        icon: Icons.g_mobiledata,
                        onPressed: () {},
                      ),

                      const SizedBox(width: 10),

                      SocialButton(
                        text: "Apple",
                        icon: Icons.apple,
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Belum punya akun?"),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Daftar sekarang",
                          style: TextStyle(
                            color: Color(0xFFFF6B00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
