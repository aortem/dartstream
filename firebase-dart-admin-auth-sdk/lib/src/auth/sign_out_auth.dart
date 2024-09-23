import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
 Future<void> signOut() async {
    try {
      await FirebaseApp.instance.getAuth().signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

class FirebaseSignOUt {
    Future<void> signOut() async {
    FirebaseApp.instance.setCurrentUser(null);
  }
 // final FirebaseAuth auth;

  //FirebaseSignOUt(this.auth);
  //  Future<void> signOut() async {
  //   final auth = FirebaseApp.instance.getAuth();
  
  //   await auth.signOut();
  // } // Add constructor with auth parameter

  // // Future<void> signoutFromFirebase() async {
  // //   if (auth.currentUser == null) {
  // //     // Access currentUser through auth
  //     throw FirebaseAuthException(
  //       code: 'user-not-signed-in',
  //       message: 'No user is currently signed in.',
  //     );
  //   }

  //   try {
  //     await auth.performRequest('signOut', {
  //       'idToken': auth.currentUser!.uid
  //     }); // Access currentUser through auth
  //     auth.currentUser = null; // Clear the current user after signing out
  //   } catch (e) {
  //     print('Sign-out failed: $e');
  //     throw FirebaseAuthException(
  //       code: 'sign-out-error',
  //       message: 'Failed to sign out user.',
  //     );
  //   }
  // }
}
