import 'dart:convert';
import 'package:http/http.dart' as http;


class RegisterController {
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(
      'http://10.0.2.2/eltrack_recycling/register.php',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'role': 'personal',
      }),
    );

    final data = jsonDecode(response.body);

    return data;
  }
}