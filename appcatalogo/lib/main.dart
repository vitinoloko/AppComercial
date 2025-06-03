import 'package:appcatalogo/homepage.dart';
import 'package:appcatalogo/page/cadastro_produto/cadastro_formpage.dart';
import 'package:appcatalogo/page/cadastro_produto/food_controller.dart';
import 'package:appcatalogo/page/cadastro_produto/list_page.dart';
import 'package:appcatalogo/page/other/grafico.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(FoodController());
  runApp(const MyApp());
}

final Map<String, Widget> paginas = {
  '/': ListPage(largura: 800),
  '/Cadastro': CadastroFormpage(largura: 800),
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: BeamerDelegate(
        initialPath: '/',
        locationBuilder: RoutesLocationBuilder(
          routes: {
            // '/login': (context, state, data) => LoginApp(),
            for (var entry in paginas.entries)
              entry.key: (context, state, data) => BeamPage(
                child: TelaResponsiva(paginas: entry.value),
                type: BeamPageType.fadeTransition,
              ),
            // '/mapa':
            //     (context, state, data) => BeamPage(
            //       child: MapaPage(),
            //       type: BeamPageType.fadeTransition,
            //     ),
          },
        ).call,
      ),
      routeInformationParser: BeamerParser(),
    );
  }
}

class TelaResponsiva extends StatelessWidget {
  final Widget paginas;

  const TelaResponsiva({super.key, required this.paginas});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: MediaQuery.of(context).size.width < 600
            ? AppBar(backgroundColor: Colors.blueGrey[900])
            : null,
        drawer: MediaQuery.of(context).size.width < 600
            ? Drawer(
                child: Container(
                  color: Colors.blueGrey[800],
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      meuGrafico(),
                      ListTile(
                        leading: Icon(Icons.home, color: Colors.white),
                        title: Text(
                          'Início',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          context.beamToNamed('/');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.stacked_line_chart,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Teste',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          context.beamToNamed('/Cadastro');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              )
            : null,
        body: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            if (width > 1100) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HomePage(largura: 280, paginas: {}),
                    paginas,
                  ],
                ),
              );
            } else if (width > 850) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomePage(largura: 280, paginas: {}),
                  Flexible(child: paginas),
                ],
              );
            } else if (width > 600) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomePage(largura: 280, paginas: {}),
                  Flexible(child: paginas),
                ],
              );
            } else {
              // 📱 Celular: Só Drawer + página
              return paginas;
            }
          },
        ),
      ),
    );
  }
}
