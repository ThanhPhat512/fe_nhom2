import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/food_detail_post.dart';

class FoodService {
  // URL base của API
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  static Future<FoodDetail?> fetchFoodDetail(int fdcId) async {
    if (baseUrl.isEmpty) {
      print('Error: BASE_URL is not defined in the environment file.');
      return null;
    }
    final String url = '$baseUrl/api/Food/details/$fdcId';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'ngrok-skip-browser-warning': 'true'
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return FoodDetail.fromJson(jsonData);
      } else {
        print('Error: Failed to fetch data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: Failed to fetch data. Error: $e');
      return null;
    }
  }
}
