import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../models/user_data_model.dart';

class UserStorageKeys {
  static const String userData = 'userData';
  static const String token = 'token';
  static const String refreshToken = 'refreshToken';
}





class UserStorageHelper {
  static final GetStorage _box = GetStorage();

  /// Initialize GetStorage
  static Future<void> init() async {
    await GetStorage.init();
  }

  static void saveUserData(UserDataModel model) {
    try {
      final jsonString = jsonEncode(model.toJson());
      _box.write(UserStorageKeys.userData, jsonString);

      // Save tokens separately if needed
      if (model.data?.token != null) {
        _box.write(UserStorageKeys.token, model.data!.token);
      }
      if (model.data?.refreshToken != null) {
        _box.write(UserStorageKeys.refreshToken, model.data!.refreshToken);
      }
    } catch (e) {
      print("❌ Error saving user data: $e");
    }
  }

  static UserDataModel? getUserData() {
    String? jsonString = _box.read<String>(UserStorageKeys.userData);
    if (jsonString == null) return null;

    try {
      return UserDataModel.fromJson(jsonDecode(jsonString));
    } catch (e) {
      print("❌ Error decoding UserDataModel: $e");
      return null;
    }
  }

  /// Get only User object
  static User? getUser() {
    return getUserData()?.data?.user;
  }

  /// Get Token
  static String? getToken() {
    return _box.read<String>(UserStorageKeys.token);
  }

  /// Get Refresh Token
  static String? getRefreshToken() {
    return _box.read<String>(UserStorageKeys.refreshToken);
  }

  /// Clear all user data
  static void clearUserData() {
    _box.remove(UserStorageKeys.userData);
    _box.remove(UserStorageKeys.token);
    _box.remove(UserStorageKeys.refreshToken);
  }

  /// Check if logged in
  static bool isLoggedIn() {
    String? token = getToken();
    return token != null && token.isNotEmpty;
  }
}
