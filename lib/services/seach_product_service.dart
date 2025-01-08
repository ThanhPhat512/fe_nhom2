import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/seach_product_post.dart';

class SearchProductService {
  // Base URL được cấu hình từ file .env
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  // Hàm tìm kiếm sản phẩm
  static Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    final url = Uri.parse('$baseUrl/api/Food/search?query=$query');

    try {
      final response = await http.get(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }




}
