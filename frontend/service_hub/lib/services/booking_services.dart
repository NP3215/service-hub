import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:service_hub/models/booking_models.dart';
import 'package:service_hub/services/api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingService {
  static const String baseUrl = "${ApiService.baseUrl}/api/bookings";

  Future<List<String>> getAvailableSlots(int workshopId, DateTime date) async {
    final response = await http.get(
      Uri.parse(
        "$baseUrl/available-slots"
        "?workshopId=$workshopId"
        "&date=${date.toIso8601String().split('T')[0]}",
      ),
    );

    final json = jsonDecode(response.body);

    return List<String>.from(json["slots"]);
  }

  Future<void> createBooking({
    required int workshopId,
    required String serviceName,
    required DateTime date,
    required String time,
    required String notes,
  }) async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();
    await http.post(
      Uri.parse(baseUrl),

      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },

      body: jsonEncode({
        "workshop_id": workshopId,
        "service_name": serviceName,
        "booking_date": date.toIso8601String().split("T")[0],
        "booking_time": time,
        "notes": notes,
      }),
    );
  }

  Future<List<BookingModel>> getMyBookings() async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();

    final response = await http.get(
      Uri.parse("$baseUrl/my-bookings"),

      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load bookings");
    }

    final json = jsonDecode(response.body);

    final List data = json["data"];

    return data.map((e) => BookingModel.fromJson(e)).toList();
  }

  Future<void> cancelBooking(int bookingId) async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();

    final response = await http.patch(
      Uri.parse("$baseUrl/$bookingId/cancel"),

      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to cancel booking");
    }
  }

  Future<void> completeBooking(int bookingId) async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();

    final response = await http.patch(
      Uri.parse("$baseUrl/$bookingId/complete"),

      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to complete booking");
    }
  }
}
