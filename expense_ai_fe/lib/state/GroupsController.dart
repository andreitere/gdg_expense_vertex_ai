import 'package:dio/dio.dart';
import 'package:expense_ai_fe/api/api.dart';
import 'package:expense_ai_fe/misc/utils.dart';
import 'package:expense_ai_fe/models/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupsController extends GetxController {
  final APIClient _apiClient;
  final GetStorage _box;
  final RxBool processingReceipt = false.obs;
  final RxBool creatingGroup = false.obs;
  var loggedIn = false.obs;
  Rx<List<UserGroup>> groups = Rx<List<UserGroup>>([]);

  GroupsController()
      : _apiClient = Get.find<APIClient>(),
        _box = GetStorage() {
    print("init groups controller");
  }

  Future<void> loadGroups() async {
    dynamic response = await _apiClient.get("/groups/");

    List<UserGroup> _groups = (response.data as List).map((data) => UserGroup.fromJson(data)).toList();
    groups.value = _groups;
    print(groups.value);
    if (response.data is List<Map<String, dynamic>>) {}
  }

  Future<UserGroup> getGroup(int groupId) async {
    dynamic response = await _apiClient.get("/groups/$groupId");

    UserGroup group = UserGroup.fromJson(response.data as Map<String, dynamic>);
    return group;
  }

  Future<ExpensesReceipt> createExpense(String imageStr) async {
    processingReceipt.value = true;
    dynamic response = await _apiClient.post("/expenses/itemize", data: {
      "image_str": imageStr,
    });
    processingReceipt.value = false;
    return ExpensesReceipt.fromJson(response.data);
  }

  Future<CreatedGroup> createGroup(String description) async {
    creatingGroup.value = true;
    dynamic response = await _apiClient.post("/groups/", data: {
      "description": description
    });
    creatingGroup.value = false;
    return CreatedGroup.fromJson(response.data);
  }
}
