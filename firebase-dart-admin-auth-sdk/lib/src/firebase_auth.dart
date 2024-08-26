import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
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
import 'package:firebase_dart_admin_auth_sdk/src/auth_provider.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart' as exceptions;
import 'package:firebase_dart_admin_auth_sdk/src/firebase_app.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';
import 'package:firebase_dart_admin_auth_sdk/src/popup_redirect_resolver.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/action_code_settings.dart'
    as acs;

// New imports for Sprint 2 #16 to #21
import 'package:firebase_dart_admin_auth_sdk/src/auth/password_reset_email.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/revoke_access_token.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/id_token_changed.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/auth_state_changed.dart';

import 'package:firebase_dart_admin_auth_sdk/src/auth/fetch_sign_in_methods.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/create_user_with_email_and_password.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/connect_auth_emulator.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/get_redirect_result.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/recaptcha_config.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/confirm_password_reset.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/check_action_code.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/get_multi_factor.dart'
    as multi_factor;
import 'auth/auth_link_with_phone_number.dart';
import 'auth/parseActionCodeURL .dart';
import 'firebase_user/delete_user.dart';
import 'firebase_user/link_with_credentails.dart';
import 'id_token_result_model.dart';

class FirebaseAuth {
  final String? apiKey;
  final String? projectId;
  final String? authDomain;

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

  late FetchSignInMethodsService fetchSignInMethods;
  late CreateUserWithEmailAndPasswordService
      createUserWithEmailAndPasswordService;
  late ConnectAuthEmulatorService connectAuthEmulatorService;
  late GetRedirectResultService getRedirectResultService;
  late final RecaptchaConfigService recaptchaConfigService;
  late ConfirmPasswordResetService confirmPasswordResetService;
  late CheckActionCodeService checkActionCodeService;
  late final multi_factor.MultiFactorService multiFactorService;
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
    this.authDomain,
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

    fetchSignInMethods = FetchSignInMethodsService(auth: this);
    createUserWithEmailAndPasswordService =
        CreateUserWithEmailAndPasswordService(this);
    connectAuthEmulatorService = ConnectAuthEmulatorService(this);
    getRedirectResultService = GetRedirectResultService(auth: this);
    recaptchaConfigService = RecaptchaConfigService();
    confirmPasswordResetService = ConfirmPasswordResetService(auth: this);
    checkActionCodeService = CheckActionCodeService(auth: this);
    multiFactorService = multi_factor.MultiFactorService(auth: this);
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

  // Future<UserCredential> createUserWithEmailAndPassword(
  //     String email, String password) {
  //   return emailPassword.signUp(email, password);
  // } my assined ticket in issue #11 done down
  // Future<UserCredential?> createUserWithEmailAndPassword(
  //     String email, String password) {
  //   return emailPassword.signUp(email, password);
  // }

  Future<UserCredential> signInWithCustomToken(String token) {
    return customToken.signInWithCustomToken(token);
  }

  Future<Future<Object?>> signInWithCredential(
      AuthCredential credential) async {
    if (credential is EmailAuthCredential) {
      return signInWithEmailAndPassword(credential.email, credential.password);
    } else if (credential is PhoneAuthCredential) {
      return signInWithPhoneNumber(
          credential.verificationId, credential.smsCode as ApplicationVerifier);
    } else if (credential is OAuthCredential) {
      return signInWithPopup(credential.providerId as AuthProvider);
    } else {
      throw FirebaseAuthException(
        code: 'unsupported-credential',
        message: 'Unsupported credential type',
      );
    }
  }

  Future<UserCredential> signInWithPopup(
    AuthProvider provider, {
    PopupRedirectResolver? resolver,
  }) async {
    try {
      return await oauth.signInWithPopup(provider, resolver: resolver);
    } catch (e) {
      if (e is FirebaseAuthException) {
        rethrow;
      }
      throw FirebaseAuthException(
        code: 'popup-sign-in-error',
        message: 'Failed to sign in with popup: ${e.toString()}',
      );
    }
  }

