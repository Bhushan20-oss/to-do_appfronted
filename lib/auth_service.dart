import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = "http://your-django-api-url";
  final storage = const FlutterSecureStorage();

  Future<void> signIn(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'access', value: data['access']);
      await storage.write(key: 'refresh', value: data['refresh']);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception('Failed to sign in: ${errorData['detail']}');
    }
  }

  Future<void> refreshToken() async {
    final refreshToken = await storage.read(key: 'refresh');
    if (refreshToken == null) {
      throw Exception('No refresh token found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'access', value: data['access']);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception('Failed to refresh token: ${errorData['detail']}');
    }
  }

  Future<void> signOut() async {
    await storage.delete(key: 'access');
    await storage.delete(key: 'refresh');
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'access');
  }
}
