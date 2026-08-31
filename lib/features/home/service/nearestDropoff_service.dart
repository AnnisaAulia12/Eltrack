import 'dart:convert';
import 'package:http/http.dart' as http;

class nearestDropoff_service {
  static const String baseUrl =
      'http://10.0.2.2/eltrack_recycling/DropOffAPI/nearestDropOff.php';

  static Future<List<dynamic>> getNearestDropOff({
    required double latitude,
    required double longitude,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return data['places'] ?? [];
      }

      throw Exception(
        data['message'] ?? 'Failed to load nearest drop-off',
      );
    }

    throw Exception(
      'HTTP Error: ${response.statusCode}',
    );
  }
}