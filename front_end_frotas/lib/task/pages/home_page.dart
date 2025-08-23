import 'package:flutter/material.dart';
import 'package:front_end_frotas/task/controllers/task_controller.dart';
import 'package:front_end_frotas/task/models/task.dart';
import 'package:front_end_frotas/task/service/task_service.dart';
import 'package:front_end_frotas/widget/expansion_title.dart';
import 'package:front_end_frotas/widget/widgets_utils.dart';
import 'package:get/get.dart';
import 'package:simple_grid/simple_grid.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ExpansionTitleController _expansionTitleController =
      Get.find<ExpansionTitleController>();

  void safeSetExpanded(bool value) {
    if (Get.isRegistered<ExpansionTitleController>()) {
      _expansionTitleController.setExpanded(value);
    }
  }

  final TaskController controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final respController = TextEditingController();
    final obseController = TextEditingController();

    final nameFilters = TextEditingController();
    final descFilters = TextEditingController();
    final situaFilters = TextEditingController();
    final respFilters = TextEditingController();
    final task = Get.find<TaskService>();
    var items = <Task>[].obs;

    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   image: AssetImage('fundo.jpg'),
        //   fit: BoxFit.cover, // cobre todo o container
        //   colorFilter: ColorFilter.mode(
        //     const Color.fromARGB(164, 255, 255, 255),
        //     BlendMode.darken, // mistura a cor com a imagem
        //   ),
        // ),
        color: Color(0xFF121212),
        borderRadius: MediaQuery.of(context).size.width < 650
            ? BorderRadius.horizontal(right: Radius.circular(0))
            : BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: Column(
        children: [
          SpGrid(
            children: [
              defaultGrid(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 29, 35, 37),
                    borderRadius: AppStyles.responseBordeRadius(context),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        label: Text(
                          'Botao de NPC',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      tooltipForm(
                        'Filtrar',
                        IconButton(
                          icon: Icon(
                            Icons.filter_list_alt,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Color(0xFF121212),
                              isScrollControlled: true,
                              context: context,
                              builder: (_) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height *
                                      0.3, // 80% da tela
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Wrap(
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                tooltipForm(
                                                  'Sair',
                                                  IconButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    icon: Icon(
                                                      Icons.arrow_back,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Voltar',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            tooltipForm(
                                              'Procurar',
                                              IconButton(
                                                onPressed: () async {
                                                  await controller.filtrarTasks(
                                                    name:
                                                        nameFilters.text.isEmpty
                                                        ? null
                                                        : nameFilters.text,
                                                    descricao:
                                                        descFilters.text.isEmpty
                                                        ? null
                                                        : descFilters.text,
                                                    situacao:
                                                        situaFilters
                                                            .text
                                                            .isEmpty
                                                        ? null
                                                        : situaFilters.text,
                                                    responsavel:
                                                        respFilters.text.isEmpty
                                                        ? null
                                                        : respFilters.text,
                                                  );
                                                  Navigator.pop(
                                                    context,
                                                  ); // fecha o bottomsheet
                                                },
                                                icon: Icon(
                                                  Icons.filter_alt,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Filtrar Tarefas',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        textFieldPers(
                                          controller: nameFilters,
                                          hint: 'Nome da Tarefa...',
                                          icon: Icons.drive_file_rename_outline,
                                        ),
                                        textFieldPers(
                                          controller: descFilters,
                                          hint: 'Descrição da Tarefa...',
                                          icon: Icons.description_outlined,
                                        ),

                                        textFieldPers(
                                          controller: situaFilters,
                                          hint: 'Responavel...',
                                          icon: Icons.person_outline,
                                        ),

                                        dropFunc(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              defaultGrid(
                child: Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 29, 35, 37),
                      borderRadius: MediaQuery.of(context).size.width < 960
                          ? BorderRadius.horizontal(right: Radius.circular(0))
                          : BorderRadius.only(topRight: Radius.circular(16)),
                    ),

                    child: ExpansionTile(
                      collapsedTextColor: Colors.white,
                      textColor: Colors.white,
                      // iconColor: Colors.amber,
                      iconColor: Color(0xFF4ACFD9),
                      collapsedIconColor: Colors.white,
                      title: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.assignment),
                            SizedBox(width: 7),
                            Text(
                              "Cadastrar",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      initiallyExpanded:
                          _expansionTitleController.isExpanded.value,
                      onExpansionChanged: (expanded) {
                        _expansionTitleController.setExpanded(
                          expanded,
                        ); // Atualiza o estado de expansão
                      },
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: botaoForm('Salvar', () async {
                                if (nameController.text.isEmpty ||
                                    descController.text.isEmpty ||
                                    respController.text.isEmpty ||
                                    items.toString().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Erro, preencha todos os campos!',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                await controller.criarTask(
                                  name: nameController.text,
                                  descricao: descController.text,
                                  situacao: selectedValue.value.isEmpty
                                      ? 'Pendente'
                                      : selectedValue.value,
                                  responsavel: respController.text,
                                  observacao: obseController.text,
                                );

                                nameController.clear();
                                descController.clear();
                                respController.clear();
                                selectedValue.value = '';
                                obseController.clear();
                                _expansionTitleController.setExpanded(false);
                              }, iconM: Icons.check),
                            ),
                          ],
                        ),
                        SpGrid(
                          children: [
                            defaultGrid(
                              child: textFieldPers(
                                controller: nameController,
                                hint: 'Nome da Tarefa...',
                                icon: Icons.drive_file_rename_outline,
                              ),
                            ),
                            defaultGrid(
                              child: textFieldPers(
                                controller: descController,
                                hint: 'Descrição da Tarefa...',
                                icon: Icons.description_outlined,
                              ),
                            ),
                          ],
                        ),
                        SpGrid(
                          children: [
                            defaultGrid(
                              child: textFieldPers(
                                controller: respController,
                                hint: 'Responavel...',
                                icon: Icons.person_outline,
                              ),
                            ),
                            defaultGrid(child: dropFunc()),
                            defaultGrid(
                              child: textFieldPers(
                                controller: obseController,
                                hint: 'Observação...',
                                icon: Icons.chat,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),

          // lista de tarefas ====================================================
          Obx(() {
            if (controller.isLoading.value) return CircularProgressIndicator();

            return Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Definimos número de colunas dependendo da largura
                  int crossCount = constraints.maxWidth > 800 ? 2 : 1;

                  // Largura de cada item
                  double itemWidth =
                      (constraints.maxWidth - (crossCount - 1) * 12) /
                      crossCount;

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: itemWidth / 120, // altura mínima 120
                    ),
                    itemCount: controller.tasks.length,
                    itemBuilder: (_, index) {
                      final task = controller.tasks[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(task.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Descrição: ${task.descricao}'),
                              Text('responsavel: ${task.responsavel}'),
                              Text('situacao: ${task.situacao}'),
                              if (task.observacao != null &&
                                  task.observacao.toString().trim().isNotEmpty)
                                Text('observacao: ${task.observacao}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
