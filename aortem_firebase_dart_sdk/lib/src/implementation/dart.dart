import 'package:aortem_firebase_dart_sdk/auth.dart';
import 'package:aortem_firebase_dart_sdk/core.dart';
// import 'package:aortem_firebase_dart_sdk/database.dart';
import 'package:aortem_firebase_dart_sdk/implementation/pure_dart.dart';
import 'package:aortem_firebase_dart_sdk/src/auth/app_verifier.dart';
import 'package:aortem_firebase_dart_sdk/src/auth/impl/auth.dart';
import 'package:aortem_firebase_dart_sdk/src/auth/sms_retriever.dart';
import 'package:aortem_firebase_dart_sdk/src/core/impl/app.dart';
// import 'package:aortem_firebase_dart_sdk/src/database/impl/firebase_impl.dart';
// import 'package:aortem_firebase_dart_sdk/src/storage.dart';
// import 'package:aortem_firebase_dart_sdk/src/storage/service.dart';
import 'package:http/http.dart' as http;

import '../implementation.dart';

class PureDartFirebaseImplementation extends BaseFirebaseImplementation {
  final http.Client? _httpClient;

  final AuthHandler authHandler;

  final ApplicationVerifier applicationVerifier;

  final SmsRetriever smsRetriever;

  PureDartFirebaseImplementation(
      {required Function(Uri url, {bool popup}) launchUrl,
      required this.authHandler,
      required this.applicationVerifier,
      required this.smsRetriever,
      http.Client? httpClient})
      : _httpClient = httpClient,
        super(launchUrl: launchUrl);

  static PureDartFirebaseImplementation get installation =>
      FirebaseImplementation.installation as PureDartFirebaseImplementation;
  // @override
  // FirebaseDatabase createDatabase(FirebaseApp app, {String? databaseURL}) {
  //   return FirebaseService.findService<FirebaseDatabaseImpl>(
  //           app,
  //           (s) =>
  //               s.databaseURL ==
  //               BaseFirebaseDatabase.normalizeUrl(
  //                   databaseURL ?? app.options.databaseURL)) ??
  //       FirebaseDatabaseImpl(app: app, databaseURL: databaseURL);
  // }

  @override
  Future<FirebaseApp> createApp(String name, FirebaseOptions options) async {
    return FirebaseAppImpl(name, options);
  }

  @override
  FirebaseAuth createAuth(FirebaseApp app) {
    return FirebaseService.findService<FirebaseAuthImpl>(app) ??
        FirebaseAuthImpl(app, httpClient: _httpClient);
  }

  // @override
  // FirebaseStorage createStorage(FirebaseApp app, {String? storageBucket}) {
  //   return FirebaseService.findService<FirebaseStorageImpl>(app,
  //           (s) => s.bucket == (storageBucket ?? app.options.storageBucket)) ??
  //       FirebaseStorageImpl(app, storageBucket, httpClient: _httpClient);
  // }
}
