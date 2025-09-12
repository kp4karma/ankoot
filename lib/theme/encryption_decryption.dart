import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

Future<Map<String, dynamic>> decrypt(dynamic data) async {
  return {};
  // if (data == null) {
  //   return {};
  // }
  //
  // final decoded = jsonDecode(data);
  //
  // if (!decoded.containsKey('response_data') || decoded['response_data'] == null) {
  //   return decoded;
  // }
  //
  // final fernet = encrypt.Fernet(encrypt.Key.fromBase64(base64Url.encode(encrypt.Key.fromBase64(ApiEndpoints.fernetKey).bytes)));
  //
  // final encrypter = encrypt.Encrypter(fernet);
  // final decrypted = encrypter.decrypt64(decoded['response_data']);
  //
  // print(decrypted);
  // return jsonDecode(decrypted);
}

Future<String> encryptData(Map<String, dynamic> payload) async {
  return "";
  // final dataEnc = encrypt.Fernet(encrypt.Key.fromBase64(base64Url.encode(encrypt.Key.fromBase64(ApiConfig.dataEnc).bytes)));
  //
  // final encrypter = encrypt.Encrypter(dataEnc);
  //
  // final encodedPayload = jsonEncode(payload);
  // final encrypted = encrypter.encrypt(encodedPayload);
  //
  // // You can return just the encrypted.base64 or wrap it in response_data key
  // return jsonEncode({'enc_payload': encrypted.base64});
}
