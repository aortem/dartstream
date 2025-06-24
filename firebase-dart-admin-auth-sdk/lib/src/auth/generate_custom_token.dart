import 'package:firebase_dart_admin_auth_sdk/src/service_account.dart';
import 'package:jwt_generator/jwt_generator.dart';
import 'package:firebase_dart_admin_auth_sdk/src/utils.dart';

/// Implementation for generating custom JWTs for Firebase Authentication.
///
/// This class provides methods for creating different types of JWTs,
/// including a standard custom token, a service account JWT, and a
/// sign-in JWT. It extends the [GenerateCustomToken] abstract class
/// to define the core methods required for generating these tokens.
class GenerateCustomTokenImplementation extends GenerateCustomToken {
  /// Generates a custom JWT based on the provided [FcmTokenDto] and [privateKey].
  ///
  /// Parameters:
  /// - [fcmToken]: The data transfer object containing token details.
  /// - [privateKey]: A string representing the private RSA key used to sign the token.
  ///
  /// Returns a [Future] that resolves to the signed JWT as a [String].
  @override
  Future<String> generateCustomToken(
    FcmTokenDto fcmToken,
    String privateKey,
  ) async {
    // RsaKeyParser extracts private key from a PEM string
    final parser = RsaKeyParser();
    final rsaPrivateKey = parser.extractPrivateKey(privateKey);

    // Create RsaSignifier for signing
    final rsaSignifier = RsaSignifier(privateKey: rsaPrivateKey);

    // JwtBuilder encodes the token to string and signs it
    final jwtBuilder = JwtBuilder(signifier: rsaSignifier);
    final jwtToken = jwtBuilder.buildToken(fcmToken);

    return jwtToken;
  }

  /// Generates a JWT for authenticating as a service account.
  ///
  /// Parameters:
  /// - [serviceAccount]: The [ServiceAccount] containing necessary account information.
  /// - [impersonatedEmail]: (Optional) The email to impersonate for the authentication.
  ///
  /// Returns a [Future] that resolves to the generated JWT string.
  @override
  Future<String> generateServiceAccountJwt(
    ServiceAccount serviceAccount, {
    String? impersonatedEmail,
  }) async {
    final String? iss = serviceAccount.clientEmail;
    final String scope =
        'https://www.googleapis.com/auth/firebase.database https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/identitytoolkit';
    final String aud = 'https://oauth2.googleapis.com/token';

    return await generateCustomToken(
      FcmTokenDto(iss: iss!, aud: aud, scope: scope, sub: impersonatedEmail),
      serviceAccount.privateKey!,
    );
  }

  /// Generates a sign-in JWT for a Firebase user.
  ///
  /// Parameters:
  /// - [serviceAccount]: The [ServiceAccount] for Firebase operations.
  /// - [uid]: (Optional) User ID to be embedded in the token.
  /// - [additionalClaims]: (Optional) Additional claims to be included in the JWT.
  ///
  /// Returns a [Future] that resolves to the JWT for signing in a Firebase user.
  ///
  /// If [uid] is not provided, a custom UID is generated.
  @override
  Future<String> generateSignInJwt(
    ServiceAccount serviceAccount, {
    String? uid,
    Map<String, dynamic>? additionalClaims,
  }) async {
    final String? iss = serviceAccount.clientEmail;
    final String scope =
        'https://www.googleapis.com/auth/firebase.database https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/identitytoolkit';
    final String aud =
        'https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit';

    String customUid = generateUid();

    return await generateCustomToken(
      FcmTokenDto(
        iss: iss!,
        aud: aud,
        scope: scope,
        uid: uid ?? customUid,
        additionalClaims: additionalClaims,
      ),
      serviceAccount.privateKey!,
    );
  }
}

/// Abstract class defining methods for generating custom tokens.
///
/// This class specifies the methods required for generating different types
/// of tokens, allowing for implementations that suit specific use cases.
abstract class GenerateCustomToken {
  /// Generates a custom JWT based on the provided [FcmTokenDto] and private key.
  Future<String> generateCustomToken(FcmTokenDto fcmToken, String privateKey);

  /// Generates a JWT for authenticating as a service account, with optional email impersonation.
  Future<String> generateServiceAccountJwt(
    ServiceAccount serviceAccount, {
    String? impersonatedEmail,
  });

  /// Generates a JWT for signing in a user, with optional UID and additional claims.
  Future<String> generateSignInJwt(
    ServiceAccount serviceAccount, {
    String? uid,
    Map<String, dynamic>? additionalClaims,
  });
}
