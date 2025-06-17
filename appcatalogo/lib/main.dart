import 'package:appcatalogo/page/homepage.dart';
import 'package:appcatalogo/page/cadastro_produto/cadastro_formpage.dart';
import 'package:appcatalogo/page/cadastro_produto/cart_controller.dart';
import 'package:appcatalogo/page/cadastro_produto/cart_page.dart';
import 'package:appcatalogo/page/cadastro_produto/food_controller.dart';
import 'package:appcatalogo/page/cadastro_produto/list_page.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(FoodController());
  Get.put(CartController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Mapa para o menu, que agora é separado da lógica de rotas do Beamer, mas ainda necessário para HomePage
  final Map<String, Widget Function(double)> menuPaginasMap = {
    '/Interface': (largura) => ListPage(largura: largura),
    '/Interface/Cadastro': (largura) => CadastroFormpage(largura: largura),
    // Adicione outras páginas para o menu aqui, se houver
  };

  // Método auxiliar para criar uma BeamPage de forma automática e robusta
  BeamPage _createBeamPage({
    required String path,
    required String title,
    required Widget Function(double) pageBuilder,
    int? id, // Opcional para rotas com ID
  }) {
    return BeamPage(
      key: ValueKey(path + (id != null ? '-$id' : '')), // Chave única
      title: title, // Título obrigatório para o Beamer
      child: Builder(
        // Builder para robustez do contexto
        builder: (innerContext) {
          return TelaResponsiva(
            paginas: pageBuilder(900), // Constrói a página com largura 900
            menuPaginas: menuPaginasMap, // Passa o mapa de menu
          );
        },
      ),
      type: BeamPageType.fadeTransition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: BeamerDelegate(
        initialPath: '/Interface',
        locationBuilder: RoutesLocationBuilder(
          routes: {
            // Rotas usando o método auxiliar _createBeamPage
            '/Interface': (context, state, data) => _createBeamPage(
              path: '/Interface',
              title: 'Catálogo de Produtos',
              pageBuilder: (largura) => ListPage(largura: largura),
            ),
            '/Interface/Cadastro': (context, state, data) => _createBeamPage(
              path: '/Interface/Cadastro',
              title: 'Cadastro de Produto',
              pageBuilder: (largura) => CadastroFormpage(largura: largura),
            ),
            '/Cadastro/:id': (context, state, data) {
              final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
              return _createBeamPage(
                path: '/Cadastro/:id',
                title: 'Editar Produto',
                pageBuilder: (largura) =>
                    CadastroFormpage(largura: largura, id: id),
                id: id, // Passa o ID para a chave
              );
            },
            '/Cart': (context, state, data) => _createBeamPage(
              path: '/Cart',
              title: 'Carrinho de Compras',
              pageBuilder: (largura) => CartPage(largura: largura),
            ),
          },
        ).call,
      ),
      routeInformationParser: BeamerParser(),
    );
  }
}

class TelaResponsiva extends StatelessWidget {
  final Widget paginas;
  final Map<String, Widget Function(double)> menuPaginas;

  const TelaResponsiva({
    super.key,
    required this.paginas,
    required this.menuPaginas,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: MediaQuery.of(context).size.width < 600
            ? AppBar(
                backgroundColor: Colors.blueGrey.shade900,
                actions: [
                  Obx(
                    () => IconButton(
                      icon: Badge.count(
                        count: cartController.cartItemCount,
                        isLabelVisible: cartController.cartItemCount > 0,
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        context.beamToNamed('/Cart');
                      },
                    ),
                  ),
                ],
              )
            : null,
        drawer: MediaQuery.of(context).size.width < 600
            ? Drawer(
                child: Container(
                  color: Colors.blueGrey[800],
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.fastfood_rounded,
                          color: Colors.white,
                        ), // Este ícone é genérico, não é do carrinho
                        title: const Text(
                          'Catalogo',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          context.beamToNamed('/Interface');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.add, color: Colors.white),
                        title: const Text(
                          'Cadastro de Produto',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          context.beamToNamed('/Interface/Cadastro');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              )
            : null,
        body: Container(
          decoration: BoxDecoration(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              if (width > 1200) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HomePage(
                        largura: 280,
                        paginas: menuPaginas.map(
                          (key, func) => MapEntry(key, func(280)),
                        ),
                      ),
                      paginas,
                    ],
                  ),
                );
              } else if (width > 600) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HomePage(
                      largura: 280,
                      paginas: menuPaginas.map(
                        (key, func) => MapEntry(key, func(280)),
                      ),
                    ),
                    Flexible(child: paginas),
                  ],
                );
              } else {
                // Celular: só drawer + página
                return paginas;
              }
            },
          ),
        ),
      ),
    );
  }
}
