import '../api/server/general_service.dart';
import 'package:flutter/material.dart';

class PradeshController {
  /// Insert Pradesh Data
  static Future<bool> insertPradeshData({
    required String pradeshId,
    required String eventId,
    required String itemId,
    required String quantity,
    required String pradeshEngName,
    required String pradeshGujName,
    required String foodEngName,
    required String foodGujName,
    required String personName,
    required String personMobile,


  }) async {
    final Map<String, dynamic> payload = {
      "table": "defaultStock",
      "pradesh_id": pradeshId,
      "event_id": eventId,
      "food_item_id": itemId,
      "food_qty": quantity, // 👈 spelling matches API body
      "pradesh_guj_name": pradeshGujName,
      "pradesh_eng_name": pradeshEngName,
      "food_eng_name": foodEngName,
      "food_guj_name": foodGujName,
      "person_name": personName,
      "person_mobile": personMobile,
      "type":"DR"
    };

    return await GeneralService.insertData(payload);
  }

  static Future<bool> updatePradeshItemData({
    required String pradeshId,
    required String eventId,
    required int id,
    required String itemId,
    required String quantity,
    required String pradeshEngName,
    required String pradeshGujName,
    required String foodEngName,
    required String foodGujName,
    required String personName,
    required String personMobile,


  }) async {
    final Map<String, dynamic> payload = {
      "table": "defaultStock",
      "pradesh_id": pradeshId,
      "id": id,
      "event_id": eventId,
      "food_item_id": itemId,
      "food_qty": quantity,
      "pradesh_guj_name": pradeshGujName,
      "pradesh_eng_name": pradeshEngName,
      "food_eng_name": foodEngName,
      "food_guj_name": foodGujName,
      "person_name": personName,
      "person_mobile": personMobile,
      "type":"DR"
    };

    return await GeneralService.updateData(payload);
  }


  static Future<bool> deletePradeshItemData({
    required String pradeshId,
    required String eventId,
    required int id,
    required String personName,
    required String personMobile,


  }) async {
    final Map<String, dynamic> payload = {
      "table": "defaultStock",
      "pradesh_id": pradeshId,
      "id": id,
      "event_id": eventId,
      "person_name": personName,
      "person_mobile": personMobile,
      "type":"DR"
    };

    return await GeneralService.deleteData(payload);
  }


  static Future<bool> assignItemToPradesh({
    required String pradeshId,
    required String eventId,



  }) async {
    final Map<String, dynamic> payload = {
      "pradesh_id": pradeshId,
      "event_id": eventId,
    };

    return await GeneralService.assignToPradesh(payload);
  }

}
