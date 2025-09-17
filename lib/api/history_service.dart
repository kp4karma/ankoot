import 'package:ankoot_new/api/api_client.dart';
import 'package:ankoot_new/api/api_endpoints.dart';
import 'package:ankoot_new/models/user_history.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HistoryServices {
  static Future<UserHistory> fetchHistory({
    required String pradeshId,
    required String eventId,
  }) async {
    try {
      EasyLoading.show(status: "Fetching events...");

      final Response response = await ApiClient.post(
        ApiEndpoints.fetchHistory,
        // data: {"pradesh_id": 1, "event_id": 1},
        data: {"pradesh_id": pradeshId, "event_id": eventId},
      );

      print("🔹 [Event] Status: ${response.statusCode}");
      print("🔹 [Event] Response: ${response.data}");

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final eventDataModel = UserHistory.fromJson(response.data);

        if (eventDataModel.errorStatus == true) {
          EasyLoading.showError("Failed to fetch events");
          return UserHistory();
        }

        return eventDataModel;
      } else {
        EasyLoading.showError("API Error: ${response.statusMessage}");
        return UserHistory();
      }
    } catch (e, stack) {
      print("❌ [Event] Error: $e");
      print(stack);
      EasyLoading.showError("Something went wrong: $e");
      return UserHistory();
    } finally {
      EasyLoading.dismiss();
    }
  }
}
