import 'dart:convert';
import 'package:fe_nhom2/models/user_post.dart';
import 'package:fe_nhom2/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:fe_nhom2/theme/home_app_theme.dart';
import 'package:fe_nhom2/screens/home_screen.dart';
import 'package:fe_nhom2/screens/introduction_infomation/introduction_screen.dart';
import 'package:fe_nhom2/config/config_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../models/post_post.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<User?> futureUser;
  List<Post> posts = [];
  late Future<Map<String, dynamic>> userProfile;

  @override
  void initState() {
    super.initState();
    futureUser = UserService.fetchData();
    userProfile = fetchUserProfile();
    fetchUserPosts();
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    String? token = await getJwtToken();
    if (token == null) return {};

    final String baseUrl = '${Config_URL.baseUrl}';
    final String url = '$baseUrl/api/User/profile';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<void> fetchUserPosts() async {
    String? token = await getJwtToken();
    String? userId = await getUserIdFromToken();
    if (userId != null && token != null) {
      try {
        List<Post> userPosts = await fetchUserPostsData(userId, token);
        setState(() {
          posts = userPosts;
        });
      } catch (e) {
        print('Error fetching posts: $e');
      }
    }
  }

  // Fetch JWT token from SharedPreferences
  Future<String?> getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Get the user ID from the JWT token
  Future<String> getUserIdFromToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) return '';
    final decodedToken = JwtDecoder.decode(token);
    return decodedToken['userId'] ?? '';
  }

// Fetch posts for the user
Future<List<Post>> fetchUserPostsData(String userId, String token) async {
  final String baseUrl = '${Config_URL.baseUrl}';
  final String url = '$baseUrl/api/post/user';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'ngrok-skip-browser-warning': 'true',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Post.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load posts');
  }
}

Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwt_token');
  await prefs.remove('userId');

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const IntroductionAnimationScreen(),
    ),
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('User Screen'),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: logout,
        ),
      ],
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80.0), // Add padding to the bottom
      child: Column(
        children: [
          // User Info View
          UserView(animationController: widget.animationController, userProfile: userProfile),

          // User Posts View
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: posts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              shrinkWrap: true,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                String formattedDate =
                DateFormat('yyyy-MM-dd HH:mm').format(post.dateCreate);

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
                                  : const AssetImage('assets/default_profile.png')
                              as ImageProvider,
                              radius: 25,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.user.userName!,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
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
                          child: Center(  // Center the image
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                post.image!,
                                fit: BoxFit.cover,  // BoxFit.cover will ensure the image is nicely scaled and covers the area
                                width: 350,  // Increased width
                                height: 250,  // Increased height
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

                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}

class UserView extends StatelessWidget {
  final AnimationController? animationController;
  final Future<Map<String, dynamic>> userProfile;
  const UserView({Key? key, this.animationController, required this.userProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animationController!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animationController!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
              child: FutureBuilder<Map<String, dynamic>>(
                future: userProfile,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final profileData = snapshot.data!;
                    return _buildUserInfo(profileData);
                  } else {
                    return const Center(child: Text('No user profile data available'));
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> profileData) {
    return profileData.isEmpty
        ? const Center(child: Text('No user profile data available'))
  :   Container(
      decoration: BoxDecoration(
        color: FitnessAppTheme.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topRight: Radius.circular(68.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: FitnessAppTheme.grey.withOpacity(0.2),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Full Name: ${profileData['fullName'] ?? 'N/A'}',
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: FitnessAppTheme.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Username: ${profileData['userName'] ?? 'N/A'}',
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: FitnessAppTheme.grey.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: ${profileData['email'] ?? 'N/A'}',
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: FitnessAppTheme.grey.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gender: ${profileData['gender'] ?? 'N/A'}',
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: FitnessAppTheme.grey.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Activity Level: ${profileData['activityLevel'] ?? 'N/A'}',
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: FitnessAppTheme.grey.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Height: ${profileData['height'] ?? 'N/A'} cm',
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: FitnessAppTheme.grey.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Weight: ${profileData['weight'] ?? 'N/A'} kg',
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: FitnessAppTheme.grey.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
