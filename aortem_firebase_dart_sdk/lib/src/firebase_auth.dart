import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth/email_password_auth.dart';
import 'auth/custom_token_auth.dart';
import 'auth/email_link_auth.dart';
import 'auth/phone_auth.dart';
import 'user.dart';
import 'user_credential.dart';
import 'exceptions.dart';

class FirebaseAuth {
  final String apiKey;
  final String projectId;
  final http.Client httpClient;

  late EmailPasswordAuth emailPassword;
  late CustomTokenAuth customToken;
  late EmailLinkAuth emailLink;
  late PhoneAuth phone;

  User? currentUser;

  FirebaseAuth({
    required this.apiKey,
    required this.projectId,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client() {
    emailPassword = EmailPasswordAuth(this);
    customToken = CustomTokenAuth(this);
    emailLink = EmailLinkAuth(this);
    phone = PhoneAuth(this);
  }

  Future<Map<String, dynamic>> performRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url =
        Uri.https('identitytoolkit.googleapis.com', '/v1/accounts:$endpoint', {
      'key': apiKey,
    });

    final response = await httpClient.post(url, body: json.encode(body));

    if (response.statusCode != 200) {
      final error = json.decode(response.body)['error'];
      throw FirebaseAuthException(
        code: error['message'],
        message: error['message'],
      );
    }

    return json.decode(response.body);
  }

  void updateCurrentUser(User user) {
    currentUser = user;
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) {
    return emailPassword.signIn(email, password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) {
    return emailPassword.signUp(email, password);
  }

  // Implement other methods (signInWithCustomToken, sendSignInLinkToEmail, etc.)
}
