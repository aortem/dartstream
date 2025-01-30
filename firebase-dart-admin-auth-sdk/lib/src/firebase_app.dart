import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'dart:io';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_storage.dart';
import 'package:firebase_dart_admin_auth_sdk/src/service_account.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';
import 'auth/generate_custom_token.dart';
import 'auth/get_access_token_with_generated_token.dart';

/// The base class to initialize the firebase dart admin sdk
class FirebaseApp {
  ///Instance of the Firebase App
  static FirebaseApp? _instance;
  //API key associated with the project
  final String? _apiKey;
  //The ID of the project
  final String? _projectId;
  //The authDomain of the project
  final String _authdomain;
  //The messagingSenderId of the project
  final String _messagingSenderId;
  final String? _bucketName;
  final String? _appId;
  final ServiceAccount? _serviceAccount;
  final String? _accessToken;

  ///The class to interact with the various firebase auth methods
  static FirebaseAuth? firebaseAuth;
  static GetAccessTokenWithGeneratedToken? _accesstokenGen;
  static GenerateCustomToken? _tokenGen;

  ///The class to interact with the various firebase storage methods
  static FirebaseStorage? firebaseStorage;

  FirebaseApp._(
      this._apiKey,
      this._projectId,
      this._authdomain,
      this._messagingSenderId,
      this._bucketName,
      this._appId,
      this._serviceAccount,
      this._accessToken);

  User? _currentUser;

  /// Method to set the current user
  void setCurrentUser(User? user) {
    _currentUser = user;
  }

  /// Method to get the current User
  User? getCurrentUser() {
    return _currentUser;
  }

  ///Exposed the firebase app singleton
  static FirebaseApp get instance {
    if (_instance == null) {
      throw ("FirebaseApp is not initialized. Please call initializeApp() first.");
    }
    return _instance!;
  }

  ///Used to initialize the project with enviroment variables
  ///[apiKey] is the API Key associated with the project
  ///[projectId] is the ID of the project
  static Future<FirebaseApp> initializeAppWithEnvironmentVariables({
    required String apiKey,
    required String authdomain,
    required String projectId,
    required String messagingSenderId,
    required String bucketName,
    required String appId,
  }) async {
    // Asserts that the API key, Project ID, and Bucket Name are not empty
    assert(apiKey.isNotEmpty, "API Key cannot be empty");
    assert(projectId.isNotEmpty, "Project ID cannot be empty");
    assert(bucketName.isNotEmpty, "Bucket Name cannot be empty");
    assert(authdomain.isNotEmpty, "Auth Domain cannot be empty");
    assert(messagingSenderId.isNotEmpty, "Messaging Sender ID cannot be empty");
    assert(appId.isNotEmpty, "App ID cannot be empty");

    // Returns an instance of FirebaseApp if it exists or create a new instance based on the parameters passed
    return _instance ??= FirebaseApp._(
      apiKey,
      projectId,
      authdomain,
      messagingSenderId,
      bucketName,
      appId,
      null,
      null,
    );
  }

  ///Used to initialize the project with service account
  ///[serviceAccountContent] is the encoded string of the service account
  static Future<FirebaseApp> initializeAppWithServiceAccount({
    required String serviceAccountContent,
  }) async {
    // Initialize token generators
    final tokenGen = _tokenGen ??= GenerateCustomTokenImplementation();
    final accesTokenGen =
        _accesstokenGen ??= GetAccessTokenWithGeneratedTokenImplementation();

    try {
      // Parse the JSON content
      final Map<String, dynamic> serviceAccount =
          json.decode(serviceAccountContent);

      // Create ServiceAccount model from JSON
      final ServiceAccount serviceAccountModel =
          ServiceAccount.fromJson(serviceAccount);

      // Generate JWT and access token
      final jwt = await tokenGen.generateServiceAccountJwt(serviceAccountModel);
      final accessToken =
          await accesTokenGen.getAccessTokenWithGeneratedToken(jwt);

      // Extract values with defaults for optional fields
      final projectId = serviceAccount['project_id'];
      final authDomain = serviceAccount['auth_domain'] ?? '';
      final messagingSenderId = serviceAccount['messaging_sender_id'] ?? '';
      final bucketName = serviceAccount['bucket_name'];
      final appId = serviceAccount['app_id'];

      // Validate required fields
      if (projectId == null) {
        throw FormatException('Missing project_id in service account JSON');
      }

      // Create and return Firebase instance
      return _instance ??= FirebaseApp._(
        null,
        projectId,
        authDomain,
        messagingSenderId,
        bucketName,
        appId,
        serviceAccountModel,
        accessToken,
      );
    } catch (e) {
      throw Exception('Failed to initialize Firebase with service account: $e');
    }
  }

