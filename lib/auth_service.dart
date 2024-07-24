import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl =
      "http://192.168.217.7:8000"; // Update with your IP address
  final storage = FlutterSecureStorage();

  Future<void> signUp(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/account/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'access', value: data['access']);
      await storage.write(key: 'refresh', value: data['refresh']);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception('Failed to sign up: ${errorData['detail']}');
    }
  }


  Future<void> signIn(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/account/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'access', value: data['access']);
      await storage.write(key: 'refresh', value: data['refresh']);
    } else {
      throw Exception('Failed to sign in');
    }
  }

  Future<void> refreshToken() async {
    final refreshToken = await storage.read(key: 'refresh');

    final response = await http.post(
      Uri.parse('$baseUrl/api/account/login/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'access', value: data['access']);
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<void> signOut() async {
    await storage.delete(key: 'access');
    await storage.delete(key: 'refresh');
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
