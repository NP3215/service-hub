import 'package:flutter/material.dart';
import 'package:service_hub/screens/login_screen.dart';

import '../models/user_models.dart';
import '../services/auth_services.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/password_text_field.dart';
import '../widgets/social_button.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final fullNameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();

  bool isValidEmail(String email) {
    return RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email);
  }

  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{7,}$').hasMatch(password);
  }

  bool agree = false;

  final authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  Future<void> register() async {
    // Validate all fields first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final user = UserModel(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      await authService.register(
        user: user,
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Registration successful"),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case "email-already-in-use":
          message = "This email is already registered";
          break;

        case "invalid-email":
          message = "Invalid email address";
          break;

        case "weak-password":
          message = "Password is too weak";
          break;

        default:
          message = e.message ?? "Registration failed";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
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
                  const Icon(
                    Icons.settings,
                    color: Color(0xFFFF6B00),
                    size: 40,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Daftar Akun",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Mulai perjalanan perawatan kendaraan Anda",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  CustomTextField(
                    label: "Nama Lengkap",
                    hint: "John Doe",
                    controller: fullNameController,
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "Email",
                    hint: "example@email.com",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email is required";
                      }

                      final emailRegex = RegExp(
                        r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
                      );

                      if (!emailRegex.hasMatch(value.trim())) {
                        return "Invalid email format";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "No. Telepon",
                    hint: "+62 812 3456 7890",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
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
                        return "Password is required";
                      }

                      final passwordRegex = RegExp(
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{7,}$',
                      );

                      if (!passwordRegex.hasMatch(value)) {
                        return "Must contain uppercase, lowercase, number, min 7 chars";
                      }

                      return null;
                    },
                  ),

                  CheckboxListTile(
                    value: agree,
                    onChanged: (value) {
                      setState(() {
                        agree = value!;
                      });
                    },
                    title: const Text("Saya menyetujui syarat & ketentuan"),
                    contentPadding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 10),

                  CustomButton(text: "Daftar Sekarang", onPressed: register),

                  const SizedBox(height: 30),

                  const Text("ATAU"),

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
                        text: "Facebook",
                        icon: Icons.facebook,
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sudah punya akun?",
                        style: TextStyle(color: Colors.black54),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
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
