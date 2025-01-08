import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_post.dart';

class UserService {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<User> fetchData() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token is missing. Please log in.');
    }

    final url = Uri.parse('$baseUrl/api/user/profile');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true'
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        print('Error: ${response.body}');
        throw Exception(
            'Failed to load user data. Status Code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
      throw Exception('Error fetching user data: $error');
    }
  }
}
