import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/request.dart';
import '../models/task.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  static const String tokenKey = 'auth_token';

  // Get auth token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Set auth token
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Remove auth token
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Auth headers
  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // 🔹 Authentication API
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'name': name,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      await setToken(data['data']['token']);
      return data;
    }
    throw Exception('Registration failed');
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await setToken(data['data']['token']);
      return data;
    }
    throw Exception('Login failed');
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }
    throw Exception('Failed to fetch profile');
  }

  static Future<void> logout() async {
    final headers = await _getHeaders();
    await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: headers,
    );
    await removeToken();
  }

  // 🔹 User API
  static Future<Map<String, dynamic>> getUserData() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/user/data'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }
    throw Exception('Failed to fetch user data');
  }

  static Future<void> updateUserProfile(Map<String, dynamic> profile) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/user/update'),
      headers: headers,
      body: json.encode(profile),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  static Future<Request> submitAccessRequest(Request request) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/user/request'),
      headers: headers,
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return Request.fromJson(data['data']);
    }
    throw Exception('Failed to submit request');
  }

  static Future<List<Request>> getUserHistory() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/user/history'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((json) => Request.fromJson(json))
          .toList();
    }
    throw Exception('Failed to fetch user history');
  }

  // 🔹 Worker API
  static Future<List<Task>> getWorkerTasks() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/worker/tasks'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List).map((json) => Task.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch worker tasks');
  }

  static Future<void> verifyRequest(
      String requestId, bool approved, String? notes) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/worker/verify/$requestId'),
      headers: headers,
      body: json.encode({
        'approved': approved,
        'notes': notes,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to verify request');
    }
  }

  static Future<List<Map<String, dynamic>>> getWorkerLogs() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/worker/logs'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    }
    throw Exception('Failed to fetch worker logs');
  }

  // 🔹 Admin API
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    }
    throw Exception('Failed to fetch users');
  }

  static Future<void> deleteUser(String userId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/user/$userId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  static Future<List<Map<String, dynamic>>> getSystemLogs() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/admin/logs'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    }
    throw Exception('Failed to fetch system logs');
  }

  static Future<void> assignWorkerTask(String workerId, Task task) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/admin/assign-worker'),
      headers: headers,
      body: json.encode({
        'workerId': workerId,
        'task': task.toJson(),
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to assign task');
    }
  }
}
