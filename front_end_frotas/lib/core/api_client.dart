import 'dart:convert';

import 'package:front_end_frotas/core/token_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = 'http://localhost:3001';
  final http.Client _client;
  final TokenStorage _tokenStorage;

  ApiClient(this._client, this._tokenStorage);

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStorage.read();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) => Uri.parse(
    '$baseUrl$path',
  ).replace(queryParameters: query?.map((k, v) => MapEntry(k, '$v')));

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final res = await _client.post(
      _uri(path),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('POST $path falhou: ${res.statusCode} - ${res.body}');
  }
}
