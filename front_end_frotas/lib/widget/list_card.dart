import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:front_end_frotas/const/const.dart';
import 'package:front_end_frotas/task/controllers/auth_controller.dart';
import 'package:front_end_frotas/task/controllers/task_controller.dart';
import 'package:front_end_frotas/widget/widgets_utils.dart';
import 'package:get/get.dart';

class ListCard extends StatelessWidget {
  ListCard({super.key});
  final TaskController controller = Get.find<TaskController>();
  final AuthController auth = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Expanded(child: Center(child: CustomSpinner()));
      }

      if (controller.tasks.isEmpty) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Nenhuma tarefa encontrada',
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  controller.listarTasks();
                },
                icon: Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
        );
      }

      return Expanded(
        child: EasyRefresh(
          header: MaterialHeader(
            color: Color(0xFF4ACFD9),
            backgroundColor: Color.fromARGB(255, 29, 35, 37),
          ),
          onRefresh: () async => await controller.listarTasks(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossCount = constraints.maxWidth > 800 ? 2 : 1;
              double itemWidth =
                  (constraints.maxWidth - (crossCount - 1) * 12) / crossCount;

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: itemWidth / 180,
                ),
                itemCount: controller.tasks.length,
                itemBuilder: (_, index) {
                  final task = controller.tasks[index];

                  return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          width: 1.2,
                          color: getStatusColor(task.situacao),
                        ),
                      ),
                      color: Color.fromARGB(255, 45, 53, 56),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              iconsForm(Icons.drive_file_rename_outline),
                              Expanded(child: textForm(task.name)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            iconsForm(Icons.description_outlined),
                            Expanded(child: textForm(task.descricao)),
                          ],
                        ),
                        Row(
                          children: [
                            iconsForm(Icons.person_outline),
                            Expanded(child: textForm(task.responsavel)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.edit, color: Colors.blue),
                            ),
                            // if (auth.user.value?.role != 'user')
                            IconButton(
                              onPressed: () async {
                                await controller.deletarTask(task.id);
                                await controller.listarTasks();
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: getStatusColor(task.situacao),
                                ),
                                borderRadius: BorderRadius.circular(5),
                                color: getStatusColor(
                                  task.situacao,
                                ).withValues(alpha: 0.3),
                              ),
                              child: textForm(task.situacao),
                            ),
                          ],
                        ),
                        if (task.observacao != null &&
                            task.observacao!.trim().isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.chat, color: Colors.amber),
                              Expanded(child: textForm(task.observacao!)),
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
      );
    });
  }
}
