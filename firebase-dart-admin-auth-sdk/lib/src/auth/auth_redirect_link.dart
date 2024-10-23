// import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
// import 'dart:html' as html;
// import 'dart:convert';
// import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

class SignInWithRedirectService {
  final FirebaseAuth auth;

  SignInWithRedirectService({required this.auth});
  Future<void> signInWithRedirect(String providerUrl) async {
    // Step 1: Create the OAuth sign-in URL
    // final oauthUrl =
    //     '$providerUrl?client_id=${auth.apiKey}&redirect_uri=""&response_type=token';

    // Step 2: Redirect the user to the OAuth provider's sign-in page
    // html.window.location.href = oauthUrl;
  }

  // Future<Map<String, dynamic>> handleRedirectResult() async {
  //   // Step 3: Handle the redirect result
  //   // final uri = Uri.parse(html.window.location.href);
  //   // final fragment = uri.fragment;
  //   // final params = Uri.splitQueryString(fragment);
  //   //
  //   // if (params.containsKey('access_token')) {
  //   //   final accessToken = params['access_token']!;
  //   //   return await _getUserInfo(accessToken);
  //   // } else {
  //   //   throw Exception('Authentication failed or was canceled');
  //   // }
  // }

  // Future<Map<String, dynamic>> _getUserInfo(String accessToken) async {
  //   // Step 4: Retrieve user information from the OAuth provider
  //   final response = await http.get(
  //     Uri.parse(
  //         'https://www.googleapis.com/oauth2/v1/userinfo?access_token=$accessToken'),
  //   );

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed to retrieve user information');
  //   }
  // }
}