  Future<ConfirmationResult> signInWithPhoneNumber(
    String phoneNumber,
    ApplicationVerifier appVerifier,
  ) async {
    try {
      return await phone.signInWithPhoneNumber(phoneNumber, appVerifier);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'phone-auth-error',
        message: 'Failed to sign in with phone number: ${e.toString()}',
      );
    }
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
    log("hekko");
    log("hekko${FirebaseApp.instance.getCurrentUser()}");
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
      String userId, String idToken, Map<String, dynamic> userData) async {
    try {
      await updateUserService.updateCurrentUser(userId, idToken, userData);
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
    return emailLink.sendSignInLinkToEmail(
        email, settings as acs.ActionCodeSettings);
  }

///////Firebase link with creential////////////
  // Future<void> linkWithCredential(AuthCredential credential) async {
  //   firebaseLinkWithCredentailsUser.linkWithCredential(
  //       idToken: currentUser!.idToken!,
  //       accessToken: "accessToken",
  //       providerId: 'google.com');
  // }
  Future<UserCredential?> linkWithCredential(AuthCredential credential) async {
    final currentUser = FirebaseApp.instance.getCurrentUser();

    if (currentUser == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No user is currently signed in.',
      );
    }

    if (credential is EmailAuthCredential) {
      // Re-authenticate the user with email and password before linking
      final authResult = await signInWithEmailAndPassword(
          credential.email, credential.password);
      return firebaseLinkWithCredentailsUser.linkCredential(
          currentUser, currentUser.idToken);
    } else if (credential is PhoneAuthCredential) {
      // Verify the phone number and link
      final authResult = await signInWithPhoneNumber(
          credential.verificationId, credential.smsCode as ApplicationVerifier);
      return firebaseLinkWithCredentailsUser.linkCredential(
          currentUser, currentUser.idToken);
    } else if (credential is OAuthCredential) {
      // Sign in with OAuth and link
      final authResult =
          await signInWithPopup(credential.providerId as AuthProvider);
      return firebaseLinkWithCredentailsUser.linkCredential(
          currentUser, currentUser.idToken);
    } else {
      throw FirebaseAuthException(
        code: 'unsupported-credential',
        message: 'Unsupported credential type',
      );
    }
  }

  ///////////a Firebase action code URL
  Future<dynamic> parseActionCodeUrl(String url) async {
    Uri uri = Uri.parse(url);

    if (uri.queryParameters.isEmpty) {
      return null;
    }

    // Extract query parameters
    String? mode = uri.queryParameters['mode'];
    String? oobCode = uri.queryParameters['oobCode'];
    String? continueUrl = uri.queryParameters['continueUrl'];
    String? lang = uri.queryParameters['lang'];

    if (mode == null || oobCode == null) {
      return null;
    }

    // Return the parsed parameters as a map
    return {
      'mode': mode,
      'oobCode': oobCode,
      'continueUrl': continueUrl ?? '',
      'lang': lang ?? '',
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

  Future<UserCredential?> getRedirectResult() async {
    try {
      return await getRedirectResultService.getRedirectResult();
    } catch (e) {
      print('Get redirect result failed: $e');
      throw FirebaseAuthException(
        code: 'get-redirect-result-error',
        message: 'Failed to get redirect result.',
      );
    }
  }

  Future<void> initializeRecaptchaConfig(String siteKey) async {
    try {
      await recaptchaConfigService.initializeRecaptchaConfig(siteKey);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'recaptcha-config-error',
        message: 'Failed to initialize reCAPTCHA config: ${e.toString()}',
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

  Future<void> confirmPasswordReset(String oobCode, String newPassword) async {
    try {
      await confirmPasswordResetService.confirmPasswordReset(
          oobCode, newPassword);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'confirm-password-reset-error',
        message: 'Failed to confirm password reset: ${e.toString()}',
      );
    }
  }

  Future<ActionCodeInfo> checkActionCode(String code) async {
    try {
      return await checkActionCodeService.checkActionCode(code);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'check-action-code-error',
        message: 'Failed to check action code: ${e.toString()}',
      );
    }
  }

  Future<multi_factor.MultiFactorResolver> getMultiFactorResolver(
      multi_factor.MultiFactorError error) async {
    try {
      return await multiFactorService.getMultiFactorResolver(error);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'multi-factor-resolver-error',
        message: 'Failed to get multi-factor resolver: ${e.toString()}',
      );
    }
  }
}
