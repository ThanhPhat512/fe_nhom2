import 'package:fe_nhom2/screens/home_screen.dart';
import 'package:fe_nhom2/screens/introduction_infomation/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fe_nhom2/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Đọc giá trị từ SharedPreferences sau khi app được khởi tạo
  final prefs = await SharedPreferences.getInstance();
  final String? name = prefs.getString('userId');
  runApp(MyApp(name: name));
}

class MyApp extends StatelessWidget {
  final String? name;

  MyApp({this.name});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Good Food',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Điều hướng đến HomeScreen nếu có 'name', nếu không điều hướng đến IntroductionScreen
      home: name != null && name!.isNotEmpty ? homeScreen() : IntroductionAnimationScreen(),
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