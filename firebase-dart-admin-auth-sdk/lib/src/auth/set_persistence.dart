import '../../firebase_dart_admin_auth_sdk.dart';

class SetPresistence {
  final FirebaseAuth auth;
  SetPresistence({required this.auth});

  Future<void> setPersistence(String persistenceType) async {
    final response = await auth.performRequest(
      'setPersistence',
      {
        'persistence': persistenceType,
      },
    );

    if (response.statusCode == 200) {
      print('Persistence set to $persistenceType');
    } else {
      print('Failed to set persistence: ${response.body}');
    }
  }
}
