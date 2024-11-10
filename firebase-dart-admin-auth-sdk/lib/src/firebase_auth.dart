// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_user/link_with_credentails.dart';

import 'auth/auth_redirect_link.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/src/auth/generate_custom_token.dart';
import 'package:firebase_dart_admin_auth_sdk/src/service_account.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/apply_action_code.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/email_password_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/custom_token_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/email_link_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/get_additional_user_info.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/link_provider_to_user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/phone_auth.dart';

import 'package:firebase_dart_admin_auth_sdk/src/auth/reload_user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/send_email_verification_code.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/set_language_code.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/sign_out_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/oauth_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/unlink_provider.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/update_current_user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/update_password.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/update_profile.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/user_device_language.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/verify_before_email_update.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/verify_password_reset_code.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_app.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth_credential.dart';

// New imports for Sprint 2 #16 to #21
import 'package:firebase_dart_admin_auth_sdk/src/auth/password_reset_email.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/revoke_access_token.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/id_token_changed.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/auth_state_changed.dart';
import 'package:firebase_dart_admin_auth_sdk/src/utils.dart';

import 'auth/before_auth_state_change.dart';
import 'auth/set_persistence.dart';
import 'auth/sign_in_anonymously.dart';
import 'firebase_user/get_language_code.dart';
import 'auth/auth_link_with_phone_number.dart';

import 'firebase_user/delete_user.dart';

import 'auth/parse_action_code_url.dart';

import 'firebase_user/set_language_code.dart';
import 'id_token_result_model.dart';

///Base Firebase auth class that contains all the methods provided by the sdk
class FirebaseAuth {
  /// The API key for the Firebase project.
  ///
  /// This key is used to authenticate requests to Firebase services. It is
  /// required for making calls to Firebase Authentication and other Firebase
  /// REST APIs to interact with the Firebase backend.
  ///
  /// Example: "AIzaSyD-XXXXXXXXXXXXXXXXXXXXXXX"
  final String? apiKey;

  /// The project ID for your Firebase project.
  ///
  /// This is the unique identifier for your Firebase project. It is used in
  /// various Firebase operations and API calls to identify which project the
  /// operation should apply to.
  ///
  /// Example: "my-firebase-project"
  final String? projectId;
  final String? accessToken;
  final ServiceAccount? serviceAccount;
  final GenerateCustomToken? generateCustomToken;

  late http.Client httpClient;
  ///Projects bucket name
  /// The name of the Firebase Storage bucket associated with the project.
  ///
  /// This property holds the name of the Firebase Storage bucket that is
  /// associated with the Firebase project. It is used for performing
  /// file storage and retrieval operations within Firebase Storage.
  ///
  /// The bucket name typically follows the format:
  /// - "your-project-id.appspot.com"
  ///
  /// Example: "my-firebase-project.appspot.com"
  final String? bucketName;
  late EmailPasswordAuth emailPassword;
  late CustomTokenAuth customToken;
  late EmailLinkAuth emailLink;
  late PhoneAuth phone;
  late OAuthAuth oauth;

  /// An instance of the [FirebaseSignOut] service responsible for signing out the current user.
  ///
  /// This service provides the functionality to log the user out of the Firebase application,
  /// effectively ending their session and removing the current user information.
  late FirebaseSignOut signOUt;

  /// An instance of the [SignInWithRedirectService] service for handling sign-in using a redirect flow.
  ///
  /// This service facilitates signing in a user through a redirect process with a specific provider
  /// (such as Google, Facebook, etc.), where the user is redirected to the provider's authentication page.
  late SignInWithRedirectService signInRedirect;

  /// An instance of the [UpdateCurrentUser] service to update user data.
  ///
  /// This service allows you to update the details of the currently authenticated user, such as
  /// their profile information, preferences, or settings. It interacts with Firebase Authentication
  /// to apply the changes.
  late UpdateCurrentUser updateUserService;

