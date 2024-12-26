import 'package:flutter/material.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'screens/login.dart';
import 'screens/home.dart';

class AuthDemo extends StatefulWidget {
  final DSAuthManager authManager;

  const AuthDemo({
    super.key,
    required this.authManager,
  });

  @override
  State<AuthDemo> createState() => _AuthDemoState();
}

class _AuthDemoState extends State<AuthDemo> {
  DSAuthUser? _currentUser;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      // Get user ID from token or session
      // Then load user details
      // This will be implemented based on how we're storing the current user
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $_error'),
              ElevatedButton(
                onPressed: _loadCurrentUser,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_currentUser != null) {
      return HomeScreen(
        user: _currentUser!,
        authManager: widget.authManager,
      );
    }

    return LoginScreen(authManager: widget.authManager);
  }
}
