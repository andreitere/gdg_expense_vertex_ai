import 'package:dio/dio.dart';
import 'package:expense_ai_fe/api/api.dart';
import 'package:expense_ai_fe/misc/utils.dart';
import 'package:expense_ai_fe/models/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final APIClient _apiClient;
  final GetStorage _box;

  var loggedIn = false.obs;
  Rx<UserProfile?> user = Rx<UserProfile?>(null);

  AuthController()
      : _apiClient = Get.find<APIClient>(),
        _box = GetStorage() {
    Map<String, dynamic>? storedUser = _box.read("user_details");
    if (storedUser != null) {
      user.value = UserProfile.fromJson(storedUser);
    }
    loggedIn.value = _box.read("loggedIn") == 1 ? true : false;
  }
  init() async {}

  login(String email, String password) async {
    if (!isValidEmail(email)) {
      Get.showSnackbar(
        GetSnackBar(
          title: "Error",
          message: 'Invalid email',
          icon: const Icon(Icons.error),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }
    try {
      dynamic response = await _apiClient.post("/auth/connect",
          data: {"username": email, "password": password});
      if (response.data is Map<String, dynamic>) {
        String? accessToken = response.data['access_token'];
        if (accessToken != null) {
          _box.write("access_token", accessToken);
          _box.write("loggedIn", 1);
          loggedIn.value = true;
          _box.write("user_details", response.data["user"]);
          user.value = UserProfile.fromJson(response.data["user"]);
          Get.toNamed("/");
        } else {
          Get.showSnackbar(
            GetSnackBar(
              title: "Error",
              message: "Oups. There's seems to be a problem with the backend",
              icon: const Icon(Icons.error),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } on DioException catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: "Error",
          message: e.response!.data?["detail"],
          icon: const Icon(Icons.error),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    // prefs.setBool("loggedIn", true);
  }

  logout() async {
    loggedIn.value = false;
    _box.write("loggedIn", 0);
    _box.erase();
  }
}
