class Task {
  final int id;
  final String name;
  final String descricao;
  final String situacao;
  final String responsavel;
  final bool isActive;
  final String? observacao;

  Task({
    required this.id,
    required this.name,
    required this.descricao,
    required this.situacao,
    required this.responsavel,
    required this.isActive,
    this.observacao,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as int,
    name: json['name'] as String,
    descricao: json['descricao'] as String,
    situacao: json['situacao'] as String,
    responsavel: json['responsavel'] as String,
    isActive: json['isActive'] as bool,
    observacao: json['observacao'] as String?,
  );
}
