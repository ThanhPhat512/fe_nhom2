import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'register_screen.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController()..addListener(_updateFieldValidity);
    passwordController = TextEditingController()..addListener(_updateFieldValidity);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _updateFieldValidity() {
    final email = emailController.text;
    final password = passwordController.text;
    fieldValidNotifier.value = email.isNotEmpty && password.isNotEmpty;
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const registerScreen(),
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
                  _buildForgotPasswordButton(),
                  const SizedBox(height: 20),
                  _buildLoginButton(),
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
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF38826C), Color(0xFF38826C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chào mừng bạn trở lại!",
            style: TextStyle(color: Colors.white, fontSize: 20), // Hoặc bất kỳ các thuộc tính khác cần thiết
          ),
          SizedBox(height: 6),
          Text(
            "Đăng nhập để tiếp tục",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
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

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Quên mật khẩu?',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: fieldValidNotifier,
      builder: (context, isValid, _) {
        return ElevatedButton(
          onPressed: isValid
              ? () {
            // Handle login logic
          }
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            'Đăng Nhập',
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
        const Text("Chưa có tài khoản?"),
        TextButton(
          onPressed: _navigateToRegister,
          child: const Text("Đăng Ký"),
        ),
      ],
    );
  }
}
