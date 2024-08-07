import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/src/auth/auth_redirect_link.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/apply_action_code.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/email_password_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/custom_token_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/email_link_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/phone_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/reload_user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/send_email_verification_code.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/set_language_code.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/sign_out_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/oauth_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/unlink_provider.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/update_current_user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/update_password.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/user_device_language.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/verify_password_reset_code.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_app.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/action_code_settings.dart';

// New imports for Sprint 2 #16 to #21
import 'package:firebase_dart_admin_auth_sdk/src/auth/password_reset_email.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/revoke_access_token.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/id_token_changed.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/auth_state_changed.dart';

import 'auth/auth_link_with_phone_number.dart';
import 'auth/parseActionCodeURL .dart';
import 'firebase_user/delete_user.dart';
import 'firebase_user/link_with_credentails.dart';
import 'id_token_result_model.dart';

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

  late ReloadUser _reloadUser;
  late SendEmailVerificationCode _sendEmailVerificationCode;
  late SetLanguageCode _setLanguageCode;
  late UnlinkProvider _unlinkProvider;
  late UpdatePassword _updatePassword;

  // New service declarations for Sprint 2 #16 to #21
  late PasswordResetEmailService passwordResetEmail;
  late RevokeAccessTokenService revokeAccessToken;
  late IdTokenChangedService idTokenChanged;
  late AuthStateChangedService authStateChanged;

