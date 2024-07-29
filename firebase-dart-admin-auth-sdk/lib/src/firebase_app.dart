import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'firebase_auth.dart';

class FirebaseApp {
  ///Instance of the Firebase App
  static FirebaseApp? _instance;
  //API key associated with the project
  final String? _apiKey;
  //The ID of the project
  final String? _projectId;

  static FirebaseAuth? firebaseAuth;

  FirebaseApp._(this._apiKey, this._projectId);

  //Exposes the singleton
  static FirebaseApp get instance {
    if (_instance == null) {
      throw ("FirebaseApp is not initialized. Please call initializeApp() first.");
    }
    return _instance!;
  }

  ///Used to initialize the project
  ///[apiKey] is the API Key associated with the project
  ///[projectId] is the ID of the project
  static Future<FirebaseApp> initializeAppWithEnvironmentVariables({
    required String apiKey,
    required String projectId,
  }) async {
    //Asserts that the API key and Project Id is not empty
    assert(apiKey.isNotEmpty, "API Key cannot be empty");
    assert(projectId.isNotEmpty, "Project ID Key cannott be empty");
    //Returns an intance of FirebaseApp if it exist or create a new instance based on the parameter passed
    return _instance ??= FirebaseApp._(apiKey, projectId);
  }

  static Future<FirebaseApp> initializeAppWithServiceAccount({
    required String serviceAccountContent,
    required String serviceAccountKeyFilePath,
  }) async {
    // Parse the JSON content
    final serviceAccount = json.decode(serviceAccountContent);

    // TODO: Implement API to get access token

    return _instance ??= FirebaseApp._(
      serviceAccount['private_key'], // Update with the actual key field
      serviceAccount['project_id'], // Update with the actual project ID field
    );
  }

  static Future<FirebaseApp> initializeAppWithServiceAccountImpersonation({
    required String serviceAccountEmail,
    required String userEmail,
  }) async {
    //Assert the values passed are not empty
    assert(serviceAccountEmail.isNotEmpty,
        "Service Account Email cannot be empty");
    assert(userEmail.isNotEmpty, "User email cannot be empty");

    //TODO: Implement API to get access token

    return _instance ??= FirebaseApp._(
      'your_api_key',
      'your_project_id',
    );
  }

  ///Returns a Firebase Auth instance associated with the Project
  ///Throws not initialized if Firebase app is not intialized
  FirebaseAuth getAuth() {
    assert(_apiKey != null, 'API Key is null');
    assert(_projectId != null, 'Project ID is null');
    if (_instance == null) {
      throw ("FirebaseApp is not initialized. Please call initializeApp() first.");
    }
    return firebaseAuth ??= FirebaseAuth(
      apiKey: _apiKey,
      projectId: _apiKey,
    );
  }
}
