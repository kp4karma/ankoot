import 'dart:convert';

import 'package:ankoot_new/api/api_endpoints.dart';
import 'package:ankoot_new/api/services/fcm_service.dart';
import 'package:ankoot_new/models/event_data_model.dart';
import 'package:ankoot_new/models/evet_items.dart';
import 'package:ankoot_new/theme/storage_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../../helper/toast/toast_helper.dart';
import '../../models/item_master_model.dart';
import '../../models/user_data_model.dart';
import '../api_client.dart';

class GeneralService {
  /// Insert Data
  static Future<bool> insertData(Map<String, dynamic> payload) async {
    return _sendRequest(ApiEndpoints.insertData, payload, "Insert");
  }

  static Future<bool> savePrasadData(Map<String, dynamic> payload) async {
    try {
      final Response response = await ApiClient.post(
        ApiEndpoints.savePrasadData,
        data: payload,
      );

      // You can adjust this depending on how your backend responds
      final Map<String, dynamic> jsonResponse = jsonDecode(response.toString());

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ savePrasadData error: $e");
      return false;
    }
  }


  /// Update Data
  static Future<bool> updateData(Map<String, dynamic> payload) async {
    return _sendRequest(ApiEndpoints.updateData, payload, "Update");
  }

  /// Delete Data
  static Future<bool> deleteData(Map<String, dynamic> payload) async {
    return _sendRequest(ApiEndpoints.deleteData, payload, "Delete");
  }

  static Future<bool> assignToPradesh(Map<String, dynamic> payload) async {
    return _sendRequest(ApiEndpoints.assignItemsToPradesh, payload, "Assign");
  }

  /// Common Request Handler
  static Future<bool> _sendRequest(
    String endpoint,
    Map<String, dynamic> payload,
    String action,
  ) async {
    try {
      EasyLoading.show(status: "$action in progress...");

      final Response response = await ApiClient.post(endpoint, data: payload);

      print("🔹 [$action] Status: ${response.statusCode}");
      print("🔹 [$action] Response: ${response.data}");

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final resp = response.data;

        if (resp["errorStatus"] == true) {
          EasyLoading.showError("$action failed");
          return false;
        }

        EasyLoading.showSuccess("$action successful");
        return true;
      } else {
        EasyLoading.showError("API Error: ${response.statusMessage}");
        return false;
      }
    } catch (e, stack) {
      print("❌ [$action] Error: $e");
      print(stack);
      EasyLoading.showError("Something went wrong: $e");
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

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

        UserStorageHelper.setUserData(userDataModel);
        if (user == null) {
          EasyLoading.showError("Invalid user data");
          return false;
        }

        final NotificationService notificationService = Get.find();

        if(!kIsWeb){
          await notificationService.initializeUserSubscriptions(eventIds: [],pradeshIds: ["${userDataModel.data?.pradeshAssignment?.pradeshId.toString()}"],userId: user.userId.toString(), userType: user.userType.toString());

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


  static Future<List<ItemMasterData>> fetchItemMasterData() async {
    try {
      EasyLoading.show(status: "Fetching item master data...");

      final Response response = await ApiClient.post(
        ApiEndpoints.getData,
        data: {"table": "foodItems"},
      );

      print("🔹 [ItemMaster] Status: ${response.statusCode}");
      print("🔹 [ItemMaster] Response: ${response.data}");

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final itemMasterDataModel =
        ItemMasterDataModel.fromJson(response.data);

        if (itemMasterDataModel.errorStatus == true) {
          EasyLoading.showError("Failed to fetch item master data");
          return [];
        }

        return itemMasterDataModel.data ?? [];
      } else {
        EasyLoading.showError("API Error: ${response.statusMessage}");
        return [];
      }
    } catch (e, stack) {
      print("❌ [ItemMaster] Error: $e");
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

  static Future<FoodDistributionResponse> getFoodDistributionData({
    bool isDefault = false,
  }) async {
    try {
      print(
        "getFoodDistributionDatagetFoodDistributionDatagetFoodDistributionData ${isDefault}",
      );
      final Response response = await ApiClient.post(
        isDefault
            ? ApiEndpoints.getDefaultPradeshItems
            : ApiEndpoints.getPradeshItems,
        data: {},
      );
      print(response);
      final data = FoodDistributionResponse.fromJson(
        jsonDecode(response.toString()),
      );
      return data;
    } catch (e) {
      print("sdsdds $e");
      throw Exception('Failed to load data: $e');
    }
  }
}
