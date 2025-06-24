import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';

/// Implementation for obtaining an access token using a JWT.
///
/// This class extends [GetAccessTokenWithGeneratedToken] and implements the
/// method to retrieve an OAuth2 access token from the Google OAuth2 endpoint
/// by sending a JWT (JSON Web Token) for verification and exchange.
class GetAccessTokenWithGeneratedTokenImplementation
    extends GetAccessTokenWithGeneratedToken {
  /// Retrieves an access token using a provided JWT.
  ///
  /// This method exchanges the provided JWT for an access token from the
  /// Google OAuth2 service. It sends a POST request to the OAuth2 endpoint
  /// with the JWT in the body to get the access token.
  ///
  /// Parameters:
  /// - [jwt]: The JWT to be used for obtaining the access token.
  ///
  /// Returns:
  /// - A [Future] that resolves to the access token string if the request is successful.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if the request fails or if the response is not successful.
  @override
  Future<String> getAccessTokenWithGeneratedToken(
    String jwt, {
    String? targetServiceAccountEmail,
  }) async {
    try {
      // Create an HTTP client to make the request
      http.Client client = http.Client();

      // Sending the POST request to OAuth2 endpoint with JWT assertion
      final response = await client.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
          'assertion': jwt,
        },
      );

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['access_token']; // Return the access token from the response
      } else {
        // If the response status is not 200, throw an error
        throw Exception('Failed to obtain access token');
      }
    } catch (e) {
      // Catch any error and throw FirebaseAuthException with a message
      throw FirebaseAuthException(
        code: 'get-access-token-with-generated-token-failed',
        message: 'Failed to get access token with generated token',
      );
    }
  }
}

/// Implementation for obtaining an access token using a JWT.
///
/// This class extends [GetAccessTokenWithGeneratedToken] and implements the
/// method to retrieve an OAuth2 access token from the Google OAuth2 endpoint
/// by sending a JWT (JSON Web Token) for verification and exchange.
class GetAccessTokenWithGcpTokenImplementation
    extends GetAccessTokenWithGeneratedToken {
  /// Retrieves an access token using a provided JWT.
  ///
  /// This method exchanges the provided JWT for an access token from the
  /// Google OAuth2 service. It sends a POST request to the OAuth2 endpoint
  /// with the JWT in the body to get the access token.
  ///
  /// Parameters:
  /// - [gcpAccessToken]: The JWT to be used for obtaining the access token.
  ///
  /// Returns:
  /// - A [Future] that resolves to the access token string if the request is successful.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if the request fails or if the response is not successful.
  @override
  Future<String> getAccessTokenWithGeneratedToken(
    String gcpAccessToken, {
    String? targetServiceAccountEmail,
  }) async {
    try {
      // Create an HTTP client to make the request
      http.Client client = http.Client();

      // Sending the POST request to OAuth2 endpoint with JWT assertion
      final response = await client.post(
        Uri.parse(
          'https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/$targetServiceAccountEmail:generateAccessToken',
        ),
        headers: {
          'Authorization': 'Bearer $gcpAccessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'scope': ['https://www.googleapis.com/auth/firebase'],
        }),
      );

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        return responseData['accessToken']; // Return the access token from the response
      } else {
        // If the response status is not 200, throw an error
        throw Exception('Failed to obtain access token');
      }
    } catch (e) {
      // Catch any error and throw FirebaseAuthException with a message
      throw FirebaseAuthException(
        code: 'get-access-token-with-generated-token-failed',
        message: 'Failed to get access token with generated token',
      );
    }
  }
}

/// Abstract class defining the method to retrieve an access token using a JWT.
///
/// This class outlines the method required for exchanging a JWT for an access token,
/// allowing for different implementations of this functionality.
abstract class GetAccessTokenWithGeneratedToken {
  /// Retrieves an access token using a JWT.
  ///
  /// This method is designed to be implemented by a class that provides the
  /// specific logic for obtaining an access token using a JWT.
  ///
  /// Parameters:
  /// - [jwt]: The JWT to be used for obtaining the access token.
  ///
  /// Returns:
  /// - A [Future] that resolves to the access token string if the request is successful.
  Future<String> getAccessTokenWithGeneratedToken(
    String jwt, {
    String? targetServiceAccountEmail,
  });
}