  ///This is for unit testing purposes
  static void overrideInstanceForTesting(
    GetAccessTokenWithGeneratedToken tokenGen,
    GenerateCustomToken generateCustomToken,
  ) {
    _accesstokenGen = tokenGen;
    _tokenGen = generateCustomToken;
  }



 
 /// Generates an access token by impersonating a service account.
  ///
  /// This function:
  /// 1. Tries the GCP metadata server (if running on GCP).
  /// 2. Falls back to `gcloud` CLI if the GCP metadata server is unavailable.
  ///
  /// Returns:
  /// - `String` access token.
  /// Throws:
  /// - `Exception` if token generation fails.
  static Future<String> generateAccessToken(String serviceAccountEmail) async {
    try {
      // Step 1: Try GCP metadata server (if running on GCP)
      if (_isGcpEnvironment()) {
        print('🔹 Attempting to fetch token from GCP metadata server...');
        final response = await http.get(
          Uri.parse(
              'http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token'),
          headers: {'Metadata-Flavor': 'Google'},
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          return jsonResponse['access_token'];
        }
      }

      // Step 2: Fallback to `gcloud` CLI
      print('🔹 Falling back to `gcloud` CLI for token generation...');
      final process = await Process.run(
        'gcloud',
        [
          'auth',
          'print-access-token',
          '--impersonate-service-account=$serviceAccountEmail',
        ],
        runInShell: true, // Required for Windows
      );

      if (process.exitCode == 0) {
        return process.stdout.toString().trim();
      } else {
        throw Exception(
            '❌ `gcloud` CLI failed: ${process.stderr}\nMake sure `gcloud` is installed and configured.');
      }
    } catch (e) {
      print('❌ Error generating access token: $e');
      throw Exception('Failed to generate access token: $e');
    }
  }

  /// Checks if running in a GCP environment.
  static bool _isGcpEnvironment() {
    return Platform.environment.containsKey('GOOGLE_CLOUD_PROJECT');
  }

  /// Firebase Initialization using service account
  static Future<FirebaseApp> initializeAppWithServiceAccountWithOutImpersenation(
      String projectId, String serviceAccountEmail) async {
    try {
      // Step 1: Generate access token using service account
      String accessToken = await generateAccessToken(serviceAccountEmail);
      print('✅ Access token generated successfully.');

      return _instance ??= FirebaseApp._(
        'your_api_key',
        'your_project_id',
        'your_auth_domain',
        'your_messaging_sender_id',
        'your_bucket_name',
        'your_app_id',
        null,
        accessToken,
      );
      // Step 2: Initialize Firebase Admin SDK and get project information
    } catch (e) {
      print('🚨 Error initializing Firebase: $e');
      throw Exception('Firebase initialization failed: $e');
    }
  }

 

  //e Auth instance associated with the Project
  ///Throws not initialized if Firebase app is not intialized
  FirebaseAuth getAuth() {
    if (_accessToken == null) assert(_apiKey != null, 'API Key is null');
    assert(_projectId != null, 'Project ID is null');
    if (_instance == null) {
      throw ("FirebaseApp is not initialized. Please call initializeApp() first.");
    }
    return firebaseAuth ??= FirebaseAuth(
      apiKey: _apiKey,
      projectId: _projectId,
      authDomain: _authdomain,
      messagingSenderId: _messagingSenderId,
      bucketName: _bucketName,
      accessToken: _accessToken,
      serviceAccount: _serviceAccount,
      generateCustomToken: _tokenGen,
      appId: _appId,
    );
  }

  ///Used to get firebase storage
  ///[apiKey] is the API Key associated with the project
  ///[projectId] is the ID of the project
  FirebaseStorage getStorage() {
    assert(_apiKey != null, 'API Key is null');
    assert(_projectId != null, 'Project ID is null');
    if (_instance == null) {
      throw ("FirebaseApp is not initialized. Please call initializeApp() first.");
    }
    // Use the getStorage method to obtain a FirebaseStorage instance
    return firebaseStorage ??= FirebaseStorage.getStorage(
      apiKey: _apiKey!,
      projectId: _projectId!,
      bucketName: _bucketName!,
    );
  }
}
