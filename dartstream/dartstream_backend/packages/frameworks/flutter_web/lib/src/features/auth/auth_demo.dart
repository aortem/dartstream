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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Attempt to verify any existing token
      final isValidToken = await widget.authManager.verifyToken('current');

      if (isValidToken) {
        // Get current user if token is valid
        final user = await widget.authManager.getCurrentUser();
        if (mounted) {
          setState(() {
            _currentUser = user;
            _loading = false;
          });
          return;
        }
      } else {
        // Token invalid or not present
        if (mounted) {
          setState(() {
            _currentUser = null;
            _loading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e is DSAuthError ? e.message : e.toString();
          _currentUser = null;
          _loading = false;
        });
      }
    }
  }

  void _handleLoginSuccess() {
    _loadCurrentUser();
  }

  void _handleSignOut() {
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $_error'),
              const SizedBox(height: 16),
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
        onSignOut: _handleSignOut,
      );
    }

    return LoginScreen(
      authManager: widget.authManager,
      onLoginSuccess: _handleLoginSuccess,
    );
  }
}
