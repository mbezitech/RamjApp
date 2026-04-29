import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  set token(String? value) {
    _token = value;
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}$endpoint'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('${AppConstants.apiBaseUrl}$endpoint').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('${AppConstants.apiBaseUrl}$endpoint'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('${AppConstants.apiBaseUrl}$endpoint'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> uploadDocument(String endpoint, Map<String, String> fields, String filePath) async {
    final uri = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $_token',
      'Accept': 'application/json',
    });

    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    request.files.add(await http.MultipartFile.fromPath('document', filePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    throw ApiException(
      message: body['message'] ?? 'An error occurred',
      statusCode: response.statusCode,
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
