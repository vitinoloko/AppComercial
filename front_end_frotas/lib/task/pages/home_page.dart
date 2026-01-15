import 'package:flutter/material.dart';
import 'package:front_end_frotas/const/const.dart';
import 'package:front_end_frotas/task/controllers/auth_controller.dart';
import 'package:front_end_frotas/task/controllers/task_controller.dart';
import 'package:front_end_frotas/widget/expansion_title.dart';
import 'package:front_end_frotas/widget/list_card.dart';
import 'package:front_end_frotas/widget/widgets_utils.dart';
import 'package:get/get.dart';

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
  final AuthController auth = Get.find<AuthController>();
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

    final situacaoValue = ''.obs;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: MediaQuery.of(context).size.width < 750
            ? BorderRadius.horizontal(right: Radius.circular(0))
            : BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 29, 35, 37),
              borderRadius: MediaQuery.of(context).size.width < 750
                  ? BorderRadius.horizontal(right: Radius.circular(0))
                  : BorderRadius.only(topRight: Radius.circular(16)),
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
                Row(
                  children: [
                    tooltipForm(
                      'Filtrar',
                      IconButton(
                        icon: Icon(
                          Icons.filter_list_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: Color(0xFF121212),
                            isScrollControlled: true,
                            context: context,
                            builder: (_) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  children: [
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
                                      controller: respFilters,
                                      hint: 'Responavel...',
                                      icon: Icons.person_outline,
                                    ),

                                    Row(
                                      children: [
                                        SizedBox(height: 50),
                                        Expanded(
                                          child: FilledButton(
                                            style: FilledButton.styleFrom(
                                              backgroundColor: Colors.blueGrey
                                                  .withValues(alpha: 0.3),
                                            ),
                                            onPressed: () async {
                                              await controller.filtrarTasks(
                                                name: nameFilters.text.isEmpty
                                                    ? null
                                                    : nameFilters.text,
                                                descricao:
                                                    descFilters.text.isEmpty
                                                    ? null
                                                    : descFilters.text,
                                                situacao:
                                                    filterValue.value.isEmpty
                                                    ? null
                                                    : filterValue.value,
                                                responsavel:
                                                    respFilters.text.isEmpty
                                                    ? null
                                                    : respFilters.text,
                                              );
                                              nameFilters.clear();
                                              descFilters.clear();
                                              situaFilters.clear();
                                              filterValue.value = '';
                                              Navigator.pop(
                                                // ignore: use_build_context_synchronously
                                                context,
                                              ); // fecha o bottomsheet
                                            },
                                            child: const Text('Filtrar'),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors.white
                                                  .withValues(alpha: 0.3),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text(
                                              'Cancelar',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  situacaoValue.value = 'Concluida';
                  await controller.filtrarTasks(situacao: situacaoValue.value);
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.green),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                  child: textForm('Concluida'),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  situacaoValue.value = 'Pendente';
                  await controller.filtrarTasks(situacao: situacaoValue.value);
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.red),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red.withValues(alpha: 0.3),
                  ),
                  child: textForm('Pendente'),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  situacaoValue.value = 'Em Andamento';
                  await controller.filtrarTasks(situacao: situacaoValue.value);
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.amber),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.amber.withValues(alpha: 0.3),
                  ),
                  child: textForm('Em Andamento'),
                ),
              ),
            ],
          ),
          Obx(() {
            return Container(
              decoration: BoxDecoration(color: Color.fromARGB(255, 29, 35, 37)),

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
                        "Nova Tarefa",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                initiallyExpanded: _expansionTitleController.isExpanded.value,
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

                  textFieldPers(
                    controller: nameController,
                    hint: 'Nome da Tarefa...',
                    icon: Icons.drive_file_rename_outline,
                  ),
                  textFieldPers(
                    controller: descController,
                    hint: 'Descrição da Tarefa...',
                    icon: Icons.description_outlined,
                  ),

                  textFieldPers(
                    controller: respController,
                    hint: 'Responavel...',
                    icon: Icons.person_outline,
                  ),
                  dropFunc(),
                  textFieldPers(
                    controller: obseController,
                    hint: 'Observação...',
                    icon: Icons.chat,
                  ),
                ],
              ),
            );
          }),
          // lista de tarefas ====================================================
          // Substitua a parte do Obx que contém o RefreshIndicator:
          ListCard(),
        ],
      ),
    );
  }
}
// ListTile(
//                             title: Text(task.name),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Wrap(
//                                   children: [
//                                     Text('ID: ${task.id}'),
//                                     Text('Descrição: ${task.descricao}'),
//                                     Text('responsavel: ${task.responsavel}'),
//                                     Text('situacao: ${task.situacao}'),
//                                     if (task.observacao != null &&
//                                         task.observacao
//                                             .toString()
//                                             .trim()
//                                             .isNotEmpty)
//                                       Text('observacao: ${task.observacao}'),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             trailing: IconButton(
//                               icon: const Icon(
//                                 Icons.delete_forever,
//                                 color: Colors.redAccent,
//                               ),
//                               onPressed: () {},
//                             ),
//                           ),