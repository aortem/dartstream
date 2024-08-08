import 'dart:async';
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/src/auth/auth_redirect_link.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/apply_action_code.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/email_password_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/custom_token_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/email_link_auth.dart';
// import 'package:firebase_dart_admin_auth_sdk/src/auth/get_multi_factor_resolver.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/phone_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/sign_out_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/oauth_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/update_current_user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/user_device_language.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/verify_password_reset_code.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart' as exceptions;
import 'package:firebase_dart_admin_auth_sdk/src/action_code_settings.dart';

// New imports for Sprint 2 #16 to #21
import 'package:firebase_dart_admin_auth_sdk/src/auth/password_reset_email.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/revoke_access_token.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/id_token_changed.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/auth_state_changed.dart';

import 'package:firebase_dart_admin_auth_sdk/src/auth/initialize_recaptcha_config.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/get_redirect_result.dart';
// import 'package:firebase_dart_admin_auth_sdk/src/auth/get_multi_factor_resolver.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/fetch_sign_in_methods.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/create_user_with_email_and_password.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/connect_auth_emulator.dart';
import 'package:firebase_dart_admin_auth_sdk/src/multi_factor_resolver.dart';

class FirebaseAuth {
  final String? apiKey;
  final String? projectId;

  late final http.Client httpClient;

  late EmailPasswordAuth emailPassword;
  late CustomTokenAuth customToken;
  late EmailLinkAuth emailLink;
  late PhoneAuth phone;
  late OAuthAuth oauth;
  late FirebaseSignOUt signOUt;
  late SignInWithRedirectService signInRedirect;
  late UpdateCurrentUser updateUserService;
  late UseDeviceLanguageService useDeviceLanguage;
  late VerifyPasswordResetCodeService verifyPasswordReset;
  late ApplyActionCode applyAction;

  // New service declarations for Sprint 2 #16 to #21
  late PasswordResetEmailService passwordResetEmail;
  late RevokeAccessTokenService revokeAccessToken;
  late IdTokenChangedService idTokenChanged;
  late AuthStateChangedService authStateChanged;

  late InitializeRecaptchaConfigService initializeRecaptchaConfigService;
  late GetRedirectResultService getRedirectResultService;
  // late GetMultiFactorResolverService getMultiFactorResolverService;
  late FetchSignInMethodsService fetchSignInMethods;
  late CreateUserWithEmailAndPasswordService
      createUserWithEmailAndPasswordService;
  late ConnectAuthEmulatorService connectAuthEmulatorService;

  User? currentUser;

  /// StreamControllers for managing auth state and ID token change events
  final StreamController<User?> authStateChangedController =
      StreamController<User?>.broadcast();
  final StreamController<User?> idTokenChangedController =
      StreamController<User?>.broadcast();

  FirebaseAuth({
    this.apiKey,
    this.projectId,
  }) {
    httpClient = http.Client();
    emailPassword = EmailPasswordAuth(this);
    customToken = CustomTokenAuth(this);
    emailLink = EmailLinkAuth(this);
    phone = PhoneAuth(this);
    oauth = OAuthAuth(this);
    signOUt = FirebaseSignOUt(this);
    signInRedirect = SignInWithRedirectService(auth: this);
    updateUserService = UpdateCurrentUser(auth: this);
    useDeviceLanguage = UseDeviceLanguageService(auth: this);
    verifyPasswordReset = VerifyPasswordResetCodeService(auth: this);
    applyAction = ApplyActionCode(this);

    // New service initializations for Sprint 2 #16 to #21
    passwordResetEmail = PasswordResetEmailService(auth: this);
    revokeAccessToken = RevokeAccessTokenService(auth: this);
    idTokenChanged = IdTokenChangedService(auth: this);
    authStateChanged = AuthStateChangedService(auth: this);
    applyAction = ApplyActionCode(this);

    initializeRecaptchaConfigService = InitializeRecaptchaConfigService(this);
    getRedirectResultService = GetRedirectResultService(this);
    // getMultiFactorResolverService = GetMultiFactorResolverService(this);
    fetchSignInMethods = FetchSignInMethodsService(auth: this);
    createUserWithEmailAndPasswordService =
        CreateUserWithEmailAndPasswordService(this);
    connectAuthEmulatorService = ConnectAuthEmulatorService(this);
  }

  // factory FirebaseAuth.fromServiceAccountWithKeys({
  //   required String serviceAccountKeyFilePath,
  // }) {
  //   final apiKey = 'your_api_key';
  //   final projectId = 'your_project_id';
  //   return FirebaseAuth._(
  //     apiKey: apiKey,
  //     projectId: projectId,
  //     httpClient: http.Client(),
  //   );
  // }

  // factory FirebaseAuth.fromEnvironmentVariables({
  //   required String apiKey,
  //   required String projectId,
  // }) {
  //   return FirebaseAuth._(
  //     apiKey: apiKey,
  //     projectId: projectId,
  //     httpClient: http.Client(),
  //   );
  // }

  // factory FirebaseAuth.fromServiceAccountWithoutKeyImpersonation({
  //   required String serviceAccountEmail,
  //   required String userEmail,
  // }) {
  //   final apiKey = 'your_api_key';
  //   final projectId = 'your_project_id';
  //   return FirebaseAuth._(
  //     apiKey: apiKey,
  //     projectId: projectId,
  //     httpClient: http.Client(),
  //   );
  // }

