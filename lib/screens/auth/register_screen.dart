import 'package:fe_nhom2/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../home_screen.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({Key? key}) : super(key: key);

  @override
  _registerScreenState createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController()..addListener(_updateFieldValidity);
    passwordController = TextEditingController()..addListener(_updateFieldValidity);
    confirmPasswordController = TextEditingController()..addListener(_updateFieldValidity);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateFieldValidity() {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    fieldValidNotifier.value = email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty;
  }

  void _register() {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      _showDialog('Đăng ký thất bại', 'Mật khẩu không khớp.');
      return;
    }

    // Giả lập đăng ký thành công
    _showDialog('Đăng ký thành công', 'Bạn đã đăng ký thành công!', isSuccess: true);
  }

  void _showDialog(String title, String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => homeScreen()),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE2ECEC),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildGradientHeader(),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEmailField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 16),
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 20),
                  _buildRegisterButton(),
                  const SizedBox(height: 20),
                  _buildSocialLoginOptions(),
                  const SizedBox(height: 20),
                  _buildRegisterOption(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientHeader() {
    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('hinhnenlogin_dangky.jpg'), // Đường dẫn tới ảnh
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xFF38826C).withOpacity(0.8), // Gradient trong suốt
            Color(0xFF38826C).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF38826C).withOpacity(0.7), // Overlay gradient
              Colors.transparent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextWithOutline(
              "Chào mừng bạn đến với đăng ký!",
              fontSize: 20,
            ),
            SizedBox(height: 6),
            _buildTextWithOutline(
              "Điền thông tin để tạo tài khoản mới",
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextWithOutline(String text, {double fontSize = 16}) {
    return Stack(
      children: [
        // Viền đen
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = Colors.black,
          ),
        ),
        // Chữ trắng
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
          ),
        ),
      ],
    );
  }



  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildPasswordField() {
    return ValueListenableBuilder<bool>(
      valueListenable: passwordNotifier,
      builder: (context, obscureText, _) {
        return TextFormField(
          controller: passwordController,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: 'Mật khẩu',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                passwordNotifier.value = !obscureText;
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return ValueListenableBuilder<bool>(
      valueListenable: passwordNotifier,
      builder: (context, obscureText, _) {
        return TextFormField(
          controller: confirmPasswordController,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: 'Xác nhận mật khẩu',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                passwordNotifier.value = !obscureText;
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegisterButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: fieldValidNotifier,
      builder: (context, isValid, _) {
        return ElevatedButton(
          onPressed: isValid ? _register : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            'Đăng Ký',
            style: TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }

  Widget _buildSocialLoginOptions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Hoặc đăng nhập với"),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset('assets/vectors/google.svg', width: 20),
              label: const Text("Google"),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset('assets/vectors/facebook.svg', width: 20),
              label: const Text("Facebook"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Bạn đã có tài khoản?"),
        TextButton(
          onPressed: _navigateToLogin,
          child: const Text("Đăng Nhập"),
        ),
      ],
    );
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const loginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }
}
