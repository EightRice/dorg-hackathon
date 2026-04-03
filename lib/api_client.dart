import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'models.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({this.baseUrl = hackathonApiBase, http.Client? client})
      : _client = client ?? http.Client();

  Future<List<Agent>> fetchScores() async {
    final response = await _client.get(Uri.parse('$baseUrl/scores'));
    if (response.statusCode != 200) {
      throw ApiException('Failed to load scores (${response.statusCode})');
    }
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Agent.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<Lead>> fetchLeads() async {
    final response = await _client.get(Uri.parse('$baseUrl/leads'));
    if (response.statusCode != 200) {
      throw ApiException('Failed to load leads (${response.statusCode})');
    }
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Lead.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<Activity>> fetchActivities({int limit = 100}) async {
    final response =
        await _client.get(Uri.parse('$baseUrl/activities?limit=$limit'));
    if (response.statusCode != 200) {
      throw ApiException('Failed to load activities (${response.statusCode})');
    }
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Activity.fromJson(json as Map<String, dynamic>)).toList();
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
