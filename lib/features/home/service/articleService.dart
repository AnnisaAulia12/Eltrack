import 'dart:convert';
import 'package:http/http.dart' as http;

//ini service untuk 

class articleService {
  static const String baseUrl =
      'http://10.0.2.2/eltrack_recycling/eltrack_artickel_API/articles.php';

  static Future<List<dynamic>> getArticles(String category) async {
    final url = Uri.parse('$baseUrl?category=$category');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return data['articles'] ?? [];
      }

      throw Exception(data['message'] ?? 'Failed to load articles');
    }

    throw Exception('HTTP Error: ${response.statusCode}');
  }
}