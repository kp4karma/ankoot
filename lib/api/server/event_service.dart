import 'package:dio/dio.dart';

import '../api_client.dart';
import '../api_endpoints.dart';


class EventService {
  /// Create a new event
  static Future<bool> createNewEvent({
    required String eventName,
    required String personName,
    required String mobile,
    required String eventDate,
    required String maxPrasadDate,
    required String itemLastDate,
  }) async {
    try {
      // Prepare body
      final data = {
        "event_name": eventName,
        "person_name": personName,
        "mobile": mobile,
        "event_date": eventDate,
        "event_max_prasad_date": maxPrasadDate,
        "event_item_last_date": itemLastDate,
      };

      // Send request
      Response response = await ApiClient.post(
        ApiEndpoints.createNewEvent,
        data: data,
      );

      // Success if created
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      print("❌ createNewEvent failed: $e");
      return false;
    }
  }
}
