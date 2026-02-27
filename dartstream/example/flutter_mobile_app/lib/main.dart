import 'package:flutter/material.dart';
import 'package:flutter_mobile_app/models/user.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/session_service.dart';
import 'api/auth_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final savedSession = await SessionService.getSession();
  User? user;

  if (savedSession != null) {
    user = await AuthApi.getSession(savedSession);
  }

  runApp(DartStreamApp(initialUser: user));
}

class DartStreamApp extends StatelessWidget {
  final User? initialUser;
  const DartStreamApp({super.key, this.initialUser});

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialUser != null
          ? HomeScreen(user: initialUser!)
          : const LoginScreen(),
    );
  }
}
