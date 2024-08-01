import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl =
      "http://192.168.106.234:8000"; // Update with your IP address
  final storage = FlutterSecureStorage();

  // Future<void> sendOtp(String name, String email, String password) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //           '$baseUrl/api/account/register/'), // Update with your OTP request endpoint
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'name': name, 'email': email, 'password': password}),
  //     );

  //     if (response.statusCode == 200) {
  //       print('OTP sent successfully');
  //     } else {
  //       final errorData = jsonDecode(response.body);
  //       print('Failed to send OTP: ${errorData['detail']}');
  //       throw Exception('Failed to send OTP: ${errorData['detail']}');
  //     }
  //   } catch (e) {
  //     print('Error occurred while sending OTP: $e');
  //     throw Exception('Error occurred while sending OTP: $e');
  //   }
  // }//not working

  // Future<void> sendOtp(String name, String email, String password) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/api/account/register/'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'name': name, 'email': email, 'password': password}),
  //     );

  //     if (response.statusCode == 200) {
  //       if (response.headers['content-type']?.contains('application/json') ??
  //           false) {
  //         final data = jsonDecode(response.body);
  //         // Handle JSON response
  //       } else {
  //         // Handle non-JSON response
  //         print('Non-JSON response: ${response.body}');
  //       }
  //     } else {
  //       final errorData = jsonDecode(response.body);
  //       print('Failed to send OTP: ${errorData['detail']}');
  //       throw Exception('Failed to send OTP: ${errorData['detail']}');
  //     }
  //   } catch (e) {
  //     print('Error occurred while sending OTP: $e');
  //     throw Exception('Error occurred while sending OTP: $e');
  //   }
  // }
  Future<void> sendOtp(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/account/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey('message')) {
          print('OTP sent successfully: ${data['message']}');
        } else {
          print('OTP sent successfully');
        }
      } else {
        final errorData = jsonDecode(response.body);
        print('Failed to send OTP: ${errorData['detail']}');
        throw Exception('Failed to send OTP: ${errorData['detail']}');
      }
    } catch (e) {
      print('Error occurred while sending OTP: $e');
      throw Exception('Error occurred while sending OTP: $e');
    }
  }

  // Future<void> verifyOtp(String email, String otp) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //           '$baseUrl/api/account/register/verifyotp/'), // Update with your OTP verification endpoint
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'email': email, 'otp': otp}),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       await storage.write(key: 'access', value: data['access']);
  //       await storage.write(key: 'refresh', value: data['refresh']);
  //       print('OTP verified successfully');
  //     } else {
  //       final errorData = jsonDecode(response.body);
  //       print('Failed to verify OTP: ${errorData['detail']}');
  //       throw Exception('Failed to verify OTP: ${errorData['detail']}');
  //     }
  //   } catch (e) {
  //     print('Error occurred while verifying OTP: $e');
  //     throw Exception('Error occurred while verifying OTP: $e');
  //   }
  // }
  Future<void> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/account/register/verifyotp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'access', value: data['access']);
        await storage.write(key: 'refresh', value: data['refresh']);
        print('OTP verified successfully');
      } else {
        final errorData = jsonDecode(response.body);
        print('Failed to verify OTP: ${errorData['detail']}');
        throw Exception('Failed to verify OTP: ${errorData['detail']}');
      }
    } catch (e) {
      print('Error occurred while verifying OTP: $e');
      throw Exception('Error occurred while verifying OTP: $e');
    }
  }

  Future<void> sendOtp1(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/account/forgot-password/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey('message')) {
          print('OTP sent successfully: ${data['message']}');
        } else {
          print('OTP sent successfully');
        }
      } else {
        final errorData = jsonDecode(response.body);
        print('Failed to send OTP: ${errorData['detail']}');
        throw Exception('Failed to send OTP: ${errorData['detail']}');
      }
    } catch (e) {
      print('Error occurred while sending OTP: $e');
      throw Exception('Error occurred while sending OTP: $e');
    }
  }

  Future<void> resetPassword(
      String email, String newPassword, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/api/account/reset-password/'), // Update with your password reset endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'email': email, 'new_password': newPassword, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        print('Password reset successful');
      } else {
        final errorData = jsonDecode(response.body);
        print('Failed to reset password: ${errorData['detail']}');
        throw Exception('Failed to reset password: ${errorData['detail']}');
      }
    } catch (e) {
      print('Error occurred while resetting password: $e');
      throw Exception('Error occurred while resetting password: $e');
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/account/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'access', value: data['access']);
        await storage.write(key: 'refresh', value: data['refresh']);
        print('Sign up successful');
      } else {
        final errorData = jsonDecode(response.body);
        print('Failed to sign up: ${errorData['detail']}');
        //throw Exception('Failed to sign up: ${errorData['detail']}');
      }
    } catch (e) {
      print('Error occurred while signing up: $e');
      throw Exception('Error occurred while signing up: $e');
    }
  }

  Future<void> signIn(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/account/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'access', value: data['access']);
        await storage.write(key: 'refresh', value: data['refresh']);
        print('Sign in successful');
      } else {
        final errorData = jsonDecode(response.body);
        print('Failed to sign in: ${errorData['detail']}');
        throw Exception('Failed to sign in: ${errorData['detail']}');
      }
    } catch (e) {
      print('Error occurred while signing in: $e');
      throw Exception('Error occurred while signing in: $e');
    }
  }

  Future<void> refreshToken() async {
    try {
      final refreshToken = await storage.read(key: 'refresh');

      final response = await http.post(
        Uri.parse('$baseUrl/api/account/login/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'access', value: data['access']);
        print('Token refreshed successfully');
      } else {
        final errorData = jsonDecode(response.body);
        print('Failed to refresh token: ${errorData['detail']}');
        throw Exception('Failed to refresh token: ${errorData['detail']}');
      }
    } catch (e) {
      print('Error occurred while refreshing token: $e');
      throw Exception('Error occurred while refreshing token: $e');
    }
  }

  Future<void> signOut() async {
    await storage.delete(key: 'access');
    await storage.delete(key: 'refresh');
    print('Sign out successful');
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'access');
  }

  Future<bool> validateToken() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return false;

    final response = await http.get(
      Uri.parse('$baseUrl/api/todos/'), // Replace with a valid endpoint
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      try {
        await refreshToken();
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }
}
