import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/config_url.dart';
import '../../../models/post_post.dart';
import '../../../theme/home_app_theme.dart';

class GoodFoodScreen extends StatefulWidget {
  const GoodFoodScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _GoodFoodScreenState createState() => _GoodFoodScreenState();
}

Future<void> likePost(int postId, String token) async {
  final String baseUrl = '${Config_URL.baseUrl}'; // Địa chỉ API của bạn
  final String url = '$baseUrl/api/like/$postId/like';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Gửi token JWT
      },
      body: json.encode({}),
    );

    if (response.statusCode == 200) {
      print('Post liked successfully');
    } else {
      print('Failed to like post: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> unlikePost(int postId, String token) async {
  final String baseUrl = '${Config_URL.baseUrl}'; // Địa chỉ API của bạn
  final String url = '$baseUrl/api/like/$postId/unlike';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Gửi token JWT
      },
      body: json.encode({}),
    );

    if (response.statusCode == 200) {
      print('Post unliked successfully');
    } else {
      print('Failed to unlike post: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<List<Post>> fetchPosts() async {
  final String baseUrl = '${Config_URL.baseUrl}/api/Post/active';
  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'ngrok-skip-browser-warning': 'true',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);

    // Lặp qua tất cả bài viết và kiểm tra lại trạng thái like khi load dữ liệu
    List<Post> posts = data.map((item) => Post.fromJson(item)).toList();

    // Lấy token và userId khi tải dữ liệu để so sánh với trạng thái like
    String currentUserId = await getUserIdFromToken();

    for (var post in posts) {
      // Kiểm tra nếu bài viết đã được like bởi user hiện tại
      post.likes.any((like) {
        return like['userId'] == currentUserId;
      });
    }

    return posts;
  } else {
    throw Exception('Failed to load posts');
  }
}


Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token') ?? ''; // Lấy token JWT từ SharedPreferences
}

Future<String> getUserIdFromToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  if (token == null) {
    return ''; // Nếu không có token, trả về chuỗi rỗng
  }

  // Giải mã token (Nếu sử dụng JWT, cần dùng thư viện giải mã JWT như 'jwt_decoder')
  final decodedToken = JwtDecoder.decode(token);
  final userId = decodedToken['userId']; // Lấy userId từ token

  return userId;
}

class _GoodFoodScreenState extends State<GoodFoodScreen> with TickerProviderStateMixin {
  String currentUserId = ''; // UserId của người dùng hiện tại
  ScrollController _scrollController = ScrollController();  // Khai báo ScrollController

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('user_id') ?? '';
    });
  }

  Future<void> toggleLike(Post post) async {
    String token = await getToken();
    String currentUserId = await getUserIdFromToken();  // Lấy userId từ token

    if (post.isLikedByUser(currentUserId)) {
      await unlikePost(post.id, token);  // Nếu đã like, thực hiện unlike
    } else {
      await likePost(post.id, token);  // Nếu chưa like, thực hiện like
    }
    setState(() {
      post.likes.any((like) {
        return like['userId'] == currentUserId;
      }) ? post.likes.add({'userId': currentUserId}) : post.likes.removeWhere((like) => like['userId'] == currentUserId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();  // Giải phóng controller khi widget bị hủy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),  // Điều chỉnh giá trị này để tạo khoảng cách dưới
        child: FutureBuilder<List<Post>>(
          future: fetchPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No posts available.'));
            } else {
              return ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data![index];
                  String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(post.dateCreate);

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: post.user.avatar != null
                                    ? NetworkImage(post.user.avatar!)
                                    : const AssetImage('assets/default_profile.png') as ImageProvider,
                                radius: 25,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.user.userName!,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            post.description ?? 'No description',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          post.image != null
                              ? Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center( // Centering the image
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  post.image!,
                                  fit: BoxFit.cover, // Ensure the image fills the available space
                                  width: double.infinity, // Make image take the full width
                                  height: 250, // Set a fixed height for better scaling
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) => const Center(
                                    child: Text('Image failed to load'),
                                  ),
                                ),
                              ),
                            ),
                          )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 8), // Giảm khoảng cách giữa ảnh và các nút cuối
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      post.isLikedByUser(currentUserId)
                                          ? Icons.thumb_up
                                          : Icons.thumb_up_alt_outlined,
                                    ),
                                    onPressed: () {
                                      toggleLike(post);
                                    },
                                  ),
                                  Text('${post.likeCount} Likes'),
                                ],
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  // Handle Comment action
                                },
                                icon: const Icon(Icons.comment_outlined),
                                label: const Text('Comment'),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  // Handle Share action
                                },
                                icon: const Icon(Icons.share_outlined),
                                label: const Text('Share'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }


}
