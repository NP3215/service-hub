import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_models.dart';
import 'api_services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register({
    required UserModel user,
    required String password,
  }) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );

    String firebaseUid = credential.user!.uid;

    final response = await http.post(
      Uri.parse("${ApiService.baseUrl}/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firebase_uid": firebaseUid,
        "full_name": user.fullName,
        "email": user.email,
        "phone": user.phone,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to save user profile");
    }
  }

  Future<void> login({required String email, required String password}) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final token = await credential.user!.getIdToken();

    await http.get(
      Uri.parse("${ApiService.baseUrl}/api/auth/login"),
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
