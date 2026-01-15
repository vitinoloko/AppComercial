import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_end_frotas/task/models/task.dart';
import 'package:front_end_frotas/core/token_storage.dart';

class TaskService {
  final String baseUrl = 'http://localhost:3001';
  final http.Client _client;
  final TokenStorage _tokenStorage;

  TaskService(this._client, this._tokenStorage);

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStorage.read();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse(
      '$baseUrl$path',
    ).replace(queryParameters: query?.map((k, v) => MapEntry(k, '$v')));
  }

  Future<List<Task>> filter({
    String? name,
    String? descricao,
    String? situacao,
    String? responsavel,
  }) async {
    final query = <String, dynamic>{};
    if (name != null) query['name'] = name;
    if (descricao != null) query['descricao'] = descricao;
    if (situacao != null) query['situacao'] = situacao;
    if (responsavel != null) query['responsavel'] = responsavel;

    final res = await _client.get(
      _uri('/task/filtro', query),
      headers: await _headers(),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => Task.fromJson(e)).toList();
    }
    throw Exception('Erro ao filtrar tasks: ${res.statusCode} - ${res.body}');
  }

  Future<Task> criar({
    required String name,
    required String descricao,
    required String situacao,
    required String responsavel,
    String? observacao,
  }) async {
    final res = await _client.post(
      _uri('/task'),
      headers: await _headers(),
      body: jsonEncode({
        'name': name,
        'descricao': descricao,
        'situacao': situacao,
        'responsavel': responsavel,
        'observacao': observacao,
      }),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return Task.fromJson(jsonDecode(res.body));
    }
    throw Exception('Erro ao criar task: ${res.statusCode} - ${res.body}');
  }

  Future<List<Task>> listar({
    String? name,
    String? descricao,
    String? situacao,
    String? responsavel,
    String? observacao,
  }) async {
    final query = {
      if (name?.isNotEmpty ?? false) 'name': name,
      if (descricao?.isNotEmpty ?? false) 'descricao': descricao,
      if (situacao?.isNotEmpty ?? false) 'situacao': situacao,
      if (responsavel?.isNotEmpty ?? false) 'responsavel': responsavel,
      if (observacao?.isNotEmpty ?? false) 'observacao': observacao,
    };

    final res = await _client.get(
      _uri('/task/filtro', query),
      headers: await _headers(),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => Task.fromJson(e)).toList();
    }
    throw Exception('Erro ao listar tasks: ${res.statusCode} - ${res.body}');
  }

  Future<void> deletar(int id) async {
    final res = await _client.delete(
      _uri('/task/delete/$id'),
      headers: await _headers(),
    );
    if (!(res.statusCode >= 200 && res.statusCode < 300)) {
      throw Exception('Erro ao deletar task: ${res.statusCode} - ${res.body}');
    }
  }
}
