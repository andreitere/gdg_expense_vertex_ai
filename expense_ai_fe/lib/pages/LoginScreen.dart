import 'package:expense_ai_fe/constants/app_colors.dart';
import 'package:expense_ai_fe/main.dart';
import 'package:expense_ai_fe/state/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController authCtrl = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    if (authCtrl.loggedIn.value == true) {
      router.go("/");
    }
    return Container(
      padding: const EdgeInsets.only(right: 50.0, left: 50),
      constraints: const BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Image(
                  image: AssetImage('assets/logo.png'),
                  height: 250.0,
                  fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50, top: 50),
              child: Text(
                "Connect",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Focus(
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Focus(
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            OutlinedButton(
              onPressed: onLogin,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: AppColors.darkBlue, width: 2.0), // Dark blue outline
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
              ),
              child: Text('Continue',
                  style: TextStyle(
                    color: AppColors.darkBlue,
                  ) // Text color matching the outline
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void onLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    // Add your login logic here
    await authCtrl.login(email, password);
  }
}
