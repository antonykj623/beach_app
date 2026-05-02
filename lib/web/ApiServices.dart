import 'dart:convert';
import 'package:http/http.dart' as http;

/// Common API Service Class
class ApiService {
  static const String baseUrl = "https://beach.adpedia.in/api";

  /// Common Headers
  static Map<String, String> get headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  /// GET Method
  static Future<dynamic> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("GET Error: $e");
    }
  }

  /// POST Method
  static Future<dynamic> postRequest(
      String endpoint, dynamic body) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception("POST Error: $e");
    }
  }

  /// PUT Method
  static Future<dynamic> putRequest(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception("PUT Error: $e");
    }
  }

  /// DELETE Method
  static Future<dynamic> deleteRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.delete(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("DELETE Error: $e");
    }
  }

  /// Common Response Handler
  static dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);

      case 400:
        return jsonDecode(response.body);


      case 401:
        return jsonDecode(response.body);

      case 404:
        throw Exception("Not Found");

      case 500:
        throw Exception("Server Error");

      default:
        throw Exception(
          "Error: ${response.statusCode} | ${response.body}",
        );
    }
  }


  /// 🔹 1. Forgot Password (Generate OTP)
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/forgot-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    return jsonDecode(response.body);
  }

  /// 🔹 2. Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(String email, int otp) async {
    final response = await http.post(
      Uri.parse("$baseUrl/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "otp": otp,
      }),
    );

    return jsonDecode(response.body);
  }

  /// 🔹 3. Reset Password
  static Future<Map<String, dynamic>> resetPassword(
      String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/reset-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "new_password": password,
      }),
    );

    return jsonDecode(response.body);
  }
}