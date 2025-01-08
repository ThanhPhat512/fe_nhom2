import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/food_post.dart';

class FoodItemService {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  static Future<List<FoodItem>> fetchData() async {
    final url = Uri.parse('$baseUrl/api/Food/default');
    final response = await http.get(
      url,
      headers: {
        'ngrok-skip-browser-warning': 'true'
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => FoodItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchAreaListData() async {
    try {
      final List<FoodItem> foodItems = await FoodItemService.fetchData();
      return foodItems.map((foodItem) => foodItem.imageUrl).toList();
    } catch (error) {
      print('Error fetching area list data: $error');
      return []; // Trả về danh sách rỗng nếu lỗi
    }
  }
}
