import 'package:ankoot_new/api/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';

import '../../helper/toast/toast_helper.dart';
import '../../models/event.dart'; // <- where your UserDataModel, UserData, User are defined
import '../../models/user_data_model.dart';
import '../api_client.dart';

class GeneralService {
  static Future<bool> systemUserLogin({
    required BuildContext context,
    required String userMobile,
  }) async {
    try {
      EasyLoading.show(status: "Logging in...");

      final Response response = await ApiClient.post(
        ApiEndpoints.login,
        data: {"user_mobile": userMobile.trim()},
      );

      print("🔹 [Login] Status: ${response.statusCode}");
      print("🔹 [Login] Response: ${response.data}");

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // Parse into UserDataModel
        final userDataModel = UserDataModel.fromJson(response.data);

        if (userDataModel.errorStatus == true) {
          EasyLoading.showError("Login failed");
          return false;
        }

        final user = userDataModel.data?.user;
        final msg = userDataModel.data?.msg ?? "Login successful";

        if (user == null) {
          EasyLoading.showError("Invalid user data");
          return false;
        }

        showToast(
          context: context,
          title: msg,
          type: ToastType.success,
          message: 'Welcome ${user.userName}',
        );

        // You also get token here
        print("🔑 Token: ${userDataModel.data?.token}");

        return true;
      } else {
        EasyLoading.showError("Login failed: ${response.statusMessage}");
        return false;
      }
    } catch (e, stack) {
      print("❌ [Login] Error: $e");
      print(stack);
      EasyLoading.showError("Something went wrong: $e");
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
