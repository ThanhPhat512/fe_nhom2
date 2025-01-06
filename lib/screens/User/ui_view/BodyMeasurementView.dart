import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../config/config_url.dart';
import '../../../models/user_post.dart';
import '../../introduction_infomation/introduction_screen.dart';
import 'package:fe_nhom2/theme/home_app_theme.dart';

class BodyMeasurementView extends StatefulWidget {
  final Animation<double>? animation;
  final AnimationController? animationController;

  const BodyMeasurementView({Key? key, this.animation, this.animationController}) : super(key: key);

  @override
  _BodyMeasurementViewState createState() => _BodyMeasurementViewState();
}

Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId'); // 'userId' là key đã lưu
}

class _BodyMeasurementViewState extends State<BodyMeasurementView> {
  // Controller cho các TextField
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController waistController = TextEditingController();
  final TextEditingController chestController = TextEditingController();

  final String apiUrl = '${Config_URL.baseUrl}api/Post';
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;
  late User user; // Biến lưu trữ thông tin người dùng
  String? token; // Biến lưu trữ token của người dùng
  String? errorMessage;

  Future<void> fetchPosts(String userId) async {
    final response = await http.get(Uri.parse('${Config_URL.baseUrl}api/Post/user/$userId'));

    if (response.statusCode == 200) {
      final postsData = json.decode(response.body);
      setState(() {
        posts = List<Map<String, dynamic>>.from(postsData);
        isLoading = false;
      });
    } else {
      print('Error fetching posts: ${response.statusCode}');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load posts';
      });
    }
  }

  // Hàm lấy token từ SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Hàm xóa token khỏi SharedPreferences khi người dùng đăng xuất
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('userId');

    // Điều hướng về màn hình login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const IntroductionAnimationScreen()),
    );
  }

  Future<void> fetchUser() async {
    try {
      final response = await http.get(
        Uri.parse('${Config_URL.baseUrl}api/User/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          user = User.fromJson(data);
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load user data: ${response.body}';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        errorMessage = 'Error occurred while fetching user data: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getToken().then((tokenValue) {
      if (tokenValue != null) {
        setState(() {
          token = tokenValue;
        });
        getUserId().then((userId) {
          if (userId != null) {
            fetchPosts(userId); // Tải bài đăng nếu có userId
            fetchUser(); // Tải thông tin người dùng
          } else {
            setState(() {
              isLoading = false;
              errorMessage = 'UserId not found. Please login again.';
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Token not found. Please login again.';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          user != null
                              ? Text(
                            'Name: ${user.userName}',
                            style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: -0.1,
                                color: FitnessAppTheme.darkText),
                          )
                              : Text('Loading user data...'),
                          SizedBox(height: 8),
                          user != null
                              ? Text('Email: ${user.email}',
                              style: TextStyle(fontSize: 16))
                              : Text('Loading email...'),
                          SizedBox(height: 16),
                          // Nút logout
                          ElevatedButton(
                            onPressed: logout,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: Text('Logout'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                    // Các phần hiển thị thông tin như cân nặng, chiều cao, BMI...
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
