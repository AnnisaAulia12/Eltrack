// ngattur logika soal waste guide 
import 'dart:convert';
import 'package:http/http.dart' as http;

class WasteGuideService {
  static const String baseUrl =
      'http://10.0.2.2/eltrack_recycling/waste_guide_API/waste_guide.php';

  static Future<Map<String, dynamic>> getWasteGuide({
    required String category,
    required String typeName,
  }) async {
    final url = Uri.parse(
      '$baseUrl?category=${Uri.encodeComponent(category)}'
      '&type_name=${Uri.encodeComponent(typeName)}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return Map<String, dynamic>.from(data['guide']);
      }

      throw Exception(
        data['message'] ?? 'Failed to load waste guide',
      );
    }

    throw Exception(
      'HTTP Error: ${response.statusCode}',
    );
  }
}