import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

void main() async {
  // Method 1: Initialize Firebase using a service account key file.
  final authWithServiceAccount = FirebaseAuth.fromServiceAccountWithKeys(
    serviceAccountKeyFilePath: 'path/to/your/serviceAccountKey.json',
  );
  print('Initialized Firebase with service account key file.');

  // Example operation with authWithServiceAccount
  try {
    final result = await authWithServiceAccount.signInWithEmailAndPassword(
      'test@example.com',
      'password',
    );
    print('User signed in with service account: ${result.user.uid}');
  } catch (e) {
    print('Error signing in with service account: $e');
  }

  // Method 2: Initialize Firebase using environment variables.
  
  // Ensure the environment variables are set before running this.
  final authWithEnvVariables = FirebaseAuth.fromEnvironmentVariables(
    apiKeyEnvVar: 'FIREBASE_API_KEY',
    projectIdEnvVar: 'FIREBASE_PROJECT_ID',
  );
  print('Initialized Firebase with environment variables.');

  // Example operation with authWithEnvVariables
  try {
    final result = await authWithEnvVariables.signInWithEmailAndPassword(
      'test@example.com',
      'password',
    );
    print('User signed in with environment variables: ${result.user.uid}');
  } catch (e) {
    print('Error signing in with environment variables: $e');
  }

  // Method 3: Initialize Firebase using service account without key impersonation.
  final authWithServiceAccountWithoutKeyImpersonation =
      FirebaseAuth.fromServiceAccountWithoutKeyImpersonation(
    serviceAccountEmail: 'your-service-account-email@your-project-id.iam.gserviceaccount.com',
    userEmail: 'your-user-email@example.com',
  );
  print('Initialized Firebase with service account without key impersonation.');

  // Example operation with authWithServiceAccountWithoutKeyImpersonation
  try {
    final result = await authWithServiceAccountWithoutKeyImpersonation
        .signInWithEmailAndPassword('test@example.com', 'password');
    print('User signed in with service account without key impersonation: ${result.user.uid}');
  } catch (e) {
    print('Error signing in with service account without key impersonation: $e');
  }
}