
import 'package:ankoot_new/api/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_connect/http/src/response/response.dart' hide Response;

import '../../helper/toast/toast_helper.dart';
import '../../models/event.dart';
import '../api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class GeneralService {
  static Future<bool> systemUserLogin({required BuildContext context,required String userMobile}) async {
    try {
      EasyLoading.show();
      Response response = await ApiClient.post(
        ApiEndpoints.login,
        data: {"user_mobile": userMobile.trim()},
      );
      if (response.statusCode == 200) {
        User user = User.fromJson(response.data);

        showToast(
          context: context,
          title: 'Login successful ',
          type: ToastType.success,
          message: 'Login successful for user: ${user.name}',
        );
        return true;
      }

      return false;
    } catch (e) {
      var errorData = e.toString().replaceAll("Exception: ", "");
      EasyLoading.showError(errorData);
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

}