import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'token_storage_service.dart';

class ApiClient {
  ApiClient(
    this._tokenStorageService, {
    http.Client? httpClient,
    String? baseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        _baseUrl = baseUrl ?? _defaultBaseUrl;

  final TokenStorageService _tokenStorageService;
  final http.Client _httpClient;
  final String _baseUrl;

  static String get _defaultBaseUrl {
    const configuredBaseUrl = String.fromEnvironment('API_BASE_URL');

    if (configuredBaseUrl.isNotEmpty) {
      return configuredBaseUrl;
    }

    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return 'http://localhost:5000/api';
    }

    return 'http://10.0.2.2:5000/api';
  }

  Future<Map<String, dynamic>> get(String path) {
    return _send('GET', path);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) {
    return _send('POST', path, body: body);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) {
    return _send('PUT', path, body: body);
  }

  Future<void> delete(String path) async {
    await _send('DELETE', path, expectsBody: false);
  }

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool expectsBody = true,
  }) async {
    final token = await _tokenStorageService.readToken();
    final uri = Uri.parse('$_baseUrl$path');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final requestBody = body == null ? null : jsonEncode(body);
    late final http.Response response;

    switch (method) {
      case 'GET':
        response = await _httpClient.get(uri, headers: headers);
      case 'POST':
        response = await _httpClient.post(
          uri,
          headers: headers,
          body: requestBody,
        );
      case 'PUT':
        response = await _httpClient.put(
          uri,
          headers: headers,
          body: requestBody,
        );
      case 'DELETE':
        response = await _httpClient.delete(uri, headers: headers);
      default:
        throw const ApiException('Unsupported request method.');
    }

    if (response.statusCode == 204) {
      return <String, dynamic>{};
    }

    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        decoded['message']?.toString() ?? 'Request failed.',
        statusCode: response.statusCode,
      );
    }

    if (expectsBody && decoded.isEmpty) {
      throw ApiException(
        'Empty response from server.',
        statusCode: response.statusCode,
      );
    }

    return decoded;
  }
}
