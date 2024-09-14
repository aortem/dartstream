import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

void main() async {
  final auth =
      FirebaseAuth(apiKey: 'YOUR_API_KEY', projectId: 'YOUR_PROJECT_ID');

  try {
    // Sign up a new user
    final newUser = await auth.createUserWithEmailAndPassword(
        'newuser@example.com', 'password123');
<<<<<<< HEAD
    print('User created: ${newUser?.user.displayName}');
=======
    print('User created: ${newUser?.user.email}');
>>>>>>> 446aaefeaed6d465b7bd9c923a9e144462edeeb2

    // Sign in with the new user
    final userCredential = await auth.signInWithEmailAndPassword(
        'newuser@example.com', 'password123');
    print('Signed in: ${userCredential?.user.email}');
  } catch (e) {
    print('Error: $e');
  }
}
