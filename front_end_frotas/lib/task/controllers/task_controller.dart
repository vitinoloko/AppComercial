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

  @override
  void onInit() {
    super.onInit();
    listarTasks();
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
}
