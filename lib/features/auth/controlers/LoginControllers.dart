import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginController {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(
      'http://10.0.2.2/eltrack_recycling/login.php',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    return data;
  }
}