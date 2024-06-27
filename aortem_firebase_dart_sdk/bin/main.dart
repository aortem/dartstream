import 'package:aortem_firebase_dart_sdk/firebase_dart_auth.dart';

void main() async {
  final auth =
      FirebaseAuth(apiKey: 'YOUR_API_KEY', projectId: 'YOUR_PROJECT_ID');

  try {
    // Sign up a new user
    final newUser = await auth.createUserWithEmailAndPassword(
        'newuser@example.com', 'password123');
    print('User created: ${newUser.user.email}');

    // Sign in with the new user
    final userCredential = await auth.signInWithEmailAndPassword(
        'newuser@example.com', 'password123');
    print('Signed in: ${userCredential.user.email}');
  } catch (e) {
    print('Error: $e');
  }
}
