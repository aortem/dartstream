import 'dart:io';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Usage: dart bin/main.dart <method> [args...]');
    print('Methods:');
    print('serviceAccountWithKeys <path_to_key_file>');
    print('environmentVariables <apiKeyEnvVar> <projectIdEnvVar>');
    print('serviceAccountWithoutKeyImpersonation <serviceAccountEmail> <userEmail>');
    exit(1);
  }

  final method = arguments[0];
  FirebaseAuth? auth;

  try {
    switch (method) {
      case 'serviceAccountWithKeys':
        if (arguments.length != 2) {
          print('Usage: serviceAccountWithKeys <path_to_key_file>');
          exit(1);
        }
        final keyFilePath = arguments[1];
        auth = FirebaseAuth.fromServiceAccountWithKeys(serviceAccountKeyFilePath: keyFilePath);
        break;

      case 'environmentVariables':
        if (arguments.length != 3) {
          print('Usage: environmentVariables <apiKeyEnvVar> <projectIdEnvVar>');
          exit(1);
        }
        final apiKeyEnvVar = arguments[1];
        final projectIdEnvVar = arguments[2];
        auth = FirebaseAuth.fromEnvironmentVariables(
          apiKey: Platform.environment[apiKeyEnvVar]!,
          projectId: Platform.environment[projectIdEnvVar]!,
        );
        break;

      case 'serviceAccountWithoutKeyImpersonation':
        if (arguments.length != 3) {
          print('Usage: serviceAccountWithoutKeyImpersonation <serviceAccountEmail> <userEmail>');
          exit(1);
        }
        final serviceAccountEmail = arguments[1];
        final userEmail = arguments[2];
        auth = FirebaseAuth.fromServiceAccountWithoutKeyImpersonation(
          serviceAccountEmail: serviceAccountEmail,
          userEmail: userEmail,
        );
        break;

      default:
        print('Unknown method: $method');
        exit(1);
    }

    // Example: Sign in with email and password
    final email = 'user@example.com';
    final password = 'password123';

    final userCredential = await auth.signInWithEmailAndPassword(email, password);
    print('Signed in as ${userCredential.user.email}');
  } catch (e) {
    print('Error: $e');
  }
}
