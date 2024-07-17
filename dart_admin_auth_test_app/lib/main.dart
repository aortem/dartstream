import 'package:bot_toast/bot_toast.dart';
import 'package:dart_admin_auth_test_app/screens/splash_screen/splash_screen.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';

void main() async {
  //Add your project's api key and project id here
  FirebaseApp.initializeAppWithEnvironmentVariables(apiKey: '', projectId: '');

  FirebaseApp.instance.getAuth();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Admin Demo',
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
