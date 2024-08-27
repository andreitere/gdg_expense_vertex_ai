import 'package:expense_ai_fe/state/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthController authCtrl = Get.find<AuthController>();

  void onLogout() {
    authCtrl.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Photo
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(authCtrl.user.value!.photo),
            ),
            SizedBox(height: 20),
            // User Email
            Text(
              authCtrl.user.value!.email,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            // Logout Button
            OutlinedButton(
              onPressed: onLogout,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red), // Red border
              ),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