  /// An instance of the [UseDeviceLanguageService] that manages the device's language setting for the user.
  ///
  /// This service retrieves and uses the device's default language setting to update the user's language
  /// preferences in the Firebase application. This can help personalize the app's interface based on the
  /// user's locale and language preferences.
  late UseDeviceLanguageService useDeviceLanguage;

  /// An instance of the [VerifyPasswordResetCodeService] responsible for verifying a password reset code.
  ///
  /// This service is used to verify the code sent to the user for resetting their password. It interacts with
  /// Firebase Authentication to ensure that the password reset process is valid before the user proceeds to set a new password.
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
  /// An instance of the [FirebasePhoneNumberLink] service that handles phone number linking in Firebase.
  ///
  /// This service allows users to link their phone numbers to their Firebase accounts, typically
  /// as part of the sign-in or user management process. It handles sending verification codes and
  /// linking the phone number to the user's account.
  late FirebasePhoneNumberLink firebasePhoneNumberLink;

  /// An instance of the [FirebaseParseUrlLink] service for parsing Firebase Dynamic Links.
  ///
  /// This service parses a Firebase Dynamic Link URL to retrieve the data it contains, such as
  /// information about the deep link destination or user-specific data embedded within the link.
  late FirebaseParseUrlLink firebaseParseUrlLink;

  /// An instance of the [FirebaseDeleteUser] service responsible for deleting a user from Firebase.
  ///
  /// This service allows you to delete a user from Firebase Authentication, permanently removing
  /// the user's account and associated data from Firebase services. This operation is typically
  /// used for account deletion requests initiated by the user or an administrator.
  late FirebaseDeleteUser firebaseDeleteUser;

  /// An instance of the [FirebaseLinkWithCredentailsUser] service for linking a user with credentials.
  ///
  /// This service enables you to link an existing Firebase user account with additional credentials,
  /// such as a third-party authentication provider (e.g., Google, Facebook). It allows a user to sign
  /// in with multiple authentication methods while maintaining a single account.
  late LinkWithCredientialClass firebaseLinkWithCredentialsUser;

  late GetAdditionalUserInfo _getAdditionalUserInfo;
  late LinkProviderToUser _linkProviderToUser;
  late UpdateProfile _updateProfile;
  late VerifyBeforeEmailUpdate _verifyBeforeEmailUpdate;

////Ticketr 5,7,23,24,61
  /// An instance of the [FirebaseSignInAnonymously] service for signing in users anonymously.
  ///
  /// This service handles signing in users without requiring them to provide credentials,
  /// such as email or password. It allows users to access the Firebase app anonymously and
  /// is often used for scenarios where the user should be authenticated temporarily or
  /// without creating a full account.
  late FirebaseSignInAnonymously signInAnonymously;

  /// An instance of the [PersistenceService] responsible for managing the persistence setting for users.
  ///
  /// This service allows you to set how the user's authentication state is persisted, such as
  /// whether the session should persist across app restarts or if it should only last for the
  /// duration of the session. This can be useful for controlling user session behavior in your app.
  late PersistenceService setPresistence;

  /// An instance of the [LanguageService] used to set the language code for the user.
  ///
  /// This service provides functionality to update the language preference for the user within
  /// Firebase. It allows users to specify their preferred language for app interfaces or communication.
  late LanguageService setLanguageService;

  /// An instance of the [LanguagGetService] for retrieving the current language preference.
  ///
  /// This service allows you to fetch the current language preference set for the user, typically
  /// from Firebase, to ensure the app is presented in the user's preferred language.
  late LanguageGetService getLanguageService;

  /// An instance of the [FirebaseBeforeAuthStateChangeService] that listens for authentication state changes.
  ///
  /// This service is used to intercept and handle actions before the authentication state is updated.
  /// It can be useful for logging, tracking, or performing custom actions before changes to the user's auth state.
  late FirebaseBeforeAuthStateChangeService firebaseBeforeAuthStateChangeService;

  /// The current authenticated Firebase user.
  ///
  /// This field holds the current user who is authenticated with Firebase. It can be accessed
  /// to retrieve information about the logged-in user, such as their user ID, email, and other profile data.
  late User? currentUser;

