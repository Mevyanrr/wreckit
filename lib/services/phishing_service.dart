// services/phishing_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class PhishingService {
  // Replace with the host laptop's local IP address running FastAPI
  static const String baseUrl = "http://10.246.230.106:8000/api/v1";

  Future<Map<String, dynamic>> checkURL(String url) async {
    final uri = Uri.parse('$baseUrl/scan');

    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'url': url}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        return {
          'error': true,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Failed to connect to server: $e'
      };
    }
  }
}