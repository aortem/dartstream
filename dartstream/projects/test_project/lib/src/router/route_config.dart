import 'package:flutter/material.dart';
import '../guards/auth_guard.dart';

/// RouteConfig defines a route with optional guards
/// Guards are evaluated before allowing navigation to the route
class RouteConfig {
  final String path;
  final WidgetBuilder builder;
  final List<RouteGuard> guards;

  RouteConfig({
    required this.path,
    required this.builder,
    this.guards = const [],
  });

  /// Check if all guards allow access to this route
  Future<bool> canActivate(RouteContext context) async {
    for (final guard in guards) {
      final allowed = await guard.canActivate(context);
      if (!allowed) return false;
    }
    return true;
  }
}

/// Simple router implementation with guard support
class DartstreamRouter {
  final List<RouteConfig> routes;

  DartstreamRouter({required this.routes});

  /// Generate route with guard evaluation
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Find matching route
    final routeConfig = routes.firstWhere(
      (route) => route.path == settings.name,
      orElse: () => routes.first, // Default to first route (typically login)
    );

    return MaterialPageRoute(
      builder: (context) {
        // Create future builder to evaluate guards
        return FutureBuilder<bool>(
          future: routeConfig.canActivate(
            RouteContext(
              path: settings.name ?? '/',
              params: settings.arguments as Map<String, dynamic>? ?? {},
            ),
          ),
          builder: (context, snapshot) {
            // Show loading while evaluating guards
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Check if access is allowed
            final isAllowed = snapshot.data ?? false;

            if (!isAllowed) {
              // Redirect to login if not allowed
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed('/login');
              });
              return const SizedBox.shrink();
            }

            // Build the actual page if allowed
            return routeConfig.builder(context);
          },
        );
      },
      settings: settings,
    );
  }
}
