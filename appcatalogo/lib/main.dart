import 'package:appcatalogo/homepage.dart';
import 'package:appcatalogo/page/cadastro_produto/cadastro_formpage.dart';
import 'package:appcatalogo/page/cadastro_produto/cart_controller.dart';
import 'package:appcatalogo/page/cadastro_produto/cart_page.dart';
import 'package:appcatalogo/page/cadastro_produto/food_controller.dart';
import 'package:appcatalogo/page/cadastro_produto/list_page.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Imports mantidos iguais

void main() {
  Get.put(FoodController());
  Get.put(CartController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Map<String, Widget Function(double)> paginas = {
    '/Interface': (largura) => ListPage(largura: largura),
    '/Interface/Cadastro': (largura) => CadastroFormpage(largura: largura),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: BeamerDelegate(
        initialPath: '/Interface',
        locationBuilder: RoutesLocationBuilder(
          routes: {
            for (var entry in paginas.entries)
              entry.key: (context, state, data) {
                return BeamPage(
                  child: TelaResponsiva(
                    paginas: entry.value(800), // widget da rota atual
                    menuPaginas: paginas, // passando o mapa para o menu
                  ),
                  type: BeamPageType.fadeTransition,
                );
              },
            '/Cadastro/:id': (context, state, data) {
              final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
              return BeamPage(
                key: ValueKey('Cadastro-$id'),
                child: TelaResponsiva(
                  paginas: CadastroFormpage(largura: 800, id: id),
                  menuPaginas: paginas, // mesmo mapa para o menu
                ),
              );
            },
            //   Se você definiu uma rota '/cart' separada, adicione-a aqui
            // Exemplo:
            '/Cart': (context, state, data) => BeamPage(
              key: ValueKey('cart_page_route'),
              child: TelaResponsiva(
                paginas: CartPage(largura: 800),
                menuPaginas: paginas,
              ),
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
            ? AppBar(backgroundColor: Colors.blueGrey.shade900)
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
                          Icons.shopping_bag_sharp,
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
                      Obx(
                        // Obx para reagir a cartController.cartItemCount
                        () => ListTile(
                          leading: Badge.count(
                            count: cartController
                                .cartItemCount, // <--- REMOVIDO .bitLength!
                            isLabelVisible:
                                cartController.cartItemCount >
                                0, // Opcional: Só mostra se > 0
                            child: const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                          ),
                          title: const Text(
                            'Carrinho',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            context.beamToNamed('/Cart');
                            Navigator.pop(context);
                          },
                        ),
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
              if (width > 1100) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
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
