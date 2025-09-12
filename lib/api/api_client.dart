import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as get_x;
import 'package:package_info_plus/package_info_plus.dart';



import '../theme/_logger.dart';
import '../theme/encryption_decryption.dart';
import '../theme/log_helper.dart';
import 'api_endpoints.dart';

class ApiClient {
  static Dio? _client;
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  static String currentAppVersion = '';
  static int lastResponseTimeMs = 0; // ✅ Global response time variable

  ApiClient._internal();

  static Future<void> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (kIsWeb) {
      currentAppVersion = packageInfo.version;
    } else {
      currentAppVersion = Platform.isAndroid ? "2" : packageInfo.buildNumber;
    }

    if (_client == null) {
      _client = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl, connectTimeout: const Duration(seconds: 15), receiveTimeout: const Duration(seconds: 15), headers: {'Content-Type': 'application/json'}));

      _client!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // ✅ store start time
            options.extra['startTime'] = DateTime.now();
            lastResponseTimeMs = 0; // reset for UI while waiting

            String? token = "";
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }

            if (options.data != null && options.data is! FormData) {
              if (options.data is Map || options.data is List) {
                options.extra['_originalData'] = options.data;
                if (['POST', 'PUT', 'DELETE'].contains(options.method)) {
                  options.data = jsonEncode(options.data);
                }
              }
            }
            if (options.data is FormData) {
              options.headers['Content-Type'] = 'multipart/form-data';
            }

            if (!options.path.contains('http')) {
              options.path = ApiConfig.baseUrl + options.path;
            }
            options.headers['X-App-Version'] = "$currentAppVersion-${getOSType()}";

            if (kDebugMode) {
              log('📤 REQUEST');
              log('➡️ [${options.method}] ${options.uri}');
              log('🔘 Headers: ${options.headers}');
              log('📝 Data: ${options.data}');
            }

            return handler.next(options);
          },
          onResponse: (response, handler) {
            final startTime = response.requestOptions.extra['startTime'] as DateTime?;
            if (startTime != null) {
              // Fresh diff per request
              lastResponseTimeMs = DateTime.now().difference(startTime).inMilliseconds;
              if (kDebugMode) {
                print("⏱ Response time: ${lastResponseTimeMs} ms");
              }
              // Also attach to response.extra for direct access
              response.extra['responseTimeMs'] = lastResponseTimeMs;
            }

            if (response.statusCode == 200 || response.statusCode == 201) {
              return handler.next(response);
            }
            return handler.reject(DioException(requestOptions: response.requestOptions, response: response, type: DioExceptionType.badResponse));
          },
          onError: (DioException error, handler) async {
            final startTime = error.requestOptions.extra['startTime'] as DateTime?;
            if (startTime != null) {
              lastResponseTimeMs = DateTime.now().difference(startTime).inMilliseconds;
              if (kDebugMode) {
                print("⏱ Error response time: ${lastResponseTimeMs} ms");
              }
            }
            if (kDebugMode) {
              print("🔗 Request URL: ${error.requestOptions.uri}");
              print("🟡 Request Method: ${error.requestOptions.method}");
            }

            // ... keep your existing error handling
            return handler.next(error);
          },
        ),
      );
    }
  }

  // static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
  //   String? newAccessToken = await _refreshToken();
  //   if (newAccessToken != null) {
  //     requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
  //     return _client!.fetch<dynamic>(requestOptions);
  //   } else {
  //     return Response(
  //       requestOptions: requestOptions,
  //       statusCode: 440, // Unauthorized
  //       data: {"error": "Refresh token expired. Please re-login."},
  //     );
  //   }
  // }

  // static Future<String?> _refreshToken() async {
  //   StorageHelper.setValue(key: StorageKeys.accessToken, value: "");
  //
  //   String? refreshToken = StorageHelper.getValue(key: StorageKeys.refreshToken);
  //   if (refreshToken == null || refreshToken.isEmpty) {
  //     _forceLogout();
  //     return null;
  //   }
  //
  //   try {
  //     final response = await _client!.post(
  //       ApiEndpoints.refresh,
  //       options: Options(headers: {'Content-Type': 'application/json'}),
  //       data: addExtraParameters({"refresh_token": StorageHelper.getValue(key: StorageKeys.refreshToken)}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       String newAccessToken = response.data['access'];
  //       String newRefreshToken = response.data['refresh'];
  //
  //       StorageHelper.setValue(key: StorageKeys.accessToken, value: newAccessToken);
  //       StorageHelper.setValue(key: StorageKeys.refreshToken, value: newRefreshToken);
  //
  //       if (kDebugMode) {
  //         print("✅ Token refreshed successfully!");
  //       }
  //       return newAccessToken;
  //     } else if (response.statusCode == 401) {
  //       if (kDebugMode) {
  //         print("🔴 Refresh token expired. Logging out...");
  //       }
  //       _forceLogout(); // Call logout function
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("🔴 Token refresh failed: $e");
  //     }
  //     _forceLogout();
  //   }
  //
  //   return null;
  // }

  // static void _forceLogout() {
  //   if (kDebugMode) {
  //     print("🔴 Logging out user...");
  //   }
  //
  //   StorageHelper.setValue(key: StorageKeys.accessToken, value: "");
  //   StorageHelper.setValue(key: StorageKeys.refreshToken, value: "");
  //   get_x.Get.offAll(() => SplashScreen());
  // }

  // static Future<String?> _getAccessToken() async {
  //   return StorageHelper.getValue(key: StorageKeys.accessToken);
  // }

  // static Future<bool> _shouldRetry(DioException error) async {
  //   if (error.response?.data['detail'].toString() == "Authentication error: Invalid or expired token.") {
  //     String? refreshToken = StorageHelper.getValue(key: StorageKeys.refreshToken);
  //     if (refreshToken != null && refreshToken.isNotEmpty) {
  //       if (kDebugMode) {
  //         print("🔄 Should retry: 403 detected & refresh token is available.");
  //       }
  //       return true;
  //     } else {
  //       if (kDebugMode) {
  //         print("🔴 Should NOT retry: No valid refresh token found.");
  //       }
  //       return false;
  //     }
  //   } else if (error.response?.data['detail'].toString() == "Authentication error: Please install latest app version") {
  //     print("object");
  //     EasyLoading.showError(error.response!.data['detail'].toString().split(":").last.trim().toString(), duration: Duration(days: 3));
  //   }
  //   return false;
  // }

  static Future<Response<dynamic>> get(String path, {Map<String, dynamic>? queryParams, Map<String, dynamic>? customHeaders}) async {
    try {
      Response response = await _client!.get(
        path,
        queryParameters: await addExtraParameters(queryParams ?? {}),
        options: Options(headers: customHeaders),
      );
      return response;
    } on DioException catch (e) {
      print("Messsssss " + e.error.toString());
      print("Messsssss " + e.response.toString());

      throw _handleError(e);
    }
  }

  static Future<Response<dynamic>> post(String path, {Map<String, dynamic>? data, Map<String, dynamic>? queryParams, Map<String, dynamic>? customHeaders}) async {
    try {
      devLogger("PATH : ${path}\nDATA : ${data}");
      Response response = await _client!.post(path, data: await addExtraParameters(data ?? {}), queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      print(e);
      throw _handleError(e);
    }
  }

  static Future<Response<dynamic>> postMedia(String path, {required FormData data}) async {
    try {
      final processedData = addExtraParametersFromDataForMedia(data);
      Response response = await _client!.post(
        path,
        data: processedData,
        options: Options(contentType: "multipart/form-data"),
      );
      return response;
    } on DioException catch (e) {
      print(e);
      throw _handleError(e);
    }
  }

  static Future<Response<dynamic>> put(String path, {Map<String, dynamic>? data, Map<String, dynamic>? queryParams, Map<String, dynamic>? customHeaders}) async {
    try {
      print("addExtraParameters(data ?? {}) ${addExtraParameters(data ?? {})}");
      Response response = await _client!.put(path, data: await addExtraParameters(data ?? {}), queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<Response<dynamic>> delete(String path, {Map<String, dynamic>? data, Map<String, dynamic>? queryParams, Map<String, dynamic>? customHeaders}) async {
    try {
      Response response = await _client!.delete(
        path,
        data: addExtraParameters(data ?? {}),
        queryParameters: queryParams,
        options: Options(headers: customHeaders),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Exception _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final errorData = error.response?.data;
      final message = errorData['detail'] ?? errorData['message'] ?? 'Unknown error message';

      final logMessage = 'Status: $statusCode, Message: $message, Response: $errorData';

      print("Logsssss ${logMessage}");
      SecureLogger.write(logMessage); // Save to file

      switch (statusCode) {
        case 400:
        case 401:
        case 403:
        case 404:
        case 440:
        case 500:
          print("🛑 Error $statusCode: $message");
          return Exception(message);
        default:
          return Exception("⚠️ Error: $errorData");
      }
    }

    SecureLogger.write("Unknown Dio Error: ${error.message}");
    return Exception("⚠️ Unknown Error: ${error.message}");
  }

  static dynamic addExtraParametersFromData(dynamic data) {
    if (data is FormData) {
      final extraFields = {'company_id': ApiConfig.companyId, 'api_key': ApiConfig.apiKey};
      data.fields.addAll(extraFields.entries.map((e) => MapEntry(e.key, e.value.toString())));
      return data;
    } else {
      return data;
    }
  }

  static dynamic addExtraParametersFromDataForMedia(dynamic data) {
    if (data is FormData) {
      final extraFields = {'company_id': ApiConfig.companyId, 'api_key': ApiConfig.mediaApiEncKey};
      data.fields.addAll(extraFields.entries.map((e) => MapEntry(e.key, e.value.toString())));
      return data;
    } else {
      return data;
    }
  }

  static Future<dynamic> addExtraParameters(Map<String, dynamic> data) async {
    Map<String, dynamic> finalData = data;
    if (ApiConfig.isAddCompanyInfo) {
      finalData.addAll({"company_id": ApiConfig.companyId, "api_key": ApiConfig.apiKey});
    }

    if (ApiConfig.encryptRequests) {
      return await encryptData(finalData);
    }
    return finalData;
  }

  static bool handleValidationError(dynamic json) {
    if (json is Map && json.containsKey('message')) {
      final message = json['message'].toString();
      if (message.isNotEmpty) {
        EasyLoading.showError(message);
        return false; // error handled
      }
    }
    return true;
  }

  static String getOSType() {
    if (kIsWeb) {
      return 'Web';
    } else if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else {
      return 'Unknown';
    }
  }
}
