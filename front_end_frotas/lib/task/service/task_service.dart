import 'package:front_end_frotas/core/api_client.dart';
import 'package:front_end_frotas/task/models/task.dart';

class TaskService {
  final ApiClient api;
  TaskService(this.api);

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

    final list = await api.getList('/task/filtro', query: query);
    return list.map((e) => Task.fromJson(e)).toList();
  }

  Future<Task> criar({
    required String name,
    required String descricao,
    required String situacao,
    required String responsavel,
    String? observacao,
  }) async {
    final map = await api.post('/task', {
      'name': name,
      'descricao': descricao,
      'situacao': situacao,
      'responsavel': responsavel,
      'observacao': observacao,
    });
    return Task.fromJson(map);
  }

  Future<List<Task>> listar({
    String? name,
    String? descricao,
    String? situacao,
    String? responsavel,
    String? observacao,
  }) async {
    final list = await api.getList(
      '/task/filtro',
      query: {
        if (name != null && name.isNotEmpty) 'name': name,
        if (descricao != null && descricao.isNotEmpty) 'descricao': descricao,
        if (situacao != null && situacao.isNotEmpty) 'situacao': situacao,
        if (responsavel != null && responsavel.isNotEmpty)
          'responsavel': responsavel,
        if (observacao != null && observacao.isNotEmpty)
          'observacao': observacao,
      },
    );
    return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }
}
