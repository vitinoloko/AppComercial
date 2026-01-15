import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class Sla extends StatelessWidget {
  const Sla({super.key});

  @override
  Widget build(BuildContext context) {
    print('homepage construindo!');
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // --- Barra superior sofisticada ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF1E88E5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    context.beamToNamed('/cadastro');
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text(
                    'Cadastro',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (_) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: Wrap(
                            children: const [
                              ListTile(
                                leading: Icon(Icons.list),
                                title: Text("Todos"),
                              ),
                              ListTile(
                                leading: Icon(Icons.person),
                                title: Text("Nome"),
                              ),
                              ListTile(
                                leading: Icon(Icons.description),
                                title: Text("Descrição"),
                              ),
                              ListTile(
                                leading: Icon(Icons.check_circle),
                                title: Text("Situação"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // --- Campo de busca ---
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Pesquisar tarefa...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Icon(Icons.clear),
              ),
            ),
          ),

          // --- Lista sofisticada ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 5,
              itemBuilder: (_, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
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
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      "Tarefa ${index + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        "Descrição detalhada da tarefa\nResponsável: Fulano | Situação: Pendente",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.redAccent,
                        size: 28,
                      ),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ),

          // --- Botão sofisticado ---
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text("Nova Tarefa"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            const TextField(
                              decoration: InputDecoration(
                                labelText: "Nome",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: "Descrição",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: "Responsável",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField(
                              items: const [
                                DropdownMenuItem(
                                  value: "Pendente",
                                  child: Text("Pendente"),
                                ),
                                DropdownMenuItem(
                                  value: "Concluída",
                                  child: Text("Concluída"),
                                ),
                              ],
                              onChanged: null,
                              decoration: const InputDecoration(
                                labelText: "Situação",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Salvar"),
                        ),
                      ],
                    ),
                  );
                },
                label: const Text("Adicionar"),
                icon: const Icon(Icons.add),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
