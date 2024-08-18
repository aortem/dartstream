import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class FirebaseLinkWithCredentailsUser {
  final FirebaseAuth auth;
  Future<UserCredential> linkCredential(User user, String? idToken) async {
    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'no-id-token',
        message: 'Failed to obtain an ID token for the credential.',
      );
    }

    final response = await auth.performRequest('linkWithCredential', {
      'idToken': idToken,
    });

    if (response.statusCode == 200) {
      final userCredential = UserCredential.fromJson(response.body);
      auth.updateCurrentUser(userCredential.user);
      FirebaseApp.instance.setCurrentUser(userCredential.user);
      return userCredential;
    } else {
      throw FirebaseAuthException(
        code: 'linking-failed',
        message: 'Failed to link credential: ${response.body}',
      );
    }
  }

  FirebaseLinkWithCredentailsUser({required this.auth});
  // Future<void> linkWithCredential({
  //   required String idToken,
  //   required String accessToken,
  //   required String providerId,
  // }) async {
  //   try {
  //     final response = await auth.performRequest('link', {
  //       'idToken': idToken,
  //       'accessToken': accessToken,
  //       'providerId': providerId,
  //     });
  //     log("response code $response");

  //     // Handle response
  //     if (response.statusCode == 200) {
  //       log('User successfully Link.');
  //       return jsonDecode(response.body as String);
  //     } else {
  //       log('Error Linking user: ${response.statusCode} - ${response.body}');
  //     }
  //   } catch (e) {
  //     log('Exception occurred: $e');
  //   }
  // }
}
