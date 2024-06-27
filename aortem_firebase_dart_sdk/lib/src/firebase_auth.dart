import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_credential.dart';
import 'user.dart';
import 'auth_credential.dart';
import 'auth_provider.dart';
import 'exceptions.dart';
import 'confirmation_result.dart';
import 'auth/auth_base.dart';
import 'auth/email_password_auth.dart';
import 'auth/custom_token_auth.dart';
import 'auth/email_link_auth.dart';
import 'auth/phone_auth.dart';
import 'auth/oauth_auth.dart';

class FirebaseAuth {
  final String apiKey;
  final String projectId;
  final http.Client _httpClient;

  late final EmailPasswordAuth _emailPasswordAuth;
  late final CustomTokenAuth _customTokenAuth;
  late final EmailLinkAuth _emailLinkAuth;
  late final PhoneAuth _phoneAuth;
  late final OAuthAuth _oAuthAuth;

  User? _currentUser;
  final StreamController<User?> _userChanges =
      StreamController<User?>.broadcast();

  FirebaseAuth({
    required this.apiKey,
    required this.projectId,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client() {
    _emailPasswordAuth = EmailPasswordAuth(this);
    _customTokenAuth = CustomTokenAuth(this);
    _emailLinkAuth = EmailLinkAuth(this);
    _phoneAuth = PhoneAuth(this);
    _oAuthAuth = OAuthAuth(this);
  }

  User? get currentUser => _currentUser;

  Stream<User?> get userChanges => _userChanges.stream;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) {
    return _emailPasswordAuth.signIn(email, password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) {
    return _emailPasswordAuth.signUp(email, password);
  }

  Future<UserCredential> signInWithCustomToken(String token) {
    return _customTokenAuth.signIn(token);
  }

  Future<void> sendSignInLinkToEmail(
      String email, ActionCodeSettings actionCodeSettings) {
    return _emailLinkAuth.sendSignInLinkToEmail(email, actionCodeSettings);
  }

  Future<UserCredential> signInWithEmailLink(String email, String emailLink) {
    return _emailLinkAuth.signInWithEmailLink(email, emailLink);
  }

  Future<ConfirmationResult> signInWithPhoneNumber(String phoneNumber) {
    return _phoneAuth.verifyPhoneNumber(phoneNumber);
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    if (credential is EmailAuthCredential) {
      return signInWithEmailAndPassword(credential.email, credential.password);
    } else if (credential is PhoneAuthCredential) {
      return _phoneAuth.signInWithCredential(credential);
    } else {
      throw UnimplementedError('This credential type is not implemented');
    }
  }

  Future<UserCredential> signInWithPopup(AuthProvider provider) {
    return _oAuthAuth.signInWithPopup(provider);
  }

  Future<void> signOut() async {
    _currentUser = null;
    _userChanges.add(null);
  }

  void dispose() {
    _userChanges.close();
    _httpClient.close();
  }

  Future<Map<String, dynamic>> _performRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$endpoint?key=$apiKey';
    final response = await _httpClient.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      final error = json.decode(response.body)['error'];
      throw FirebaseAuthException(
          code: error['message'], message: error['message']);
    }
  }

  void _updateCurrentUser(User user) {
    _currentUser = user;
    _userChanges.add(user);
  }
}
