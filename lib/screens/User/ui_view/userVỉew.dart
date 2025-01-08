import 'package:fe_nhom2/models/user_post.dart';
import 'package:flutter/material.dart';
import 'package:fe_nhom2/theme/home_app_theme.dart';
import 'package:fe_nhom2/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../introduction_infomation/introduction_screen.dart';

class UserView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const UserView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late Future<User?> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = UserService.fetchData();
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
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding:
              const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
              child: FutureBuilder<User?>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final userData = snapshot.data!;
                    return _buildUserInfo(userData);
                  } else {
                    return const Center(child: Text('No user data available'));
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(User userData) {
    return Container(
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
                  'Name: ${userData.userName ?? 'N/A'}',
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: FitnessAppTheme.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: ${userData.email ?? 'N/A'}',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Height: ${userData.height?.toStringAsFixed(1) ?? 'N/A'} cm',
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: FitnessAppTheme.darkText,
                  ),
                ),
                Text(
                  'Weight: ${userData.weight?.toStringAsFixed(1) ?? 'N/A'} kg',
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: FitnessAppTheme.darkText,
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
