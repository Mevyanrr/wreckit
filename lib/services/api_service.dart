// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use http://10.0.2.2:8000 for Android Emulator, or http://192.168.1.x:8000 for physical phone
  static const String baseUrl = "http://10.246.230.106:8000/api/v1";

  static Future<Map<String, dynamic>> scanUrl({
    required String url,
    double heuristicScore = 0.0,
  }) async {
    final uri = Uri.parse('$baseUrl/scan');

    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'url': url,
              'heuristic_score': heuristicScore,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception("Scan failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error scanning URL: $e");
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchHistory({String? verdict}) async {
    final uri = Uri.parse('$baseUrl/history${verdict != null ? '?verdict=$verdict' : ''}');
    
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception("Failed to load history: ${response.statusCode}");
      }
    } catch (e) {
      print("API Error: $e");
      rethrow;
    }
  }
}