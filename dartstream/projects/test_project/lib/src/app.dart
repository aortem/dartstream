import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'guards/auth_guard.dart';
import 'router/route_config.dart';

/// Main application widget with Ping Identity integration
class App extends StatelessWidget {
  const App({super.key});

  Widget build(BuildContext context) {
    // Define routes with guards
    final routes = [
      RouteConfig(path: '/login', builder: (_) => const LoginPage()),
      RouteConfig(
        path: '/dashboard',
        builder: (_) => const DashboardPage(),
        guards: [AuthGuard()], // Protect dashboard with auth guard
      ),
    ];

    final router = DartstreamRouter(routes: routes);

    return MaterialApp(
      title: 'Dartstream + Ping Identity',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/login',
      onGenerateRoute: router.onGenerateRoute,
    );
  }
}