  /// StreamControllers for managing auth state and ID token change events
  final StreamController<User?> authStateChangedController =
      StreamController<User?>.broadcast();
  final StreamController<User?> idTokenChangedController =
      StreamController<User?>.broadcast();

  /// Constructor for initializing a [FirebaseAuth] instance with the specified parameters.
  ///
  /// Parameters:
  /// - [apiKey]: The API key for the Firebase project, required for making requests.
  /// - [projectId]: The project ID, used to identify your Firebase project.
 /// - [bucketName]: The Firebase Storage bucket name, used for uploading and downloading files.

  FirebaseAuth({
    this.apiKey,
    this.projectId,
    http.Client? httpClient, // Add this parameter
    this.bucketName,
    this.accessToken,
    this.serviceAccount,
    this.generateCustomToken,
  }) {
    this.httpClient = httpClient ??
        http.Client(); // Use the injected client or default to a new one
    emailPassword = EmailPasswordAuth(this);
    customToken = CustomTokenAuth(this);
    emailLink = EmailLinkAuth(this);
    phone = PhoneAuth(this);
    oauth = OAuthAuth(this);
    /// A service to handle user sign-out actions.
    ///
    /// This service is responsible for signing out the current user from the Firebase Authentication system,
    /// clearing any local session data, and updating the user state across the application.
    late FirebaseSignOut signOUt;

    /// A service for signing in a user via a redirect flow.
    ///
    /// This service is used when a user needs to sign in via an external authentication provider (e.g., Google,
    /// Facebook) using a redirect-based flow. It handles the logic of redirecting the user to the provider's
    /// authentication page and processing the result after the user completes the sign-in.
    late SignInWithRedirectService signInRedirect;

    /// A service for updating the current user's data.
    ///
    /// This service is responsible for updating the user's profile or authentication data in Firebase.
    /// It takes the user's ID token and any updated data to send to Firebase to ensure the user's record is updated.
    late UpdateCurrentUser updateUserService;

    /// A service for retrieving and setting the device language of the user.
    ///
    /// This service allows the application to use the language preference set on the user's device.
    /// It can be used to automatically adjust the language settings in Firebase or other parts of the app.
    late UseDeviceLanguageService useDeviceLanguage;

    /// A service for verifying a password reset code.
    ///
    /// This service verifies the validity of a password reset code. Typically used as part of the password reset
    /// process, it ensures the provided reset code is valid before proceeding with changing the user's password.
    late VerifyPasswordResetCodeService verifyPasswordReset;

    /// A service for applying an action code to complete an operation like password reset, email verification, etc.
    ///
    /// This service applies an action code (such as a password reset code or email verification link) to the user's
    /// account, confirming and finalizing the operation.
    late ApplyActionCode applyAction;

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

    /// A service for linking a phone number to a Firebase user account.
    ///
    /// This service allows linking a user's phone number with their Firebase account.
    /// It handles the process of sending a verification code to the user's phone number,
    /// and once verified, links the phone number to the existing Firebase user account.
    late FirebasePhoneNumberLink firebasePhoneNumberLink;

    /// A service for parsing Firebase URL links.
    ///
    /// This service handles the parsing of Firebase dynamic links or authentication-related URLs.
    /// It helps determine the action to take based on the Firebase link (e.g., resetting a password, verifying an email).
    late FirebaseParseUrlLink firebaseParseUrlLink;

    /// A service for deleting a Firebase user.
    ///
    /// This service allows you to delete a Firebase user account.
    /// It handles the removal of the user's data from Firebase Authentication and any associated resources.
    late FirebaseDeleteUser firebaseDeleteUser;

    /// A service for linking a user with credentials.
    ///
    /// This service allows linking an external provider's credentials (e.g., Google, Facebook) to an existing Firebase user.
    /// It facilitates combining multiple sign-in methods into a single Firebase user account for seamless user experience.
    firebaseLinkWithCredentialsUser = LinkWithCredientialClass(auth: this);

    _getAdditionalUserInfo = GetAdditionalUserInfo(auth: this);
    _linkProviderToUser = LinkProviderToUser(auth: this);
    _updateProfile = UpdateProfile(this);
    _verifyBeforeEmailUpdate = VerifyBeforeEmailUpdate(this);
    /// A service that allows signing in anonymously to Firebase.
    ///
    /// This service provides a method for users to authenticate with Firebase anonymously,
    /// meaning they can access Firebase services without needing to sign up or log in with credentials.
    late FirebaseSignInAnonymously signInAnonymously;

    /// A service for setting the persistence type for the user's authentication session.
    ///
    /// This service allows you to set how long the authentication state should persist across sessions.
    /// It updates the persistence settings for the Firebase user (e.g., session-based or persistent).
    late PersistenceService setPresistence;

    /// A service for setting the language code for the Firebase user.
    ///
    /// This service allows updating the preferred language for the user in Firebase Authentication.
    /// The language code will be used for any communications or authentication messages sent to the user.
    late LanguageService setLanguageService;

    /// A service for retrieving the language code of the Firebase user.
    ///
    /// This service retrieves the current language code set for the user in Firebase Authentication.
    /// It is used to fetch the language preferences of the user, enabling localized experiences in the app.
    late LanguageGetService getLanguageService;
    firebaseBeforeAuthStateChangeService =
        FirebaseBeforeAuthStateChangeService(this);
  }
  /// A method that performs an HTTP request to the Firebase Authentication REST API.
  ///
  /// This method sends a POST request to the Firebase Authentication API's specified endpoint
  /// using the provided request body and API key. It also includes optional authorization via
  /// an access token and ensures the request body is properly formatted in JSON.
  ///
  /// **Parameters**:
  /// - [endpoint]: The specific API endpoint to hit (e.g., `signUp`, `signInWithPassword`, etc.).
  /// - [body]: A `Map<String, dynamic>` containing the body of the request. This is the payload
  ///   that will be sent to the API.
  ///
  /// **Returns**:
  /// - A [HttpResponse] object containing the status code and the response body as a decoded JSON map.
  ///
  /// **Throws**:
  /// - [FirebaseAuthException] if the API returns an error (non-200 status code).
  ///   The exception will include the error code and message from Firebase.
  Future<HttpResponse> performRequest(
      String endpoint, Map<String, dynamic> body) async {
    // Construct the URL for the Firebase Authentication endpoint
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:$endpoint',
      {
        'key': apiKey, // Append the API key to the URL for authentication
      },
    );

