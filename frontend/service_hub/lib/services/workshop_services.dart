import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:service_hub/services/api_services.dart';

import '../models/workshop_models.dart';

class WorkshopService {
  static const String baseUrl = "${ApiService.baseUrl}/api/workshops";

  Future<List<WorkshopModel>> getWorkshops() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode != 200) {
      throw Exception("Failed to load workshops");
    }

    final data = jsonDecode(response.body);

    final List workshops = data["data"];

    return workshops.map((e) => WorkshopModel.fromJson(e)).toList();
  }
}
