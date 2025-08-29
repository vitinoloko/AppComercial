import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:front_end_frotas/widget/bindings.dart';
import 'package:front_end_frotas/task/controllers/auth_controller.dart';
import 'package:front_end_frotas/task/pages/form_test.dart';
import 'package:front_end_frotas/task/pages/form_text.dart';
import 'package:front_end_frotas/task/pages/home_page.dart';
import 'package:front_end_frotas/task/pages/menu_page.dart';
import 'package:front_end_frotas/login_page.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthBindig().dependencies();
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  // final TaskService tasks;
  Myapp({super.key});
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      routerDelegate: BeamerDelegate(
        initialPath: '/login',
        guards: [
          // Protege rotas privadas (precisam de token)
          BeamGuard(
            pathPatterns: ['/home*', '/cadastro*', '/sla*'],
            check: (context, location) => authController.user.value != null,
            beamToNamed: (origin, target) => '/login',
          ),
          // Protege o login (só pode abrir sem token)
          BeamGuard(
            pathPatterns: ['/login'],
            check: (context, location) => authController.user.value == null,
            beamToNamed: (origin, target) => '/home',
          ),
        ],
        locationBuilder: RoutesLocationBuilder(
          routes: {
            '/login': (context, state, data) {
              AuthBindig().dependencies();
              return BeamPage(
                key: const ValueKey('login'),
                title: 'login',
                type: BeamPageType.slideTransition,
                child: LoginPage(),
                // child: LayoutBase(child: LazyScreen(child: HomePage())),
              );
            },
            '/home': (context, state, data) {
              TaskBindig().dependencies();
              return BeamPage(
                key: const ValueKey('home'),
                title: 'Home',
                type: BeamPageType.fadeTransition,
                child: LayoutBase(child: HomePage()),
                // child: LayoutBase(child: LazyScreen(child: HomePage())),
              );
            },
            '/cadastro': (context, state, data) => BeamPage(
              key: const ValueKey('cadastro'),
              title: 'Cadastro',
              type: BeamPageType.fadeTransition,
              child: LayoutBase(child: FormText()),
              // child: LayoutBase(child: LazyScreen(child: const FormText())),
            ),
            '/sla': (context, state, data) => BeamPage(
              key: const ValueKey('sla'),
              title: 'sla',
              type: BeamPageType.fadeTransition,
              child: LayoutBase(child: Sla()),
              // child: LayoutBase(child: LazyScreen(child: const FormText())),
            ),
          },
        ).call,
      ),
      routeInformationParser: BeamerParser(),
    );
  }
}

class LayoutBase extends StatelessWidget {
  final Widget child;
  const LayoutBase({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width * 0.10; // 5% da largura da tela
    final verticalPadding = width > 800 ? 20.0 : 10.0;
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      appBar: width <= 750 ? AppBar(title: const Text("App")) : null,
      drawer: width <= 750
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.green),
                    child: Text(
                      'Menu',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.of(context).pop(); // fecha o drawer
                      context.beamToNamed('/home');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Cadastro'),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.beamToNamed('/cadastro');
                    },
                  ),
                ],
              ),
            )
          : null,
      body: width > 750
          ? Container(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: verticalPadding,
                horizontal: horizontalPadding,
              ),
              child: Row(
                children: [
                  MenuPage(), // menu lateral desktop
                  Flexible(child: child),
                ],
              ),
            )
          : SafeArea(child: child),
    );
  }
}

class ResponsiveBody extends StatelessWidget {
  final Widget child;
  const ResponsiveBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 750) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 130),
        child: Row(
          children: [
            MenuPage(), // const para não rebuildar
            Expanded(child: child),
          ],
        ),
      );
    } else {
      return SafeArea(
        child: Column(children: [Expanded(child: child)]),
      );
    }
  }
}

// class LazyScreen extends StatefulWidget {
//   final Widget child;
//   const LazyScreen({super.key, required this.child});

//   @override
//   State<LazyScreen> createState() => _LazyScreenState();
// }

// class _LazyScreenState extends State<LazyScreen> {
//   bool _isBuilt = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_isBuilt) {
//       // Pequeno delay para simular build lazy
//       Future.microtask(() => setState(() => _isBuilt = true));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isBuilt) {
//       return Container(
//         width: 800,
//         decoration: BoxDecoration(
//           color: Colors.amber,
//           borderRadius: MediaQuery.of(context).size.width < 800
//               ? BorderRadius.horizontal(right: Radius.circular(0))
//               : BorderRadius.horizontal(right: Radius.circular(16)),
//         ),
//         child: const Center(child: CircularProgressIndicator()),
//       );
//     }
//     return widget.child;
//   }
// }
