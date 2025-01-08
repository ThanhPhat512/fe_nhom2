import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FoodItemService {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static Future<List<Map<String, dynamic>>> fetchData() async {

    final url = Uri.parse('$baseUrl/api/Food/default');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
