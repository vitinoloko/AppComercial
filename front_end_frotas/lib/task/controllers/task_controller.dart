import 'package:flutter/material.dart';
import 'package:front_end_frotas/task/service/task_service.dart';
import 'package:get/get.dart';
import 'package:front_end_frotas/task/models/task.dart';

class TaskController extends GetxController {
  final TaskService service;

  TaskController(this.service);

  // Estado reativo
  var tasks = <Task>[].obs;
  var isLoading = false.obs;
  var error = RxnString(); // OBS: nullable, pra poder limpar
  var selectedTask = Rxn<Task>();
  final nameController = TextEditingController();
  final descricaoController = TextEditingController();
  final situacaoController = TextEditingController();
  final responsavelController = TextEditingController();
  final observacaoController = TextEditingController(); // <--- ESSE FALTAVA

  @override
  void onInit() {
    super.onInit();
    listarTasks();
  }

  Future<void> filtrarTasks({
    String? name,
    String? descricao,
    String? situacao,
    String? responsavel,
  }) async {
    try {
      isLoading.value = true;
      error.value = null; // limpa erro

      final filtered = await service.filter(
        name: name,
        descricao: descricao,
        situacao: situacao,
        responsavel: responsavel,
      );

      tasks.assignAll(filtered); // ✅ atualiza lista observada pelo Obx
    } catch (e) {
      error.value = 'Erro ao filtrar: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Carregar todas as tasks
  Future<void> listarTasks() async {
    try {
      isLoading.value = true;
      error.value = null; // limpa o erro
      final list = await service.listar();
      tasks.value = list;
    } catch (e) {
      error.value = 'Erro ao carregar: $e';
      // NÃO tocar em tasks, mantém a lista antiga
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> criarTask({
    required String name,
    required String descricao,
    required String situacao,
    required String responsavel,
    String? observacao,
  }) async {
    try {
      isLoading.value = true;
      final newTask = await service.criar(
        name: name,
        descricao: descricao,
        situacao: situacao,
        responsavel: responsavel,
        observacao: observacao,
      );
      tasks.add(newTask); // só adiciona a nova task
      error.value = null; // limpa erro
    } catch (e) {
      error.value = 'Erro ao criar: $e';
      // NÃO tocar em tasks
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletarTask(int id) async {
    try {
      isLoading.value = true;
      await service.deletar(id);
      tasks.removeWhere((t) => t.id == id); // atualiza a lista local
      error.value = null;
    } catch (e) {
      error.value = 'Erro ao deletar: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
