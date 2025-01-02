import 'package:fe_nhom2/screens/auth/login_screen.dart';
import 'package:fe_nhom2/screens/auth/register_screen.dart';
import 'package:fe_nhom2/screens/home_screen.dart';
import 'package:fe_nhom2/screens/introduction_infomation/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fe_nhom2/theme/app_theme.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Good Food',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      home: IntroductionAnimationScreen(),
      // home: RegisterScreen(),
      //     home: homeScreen(),
      // home: LoginScreen(),
    );
  }
}


class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}