  Future<Map<String, dynamic>> performRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:$endpoint',
      {
        'key': apiKey,
      },
    );

    final response = await httpClient.post(url, body: json.encode(body));

    if (response.statusCode != 200) {
      throw exceptions.FirebaseAuthException(
        code: 'error-code',
        message: 'Error message',
      );
    }

    return json.decode(response.body);
  }

  // updateCurrentUser method to automatically trigger the streams
  void updateCurrentUser(User user) {
    currentUser = user;
    authStateChangedController.add(user);
    idTokenChangedController.add(user);
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) {
    return emailPassword.signIn(email, password);
  }

  // Future<UserCredential> createUserWithEmailAndPassword(
  //     String email, String password) {
  //   return emailPassword.signUp(email, password);
  // } my assined ticket in issue #11 done down

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
    return phone.verifyPhoneNumberWithCode(verificationId, smsCode);
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) {
    return phone.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> signInWithEmailLink(
      String email, String emailLinkUrl) {
    return emailLink.signInWithEmailLink(email, emailLinkUrl);
  }

  Future<void> signOut() async {
    if (currentUser == null) {
      throw FirebaseAuthException(
        code: 'user-not-signed-in',
        message: 'No user is currently signed in.',
      );
    }

    try {
      await signOUt.signoutFromFirebase();
      currentUser = null;
      return;
    } catch (e) {
      print('Sign-out failed: $e');
      throw FirebaseAuthException(
        code: 'sign-out-error',
        message: 'Failed to sign out user.',
      );
    }
  }

  Future<UserCredential> signInWithRedirect(String providerId) async {
    try {
      return await signInRedirect.signInWithRedirect(providerId);
    } catch (e) {
      print('Sign-in with redirect failed: $e');
      throw FirebaseAuthException(
        code: 'sign-in-redirect-error',
        message: 'Failed to sign in with redirect.',
      );
    }
  }

  Future<void> updateUserInformation(
      String userId, Map<String, dynamic> userData) async {
    try {
      await updateUserService.updateCurrentUser(userId, userData);
    } catch (e) {
      print('Update current user information failed: $e');
      throw FirebaseAuthException(
        code: 'update-current-user-error',
        message: 'Failed to update current user information.',
      );
    }
  }

  Future<void> deviceLanguage(String userId, String languageCode) async {
    try {
      await useDeviceLanguage.useDeviceLanguage(userId, languageCode);
    } catch (e) {
      print('Use device language failed: $e');
      throw FirebaseAuthException(
        code: 'use-device-language-error',
        message: 'Failed to set device language.',
      );
    }
  }

  Future<Map<String, dynamic>> verifyPasswordResetCode(String code) async {
    try {
      return await verifyPasswordReset.verifyPasswordResetCode(code);
    } catch (e) {
      print('Verify password reset code failed: $e');
      throw FirebaseAuthException(
        code: 'verify-password-reset-code-error',
        message: 'Failed to verify password reset code.',
      );
    }
  }

  Future<bool> applyActionCode(String actionCode) {
    return applyAction.applyActionCode(actionCode);
  }

  // New methods with complete functionality Sprint 2 #16 to #21

  /// Sends a password reset email to the specified email address.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await passwordResetEmail.sendPasswordResetEmail(email);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'password-reset-error',
        message: 'Failed to send password reset email: ${e.toString()}',
      );
    }
  }

  /// Revokes the specified access token.
  Future<void> revokeToken(String idToken) async {
    try {
      await revokeAccessToken.revokeToken(idToken);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'token-revocation-error',
        message: 'Failed to revoke access token: ${e.toString()}',
      );
    }
  }

  /// Returns a stream of User objects when the ID token changes.
  Stream<User?> onIdTokenChanged() {
    return idTokenChangedController.stream;
  }

  /// Returns a stream of User objects when the auth state changes.
  Stream<User?> onAuthStateChanged() {
    return authStateChangedController.stream;
  }

  /// Checks if the provided URL is a valid sign-in link for email authentication.
  bool isSignInWithEmailLink(String emailLink) {
    return this.emailLink.isSignInWithEmailLink(emailLink);
  }

  /// Sends a sign-in link to the specified email address using the provided ActionCodeSettings.
  Future<void> sendSignInLinkToEmail(
      String email, ActionCodeSettings settings) {
    return emailLink.sendSignInLinkToEmail(email, settings);
  }

  /// Disposes of the FirebaseAuth instance and releases resources.
  void dispose() {
    authStateChangedController.close();
    idTokenChangedController.close();
    httpClient.close();
  }

  Future<void> initializeRecaptchaConfig() {
    return initializeRecaptchaConfigService.initialize();
  }

  Future<UserCredential?> getRedirectResult() {
    return getRedirectResultService.getResult();
  }

  Future<void> setIdToken(String idToken) async {
    if (currentUser != null) {
      currentUser!.updateIdToken(idToken);
      idTokenChangedController.add(currentUser);
    }
  }

  // Future<MultiFactorResolver> getMultiFactorResolver(
  //     AuthCredential credential) {
  //   if (credential is EmailAuthCredential) {
  //     return getMultiFactorResolverService.resolve(credential);
  //   } else {
  //     throw FirebaseAuthException(
  //       code: 'invalid-credential',
  //       message:
  //           'Only EmailAuthCredential is supported for multi-factor authentication.',
  //     );
  //   }
  // }

  Future<List<String>> fetchSignInMethodsForEmail(String email) async {
    try {
      List<String> methods =
          await fetchSignInMethods.fetchSignInMethodsForEmail(email);
      return methods;
    } catch (e) {
      print('Fetch sign-in methods failed: $e');
      throw FirebaseAuthException(
        code: 'fetch-sign-in-methods-error',
        message: 'Failed to fetch sign-in methods for email.',
      );
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) {
    return createUserWithEmailAndPasswordService.create(email, password);
  }

  void connectAuthEmulator(String host, int port) {
    connectAuthEmulatorService.connect(host, port);
  }

  void setEmulatorUrl(String url) {
    // Implementation to set the emulator URL
    print('Emulator URL set to: $url');
  }
}
