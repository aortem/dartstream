import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
//import 'package:http/http.dart' as http;
import 'auth/email_password_auth.dart';
import 'auth/custom_token_auth.dart';
import 'auth/email_link_auth.dart';
import 'auth/phone_auth.dart';
import 'auth/oauth_auth.dart';
import 'user.dart';
import 'user_credential.dart';
import 'exceptions.dart';
import 'auth_credential.dart';
import 'action_code_settings.dart';

class FirebaseAuth {
  final String apiKey;
  final String projectId;
  final http.Client httpClient;

  late EmailPasswordAuth emailPassword;
  late CustomTokenAuth customToken;
  late EmailLinkAuth emailLink;
  late PhoneAuth phone;
  late OAuthAuth oauth;

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
    oauth = OAuthAuth(this);
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
  Future<UserCredential> signInWithCustomToken(String token) {
    return customToken.signInWithCustomToken(token);
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    if (credential is EmailAuthCredential) {
      return signInWithEmailAndPassword(credential.email, credential.password);
    } else if (credential is PhoneAuthCredential) {
      return signInWithPhoneNumber(
          credential.verificationId, credential.smsCode);
    } else if (credential is OAuthCredential) {
      return signInWithPopup(credential.providerId);
    } else {
      throw FirebaseAuthException(
        code: 'unsupported-credential',
        message: 'Unsupported credential type',
      );
    }
  }

  Future<UserCredential> signInWithPopup(String providerId) {
    return oauth.signInWithPopup(providerId);
  }

  Future<UserCredential> signInWithPhoneNumber(
      String verificationId, String smsCode) {
    return phone.verifyPhoneNumber(verificationId, smsCode);
  }

  Future<void> sendSignInLinkToEmail(
      String email, ActionCodeSettings settings) {
    return emailLink.sendSignInLinkToEmail(email, settings);
  }

  Future<UserCredential> signInWithEmailLink(
      String email, String emailLinkUrl) {
    return emailLink.signInWithEmailLink(email, emailLinkUrl);
  }
}
