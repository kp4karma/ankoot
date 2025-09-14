import 'dart:convert';

import 'package:ankoot_new/api/api_endpoints.dart';
import 'package:ankoot_new/models/event_data_model.dart';
import 'package:ankoot_new/models/evet_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';

import '../../helper/toast/toast_helper.dart';
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

  static Future<List<Data>> fetchEvents() async {
    try {
      EasyLoading.show(status: "Fetching events...");

      final Response response = await ApiClient.post(
        ApiEndpoints.getData,
        data: {"table": "event"},
      );

      print("🔹 [Event] Status: ${response.statusCode}");
      print("🔹 [Event] Response: ${response.data}");

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final eventDataModel = EventDataModel.fromJson(response.data);

        if (eventDataModel.errorStatus == true) {
          EasyLoading.showError("Failed to fetch events");
          return [];
        }

        return eventDataModel.data ?? [];
      } else {
        EasyLoading.showError("API Error: ${response.statusMessage}");
        return [];
      }
    } catch (e, stack) {
      print("❌ [Event] Error: $e");
      print(stack);
      EasyLoading.showError("Something went wrong: $e");
      return [];
    } finally {
      EasyLoading.dismiss();
    }
  }


  // static Future<PradeshItemsDataModel?> fetchPradeshItems(int eventId) async {
  //   try {
  //     EasyLoading.show(status: "Fetching Pradesh Items...");
  //
  //     final Response response = await ApiClient.post(
  //       ApiEndpoints.getPradeshItems,
  //       data: {"event_id": eventId},
  //     );
  //
  //     print("🔹 [Pradesh] Status: ${response.statusCode}");
  //     print("🔹 [Pradesh] Response: ${response.data}");
  //
  //     if (response.statusCode != null &&
  //         response.statusCode! >= 200 &&
  //         response.statusCode! < 300) {
  //       final dataModel = PradeshItemsDataModel.fromJson(response.data);
  //
  //       if (dataModel.errorStatus == true) {
  //         EasyLoading.showError("Failed to fetch Pradesh items");
  //         return null;
  //       }
  //       return dataModel;
  //     } else {
  //       EasyLoading.showError("API Error: ${response.statusMessage}");
  //       return null;
  //     }
  //   } catch (e, stack) {
  //     print("❌ [Pradesh] Error: $e");
  //     print(stack);
  //     EasyLoading.showError("Something went wrong: $e");
  //     return null;
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }



 static Future<FoodDistributionResponse> getFoodDistributionData() async {
    try {
      final Response response = await ApiClient.post(
        ApiEndpoints.getPradeshItems,
        data: {},
      );
      print(response);
      final data = FoodDistributionResponse.fromJson(jsonDecode(response.toString()));
      return data;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