////Ticket mo 36 to 41///////////////
  late FirebasePhoneNumberLink firebasePhoneNumberLink;
  late FirebaseParseUrlLink firebaseParseUrlLink;
  late FirebaseDeleteUser firebaseDeleteUser;
  late FirebaseLinkWithCredentailsUser firebaseLinkWithCredentailsUser;

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
    signOUt = FirebaseSignOUt();
    signInRedirect = SignInWithRedirectService(auth: this);
    updateUserService = UpdateCurrentUser(auth: this);
    useDeviceLanguage = UseDeviceLanguageService(auth: this);
    verifyPasswordReset = VerifyPasswordResetCodeService(auth: this);
    applyAction = ApplyActionCode(this);

    _reloadUser = ReloadUser(auth: this);
    _sendEmailVerificationCode = SendEmailVerificationCode(auth: this);
    _setLanguageCode = SetLanguageCode(auth: this);
    _unlinkProvider = UnlinkProvider(auth: this);
    _updatePassword = UpdatePassword(auth: this);

    // New service initializations for Sprint 2 #16 to #21
    passwordResetEmail = PasswordResetEmailService(auth: this);
    revokeAccessToken = RevokeAccessTokenService(auth: this);
    idTokenChanged = IdTokenChangedService(auth: this);
    authStateChanged = AuthStateChangedService(auth: this);
    applyAction = ApplyActionCode(this);

    firebasePhoneNumberLink = FirebasePhoneNumberLink(auth: this);
    firebaseParseUrlLink = FirebaseParseUrlLink(auth: this);
    firebaseDeleteUser = FirebaseDeleteUser(auth: this);
    firebaseLinkWithCredentailsUser =
        FirebaseLinkWithCredentailsUser(auth: this);
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

  Future<HttpResponse> performRequest(
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
      final error = json.decode(response.body)['error'];
      throw FirebaseAuthException(
        code: error['message'],
        message: error['message'],
      );
    }
    return HttpResponse(
        statusCode: response.statusCode, body: json.decode(response.body));
  }

  // updateCurrentUser method to automatically trigger the streams
  void updateCurrentUser(User user) {
    currentUser = currentUser == null ? user : currentUser?.copyWith(user);
    authStateChangedController.add(currentUser);
    idTokenChangedController.add(currentUser);
  }

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) {
    return emailPassword.signIn(email, password);
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) {
    return emailPassword.signUp(email, password);
  }

  Future<UserCredential> signInWithCustomToken(String token) {
    return customToken.signInWithCustomToken(token);
  }

  Future<Future<UserCredential?>> signInWithCredential(
      AuthCredential credential) async {
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

  Future<UserCredential> signInWithEmailLink(
      String email, String emailLinkUrl) {
    return emailLink.signInWithEmailLink(email, emailLinkUrl);
  }

  Future<void> signOut() async {
    if (FirebaseApp.instance.getCurrentUser() == null) {
      throw FirebaseAuthException(
        code: 'user-not-signed-in',
        message: 'No user is currently signed in.',
      );
    }

    try {
      await signOUt.signOut();
      FirebaseApp.instance.setCurrentUser(null);
      log('User Signout ');
      return;
    } catch (e) {
      log('Sign-out failed: $e');
      throw FirebaseAuthException(
        code: 'sign-out-error',
        message: 'Failed to sign out user.',
      );
    }
  }

  Future<void> signInWithRedirect(String providerId) async {
    try {
      await signInRedirect.signInWithRedirect(providerId);
    } catch (e) {
      print('Sign-in with redirect failed: $e');
      throw FirebaseAuthException(
        code: 'sign-in-redirect-error',
        message: 'Failed to sign in with redirect.',
      );
    }
  }

  Future<Map<String, dynamic>> signInWithRedirectResult(
      String providerId) async {
    try {
      return await signInRedirect.handleRedirectResult();
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

  Future<void> deviceLanguage(String languageCode) async {
    try {
      await useDeviceLanguage.useDeviceLanguage(
          currentUser!.idToken!, languageCode);
    } catch (e) {
      print('Use device language failed: $e');
      throw FirebaseAuthException(
        code: 'use-device-language-error',
        message: 'Failed to set device language.',
      );
    }
  }

  Future<HttpResponse> verifyPasswordResetCode(String code) async {
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

  Future<User> reloadUser() {
    return _reloadUser.reloadUser(
      currentUser?.idToken,
    );
  }

  Future<void> sendEmailVerificationCode() {
    return _sendEmailVerificationCode
        .sendEmailVerificationCode(currentUser?.idToken);
  }

  Future<User> setLanguageCode(String languageCode) {
    return _setLanguageCode.setLanguageCode(
      currentUser?.idToken,
      languageCode,
    );
  }

  Future<User> unlinkProvider(String providerId) {
    return _unlinkProvider.unlinkProvider(
      currentUser?.idToken,
      providerId,
    );
  }

  Future<User> updatePassword(String newPassowrd) {
    return _updatePassword.updatePassword(
      newPassowrd,
      currentUser?.idToken,
    );
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

///////Firebase link with creential////////////
  Future<void> linkWithCredential(AuthCredential credential) async {
    firebaseLinkWithCredentailsUser.linkWithCredential(
        idToken: currentUser!.idToken!,
        accessToken: "accessToken",
        providerId: 'google.com');
  }

  ///////////a Firebase action code URL
  Future<Map<String, dynamic>> parseActionCodeUrl(String url) async {
    final uri = Uri.parse(url);
    final queryParams = uri.queryParameters;

    final code = queryParams['oobCode'];
    final apiKey = queryParams['apiKey'];
    final mode = queryParams['mode'];
    final continueUrl = queryParams['continueUrl'];
    final languageCode = queryParams['languageCode'];
    final clientId = queryParams['clientId'];

    return {
      'code': code,
      'apiKey': apiKey,
      'mode': mode,
      'continueUrl': continueUrl,
      'languageCode': languageCode,
      'clientId': clientId,
    };
  }

  ///////////FirebaseUser phone number link
  Future<void> firebasePhoneNumberLinkMethod(String phone) async {
    try {
      await firebasePhoneNumberLink.sendVerificationCode(phone);
    } catch (e) {
      log("error is $e");
      throw FirebaseAuthException(
        code: 'vrtification - code -error',
        message:
            'Failed to send verification code to phone number: ${e.toString()}',
      );
    }
  }

  ////////////FirebaseUser.deleteUser
  Future<void> deleteFirebaseUser() async {
    if (FirebaseApp.instance.getCurrentUser() == null) {
      throw FirebaseAuthException(
        code: 'user-not-signed-in',
        message: 'No user is currently signed in.',
      );
    }

    try {
      await firebaseDeleteUser.deleteUser(currentUser!);
      FirebaseApp.instance.setCurrentUser(null);
      log('User Deleted ');
      return;
    } catch (e) {
      log('User Delete failed: $e');
      throw FirebaseAuthException(
        code: 'user-delete-error',
        message: 'Failed to delete user.',
      );
    }
  }

  /////////FirebaseUser.getIdToken
  Future<String?> getIdToken() async {
    final user = currentUser;
    return await user?.getIdToken();
  }

  //////////// FirebaseUser.getIdTokenResult
  Future<IdTokenResult?> getIdTokenResult() async {
    final user = currentUser;
    return await user?.getIdTokenResult();
  }

  /// Disposes of the FirebaseAuth instance and releases resources.
  void dispose() {
    authStateChangedController.close();
    idTokenChangedController.close();
    httpClient.close();
  }
}
