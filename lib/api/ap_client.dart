import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ApiClient {
  final String baseUrl;
  final logger = Logger();

  ApiClient(this.baseUrl);

  Future<dynamic> get(String endpoint, {
    Map<String, String>? params,
    Map<String, String>? headers,
  }) async {
    Uri uri = Uri.parse(baseUrl + endpoint).replace(queryParameters: params);
    logger.i("📤 Sending GET request to: $uri");

    try {
      final response = await http.get(uri, headers: headers);
      return _processResponse(response);
    } catch (e) {
      logger.e("❌ Exception during GET request: $e");
      throw Exception("Network error: $e");
    }
  }


  Future<dynamic> delete(String endpoint, {
    Map<String, String>? params,
    Map<String, String>? body,
    Map<String, String>? headers,
  }) async {
    Uri uri = Uri.parse(baseUrl + endpoint).replace(queryParameters: params);
    logger.i("🗑️ Sending DELETE request to: $uri");

    final request = http.Request('DELETE', uri);

    // Make sure headers are not null
    request.headers.addAll({
      'Content-Type': 'application/json',
      if (headers != null) ...headers,
    });

    if (body != null) {
      logger.i("🧾 Body: ${jsonEncode(body)}");
      request.body = jsonEncode(body);
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      logger.i("📨 Response Status: ${response.statusCode}");
      logger.i("📨 Response Body: ${response.body}");

      return _processResponse(response);
    } catch (e) {
      logger.e("❌ Network Error: $e");
      throw Exception("Network error: $e");
    }
  }


  Future<dynamic> put(String endpoint, {
    Map<String, String>? params,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    Uri uri = Uri.parse(baseUrl + endpoint).replace(queryParameters: params);
    logger.i("✏️ Sending PUT request to: $uri");

    final request = http.Request('PUT', uri);

    // Add headers
    request.headers.addAll({
      'Content-Type': 'application/json',
      if (headers != null) ...headers,
    });

    // Add body if present
    if (body != null) {
      logger.i("🧾 Body: ${jsonEncode(body)}");
      request.body = jsonEncode(body);
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      logger.i("📨 Response Status: ${response.statusCode}");
      logger.i("📨 Response Body: ${response.body}");

      return _processResponse(response);
    } catch (e) {
      logger.e("❌ Network Error: $e");
      throw Exception("Network error: $e");
    }
  }



  Future<dynamic> post(
      String endpoint, {
        dynamic? body,
        Map<String, String>? headers,
      }) async {
    Uri uri = Uri.parse(baseUrl + endpoint);
    logger.i("📤 Sending POST request to: $uri");

    if (body != null) {
      logger.d("📦 Request Body: ${jsonEncode(body)}");
    }

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          ...?headers,
        },
        body: body != null ? jsonEncode(body) : null,
      );

      return _processResponse(response);
    } catch (e) {
      logger.e("❌ Exception during POST request: $e");
      throw Exception("Network error: $e");
    }
  }



  dynamic _processResponse(http.Response response) {
    logger.i("🔄 Processing Response...");

    try {
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("✅ SUCCESS: ${response.statusCode}");
        return responseJson;
      } else {
        logger.w("⚠️ API ERROR: ${response.statusCode}");
        return {
          "success": false,
          "message": responseJson["message"] ?? "Unknown API error"
        };
      }
    } catch (e) {
      logger.e("🚨 Error processing response: ${e.toString()}");
      return {"success": false, "message": "Invalid response format", "status": response.statusCode};
    }
  }


}
