import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/post_post.dart';

class PostService {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  static Future<List<Post>> fetchData() async {
    final url = Uri.parse('$baseUrl/api/Post');
    try {
      final response = await http.get(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts. Status: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching posts: $error');
    }
  }
}