    // Send the HTTP POST request with the necessary headers and body
    final response = await httpClient.post(url, body: json.encode(body), headers: {
      if (accessToken != null) 'Authorization': 'Bearer $accessToken', // Include the access token if provided
      'Content-Type': 'application/json', // Set content type to JSON
    });

    // If the response status code is not 200 (successful), throw an exception
    if (response.statusCode != 200) {
      final error = json.decode(response.body)['error'];
      log("error is $error ");
      throw FirebaseAuthException(
        code: error['message'], // Firebase error code
        message: error['message'], // Firebase error message
      );
    }

    // If the request was successful, return the response body in a HttpResponse object
    return HttpResponse(
      statusCode: response.statusCode,
      body: json.decode(response.body), // Decode the JSON response body
    );
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

  Future<UserCredential> signInWithCustomToken(String? uid) async {
    assert(serviceAccount != null, 'Service Account cannot be null');
    assert(generateCustomToken != null, 'Custom token cannot be null');

    String token =
        await generateCustomToken!.generateSignInJwt(serviceAccount!, uid: uid);
    return customToken.signInWithCustomToken(token);
  }

  Future<UserCredential?> signInWithCredential(
      AuthCredential credential) async {
    if (credential is EmailAuthCredential) {
      return signInWithEmailAndPassword(credential.email, credential.password);
    } else if (credential is PhoneAuthCredential) {
      return signInWithPhoneNumber(
          credential.verificationId, credential.smsCode);
    } else if (credential is OAuthCredential) {
      return signInWithPopup(
        credential.providerId,
      );
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

  /// Signs out the current user.
  ///
  /// This method checks if a user is currently signed in by looking at the
  /// current user in the Firebase app instance. If no user is signed in,
  /// it throws a `FirebaseAuthException`. If a user is signed in, it calls
  /// the `signOut` method to log the user out, updates the current user
  /// state in the app, and logs the sign-out action.
  ///
  /// **Throws**:
  /// - [FirebaseAuthException]: If no user is signed in or the sign-out fails.
  Future<void> signOut() async {

    // Check if there's a current user signed in
    if (FirebaseApp.instance.getCurrentUser() == null) {
      throw FirebaseAuthException(
        code: 'user-not-signed-in',
        message: 'No user is currently signed in.',
      );
    }

    try {
      // Attempt to sign out the user
      await signOUt.signOut();
      FirebaseApp.instance.setCurrentUser(null);
      currentUser = null;
      log('User Signout');
      return;
    } catch (e) {
      // Log any error and throw an exception
      log('Sign-out failed: $e');
      throw FirebaseAuthException(
        code: 'sign-out-error',
        message: 'Failed to sign out user.',
      );
    }
  }

  /// Signs in a user with a redirect to a third-party provider.
  ///
  /// This method redirects the user to a third-party authentication provider
  /// (e.g., Google, Facebook) using the provided `redirectUri` and `providerId`.
  /// It then attempts to sign the user in using the provided `idToken` and
  /// `providerId`. If the sign-in is successful, it returns a `UserCredential`
  /// object; otherwise, it throws a `FirebaseAuthException`.
  ///
  /// **Parameters**:
  /// - [redirectUri]: The URI to redirect the user to after signing in with the provider.
  /// - [idToken]: The ID token to authenticate the user.
  /// - [providerId]: The ID of the third-party provider to authenticate with.
  ///
  /// **Returns**:
  /// - A [UserCredential] object if sign-in is successful.
  ///
  /// **Throws**:
  /// - [FirebaseAuthException]: If the sign-in with redirect fails.
  Future<UserCredential?> signInWithRedirect(
      String redirectUri, String idToken, String providerId) async {
    try {
      return await signInRedirect.signInWithRedirect(
        redirectUri,
        idToken,
        providerId,
      );
    } catch (e) {
      print('Sign-in with redirect failed: $e');
      throw FirebaseAuthException(
        code: 'sign-in-redirect-error',
        message: 'Failed to sign in with redirect.',
      );
    }
  }

  /// Updates the information of a user in Firebase.
  ///
  /// This method updates the information of the user with the given `userId`
  /// by passing the provided `userData` (such as name, email, etc.) to the
  /// `updateUserService.updateCurrentUser()` method. It requires the user's
  /// `idToken` for authentication. If the update is successful, no further
  /// action is required; otherwise, it throws a `FirebaseAuthException`.
  ///
  /// **Parameters**:
  /// - [userId]: The ID of the user whose information is to be updated.
  /// - [idToken]: The ID token used to authenticate the request.
  /// - [userData]: A map containing the data to be updated (e.g., name, email).
  ///
  /// **Throws**:
  /// - [FirebaseAuthException]: If the update operation fails.
  Future<void> updateUserInformation(
      String userId, String idToken, Map<String, dynamic> userData) async {
    try {
      // Update the current user's information
      await updateUserService.updateCurrentUser(userId, idToken, userData);
    } catch (e) {
      print('Update current user information failed: $e');
      // Throw an exception if the update fails
      throw FirebaseAuthException(
        code: 'update-current-user-error',
        message: 'Failed to update current user information.',
      );
    }
  }

  /// Sets the device language for the current user.
  ///
  /// This method allows the user to set the language for the device, such as
  /// 'en' for English or 'es' for Spanish. The current user's `idToken` is
  /// used for authentication and authorization when setting the language.
  ///
  /// **Parameters**:
  /// - [languageCode]: The language code to set (e.g., 'en' for English).
  ///
  /// **Throws**:
  /// - [FirebaseAuthException]: If setting the device language fails.
  Future<void> deviceLanguage(String languageCode) async {
    try {
      // Set the device language for the current user
      await useDeviceLanguage.useDeviceLanguage(
          currentUser!.idToken!, languageCode);
    } catch (e) {
      print('Use device language failed: $e');
      // Throw an exception if setting the device language fails
      throw FirebaseAuthException(
        code: 'use-device-language-error',
        message: 'Failed to set device language.',
      );
    }
  }

  /// Verifies the password reset code provided by the user.
  ///
  /// This method is used to verify a password reset code sent to the user (e.g.,
  /// via email). The provided `code` is passed to the backend for verification.
  /// If successful, it returns an `HttpResponse` with the result. If the verification
  /// fails, a `FirebaseAuthException` is thrown.
  ///
  /// **Parameters**:
  /// - [code]: The password reset code that was sent to the user.
  ///
  /// **Returns**:
  /// - A [HttpResponse] containing the result of the verification request.
  ///
  /// **Throws**:
  /// - [FirebaseAuthException]: If the verification fails for any reason.
  Future<HttpResponse> verifyPasswordResetCode(String code) async {
    try {
      // Verify the password reset code
      return await verifyPasswordReset.verifyPasswordResetCode(code);
    } catch (e) {
      print('Verify password reset code failed: $e');
      // Throw an exception if the verification fails
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
  Future<void> sendSignInLinkToEmail(String email,
      {ActionCodeSettings? actionCode}) {
    return emailLink.sendSignInLinkToEmail(
      email,
      actionCode: actionCode,
    );
  }

  /// Links the user's account with external credentials.
  ///
  /// This method is used to link a user's account to an external provider (e.g., Google, Facebook, etc.)
  /// using the provided credentials (ID token and provider ID). It attempts to link the user's current account
  /// with the credentials from an external provider. If successful, the user will be linked to the provider.
  ///
  /// **Parameters**:
  /// - [redirectUri]: The URI to which the user will be redirected after a successful link.
  /// - [idToken]: The ID token obtained from the external provider that proves the user's identity.
  /// - [providerId]: The identifier for the external provider (e.g., 'google.com', 'facebook.com').
  ///
  /// **Returns**:
  /// - [UserCredential]: A future that resolves to a [UserCredential] object if the account linking is successful.
  ///   If the operation fails, it throws an exception.
  ///
  /// **Throws**:
  /// - [FirebaseAuthException]: If an error occurs while linking the account, an exception is thrown with a code
  ///   and message that describes the error.
  Future<UserCredential?> linkAccountWithCredentials(
      String redirectUri,
      String idToken,
      String providerId) async {
    try {
      return await firebaseLinkWithCredentialsUser.linkWithCrediential(
        redirectUri,
        idToken,
        providerId,
      );
    } catch (e) {
      print('Sign-in with redirect failed: $e');
      throw FirebaseAuthException(
        code: 'sign-in-redirect-error',
        message: 'Failed to sign in with redirect.',
      );
    }
  }


  Future<User> getAdditionalUserInfo() async {
    return await _getAdditionalUserInfo.getAdditionalUserInfo(
      currentUser?.idToken,
    );
  }

  Future<bool> linkProviderToUser(
    String providerId,
    String providerIdToken,
  ) async {
    return _linkProviderToUser.linkProviderToUser(
      currentUser?.idToken,
      providerId,
      providerIdToken,
    );
  }

  Future<User> updateProfile(
    String displayName,
    String displayImage,
  ) async {
    return await _updateProfile.updateProfile(
      displayName,
      displayImage,
      currentUser?.idToken,
    );
  }

  Future<bool> verifyBeforeEmailUpdate(
    String newEmail, {
    ActionCodeSettings? action,
  }) async {
    return await _verifyBeforeEmailUpdate.verifyBeforeEmailUpdate(
      currentUser?.idToken,
      newEmail,
      action: action,
    );
  }

  /// Parses a Firebase action code URL.
  ///
  /// This method parses the provided URL to extract query parameters such as
  /// `mode`, `oobCode`, `continueUrl`, and `lang`. These parameters are used
  /// in various Firebase actions like email verification, password reset, etc.
  /// The method returns a map with these parameters if they are valid, or `null`
  /// if the URL is not valid or the required parameters are missing.
  ///
  /// **Parameters**:
  /// - [url]: The Firebase action code URL to parse.
  ///
  /// **Returns**:
  /// - A [Map<String, String>] containing the parsed parameters (`mode`, `oobCode`,
  ///   `continueUrl`, and `lang`) if valid; otherwise, returns `null`.
  Future<dynamic> parseActionCodeUrl(String url) async {
    Uri uri = Uri.parse(url);

    // If the URL does not have query parameters, return null
    if (uri.queryParameters.isEmpty) {
      return null;
    }

    // Extract query parameters from the URL
    String? mode = uri.queryParameters['mode'];
    String? oobCode = uri.queryParameters['oobCode'];
    String? continueUrl = uri.queryParameters['continueUrl'];
    String? lang = uri.queryParameters['lang'];

    // If either mode or oobCode is missing, return null
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

  /// Links a phone number to the current Firebase user.
  ///
  /// This method allows a phone number to be linked to the current user account
  /// using the provided phone number and verification code. The phone number
  /// must be verified before it can be linked to the account.
  ///
  /// **Parameters**:
  /// - [phone]: The phone number to link to the current user's account.
  /// - [verificationCode]: The verification code sent to the user's phone.
  ///
  /// **Throws**:
  /// - [FirebaseAuthException]: If the phone number linking fails or the verification code is incorrect.
  Future<void> firebasePhoneNumberLinkMethod(
      String phone, String verificationCode) async {
    try {
      // Attempt to link the phone number to the user account
      await firebasePhoneNumberLink.linkPhoneNumber(
          currentUser!.idToken!, phone, verificationCode);
    } catch (e) {
      log("error is $e");
      // Throw an exception if linking the phone number fails
      throw FirebaseAuthException(
        code: 'verification-code-error',
        message:
        'Failed to send verification code to phone number: ${e.toString()}',
      );
    }
  }

  /// Deletes the current Firebase user.
  ///
  /// This method deletes the current authenticated user from Firebase. It first checks
  /// if a user is signed in, and if not, throws a `FirebaseAuthException`. If the user
  /// is signed in, it proceeds with the deletion process.
  ///
  /// **Throws**:
  /// - [FirebaseAuthException]: If no user is signed in or the deletion process fails.
  Future<void> deleteFirebaseUser() async {
    if (FirebaseApp.instance.getCurrentUser() == null && currentUser == null) {
      throw FirebaseAuthException(
        code: 'user-not-signed-in',
        message: 'No user is currently signed in.',
      );
    }

    try {
      // Attempt to delete the user from Firebase
      await firebaseDeleteUser.deleteUser(
          currentUser!.idToken!, currentUser!.uid);
      FirebaseApp.instance.setCurrentUser(null);
      log('User Deleted');
      return;
    } catch (e) {
      log('User Delete failed: $e');
      // Throw an exception if user deletion fails
      throw FirebaseAuthException(
        code: 'user-delete-error',
        message: 'Failed to delete user.',
      );
    }
  }

  /// Retrieves the ID token of the current authenticated user.
  ///
  /// This method returns the ID token associated with the current user, which can be used
  /// to authenticate subsequent requests to Firebase services.
  ///
  /// **Returns**:
  /// - The ID token for the current user, or `null` if no user is signed in.
  Future<String?> getIdToken() async {
    final user = currentUser;
    return await user?.getIdToken();
  }

  /// Retrieves the ID token result for the current authenticated user.
  ///
  /// This method returns detailed information about the user's ID token, including the
  /// token's expiration time and other metadata. If no user is signed in, it returns `null`.
  ///
  /// **Returns**:
  /// - An [IdTokenResult] containing metadata about the ID token, or `null` if no user is signed in.
  Future<IdTokenResult?> getIdTokenResult() async {
    final user = currentUser;
    return await user?.getIdTokenResult();
  }

  /// Signs in the user anonymously.
  ///
  /// This method attempts to sign in the user anonymously, meaning no username or password
  /// is required. It returns a `UserCredential` object if the sign-in is successful.
  ///
  /// **Returns**:
  /// - A [UserCredential] object if sign-in is successful.
  ///
  /// **Throws**:
  /// - [FirebaseAuthException]: If the anonymous sign-in fails.
  Future<UserCredential?> signInAnonymouslyMethod() async {
    try {
      return await signInAnonymously.signInAnonymously();
    } catch (e) {
      print('Sign-in anonymously failed: $e');
      throw FirebaseAuthException(
        code: 'sign-in-anonymously-error',
        message: 'Failed to sign in anonymously.',
      );
    }
  }

  /// Sets the persistence of the user's session.
  ///
  /// This method allows you to set the persistence type for the current user. The persistence
  /// can be `session` or `persistent`, depending on how you want the session to be maintained.
  ///
  /// **Parameters**:
  /// - [presistanceType]: The type of persistence to set (`'session'` or `'persistent'`).
  /// - [databaseName]: The name of the database where the persistence should be applied.
  ///
  /// **Throws**:
  /// - [FirebaseAuthException]: If setting the persistence fails.
  Future<void> setPresistanceMethod(
      String presistanceType, String databaseName) {
    try {
      return setPresistence.setPersistence(currentUser!.uid,
          currentUser!.idToken!, presistanceType, databaseName);
    } catch (e) {
      print('Failed Set Persistence: $e');
      throw FirebaseAuthException(
        code: 'set-persistence-error',
        message: 'Failed to set persistence.',
      );
    }
  }

  /// Sets the language code preference for the current user.
  ///
  /// This method updates the language preference for the current user in Firebase.
  ///
  /// **Parameters**:
  /// - [languageCode]: The language code to set (e.g., 'en' for English, 'es' for Spanish).
  /// - [databaseName]: The name of the database where the language preference should be stored.
  ///
  /// **Throws**:
  /// - [FirebaseAuthException]: If setting the language preference fails.
  Future<void> setLanguageCodeMethod(String languageCode, String dataBaseName) {
    try {
      return setLanguageService.setLanguagePreference(
          currentUser!.uid, currentUser!.idToken!, languageCode, dataBaseName);
    } catch (e) {
      print('Failed Set Language: $e');
      throw FirebaseAuthException(
        code: 'set-language-error',
        message: 'Failed to set language.',
      );
    }
  }

  /// Retrieves the language code preference for the current user.
  ///
  /// This method fetches the language preference set for the current user from Firebase.
  ///
  /// **Parameters**:
  /// - [databaseName]: The name of the database where the language preference is stored.
  ///
  /// **Throws**:
  /// - [FirebaseAuthException]: If fetching the language preference fails or the language is not set.
  Future<void> getLanguageCodeMethod(String databaseName) {
    try {
      return getLanguageService.getLanguagePreference(
          currentUser!.uid, currentUser!.idToken!, databaseName);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'get-language-error',
        message: 'No language is set.',
      );
    }
  }

  /// Retrieves the authentication state change before the user is authenticated.
  ///
  /// This method listens for changes in the authentication state before the user is authenticated
  /// and allows you to perform actions based on the current user's authentication state.
  ///
  /// **Throws**:
  /// - [FirebaseAuthException]: If the auth state change handling fails.
  Future<void> getAuthBeforeChange() {
    try {
      return firebaseBeforeAuthStateChangeService.beforeAuthStateChange(
        currentUser!.idToken!,
        currentUser!.refreshToken!,
      );
    } catch (e) {
      print('Failed Before Auth State Changed: $e');
      throw FirebaseAuthException(
        code: 'before-auth-state-changed-error',
        message: 'Failed to handle before auth state change.',
      );
    }
  }


  /// Disposes of the FirebaseAuth instance and releases resources.
  void dispose() {
    authStateChangedController.close();
    idTokenChangedController.close();
    httpClient.close();
  }
}
