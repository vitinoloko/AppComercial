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
    double width = MediaQuery.of(context).size.width;

    Widget buildNavigationRail() {
      return Obx(
        () => NavigationRail(
          backgroundColor: Colors.blueGrey,
          selectedIndex: getSelectedIndex(context),
          onDestinationSelected: (index) {
            if (index == 0) {
              context.beamToNamed('/Interface');
            } else if (index == 1) {
              context.beamToNamed('/Interface/Cadastro');
            } else if (index == 2) {
              context.beamToNamed('/Cart');
            }
          },
          labelType: NavigationRailLabelType.all,
          leading: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Menu', style: TextStyle(color: Colors.white)),
          ),
          destinations: [
            const NavigationRailDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon: Icon(Icons.list_alt),
              label: Text('Catálogo'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.add),
              selectedIcon: Icon(Icons.add_circle),
              label: Text('Cadastro'),
            ),
            NavigationRailDestination(
              icon: Badge.count(
                count: cartController.cartItemCount,
                isLabelVisible: cartController.cartItemCount > 0,
                child: Icon(Icons.shopping_cart_outlined),
              ),

              selectedIcon: Badge.count(
                count: cartController.cartItemCount,
                isLabelVisible: cartController.cartItemCount > 0,
                child: Icon(Icons.shopping_cart),
              ),

              label: Text('Carrinho'),
              disabled: cartController.cartItemCount <= 0 ? true : false,
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,

        body: LayoutBuilder(
          builder: (context, constraints) {
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
              // Celular: NavigationRail lateral + página
              return Row(
                children: [
                  buildNavigationRail(),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(child: paginas),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  int getSelectedIndex(BuildContext context) {
    final path = Beamer.of(context).currentConfiguration!.uri.path;
    if (path.startsWith('/Interface/Cadastro')) return 1;
    if (path.startsWith('/Cart')) return 2;
    return 0;
  }
}
