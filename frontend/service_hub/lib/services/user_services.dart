import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:service_hub/services/api_services.dart';
import '../models/user_models.dart';

class UserServices {
  Future<UserModel> getProfile() async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();

    final response = await http.get(
      Uri.parse("${ApiService.baseUrl}/api/user/profile"),
      headers: {"Authorization": "Bearer $token"},
    );

    final json = jsonDecode(response.body);

    return UserModel.fromJson(json["data"]);
  }
}
