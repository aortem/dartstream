import 'package:firebase_dart_admin_auth_sdk/src/service_account.dart';
import 'package:jwt_generator/jwt_generator.dart';
import 'package:firebase_dart_admin_auth_sdk/src/utils.dart';

abstract class GenerateCustomToken {
  static Future<String> generateCustomToken(
    FcmTokenDto fcmToken,
    String privateKey,
  ) async {
    // Creating an encoded and signed token

    // RsaKeyParser extracts private key from a pem string
    final parser = RsaKeyParser();
    final rsaPrivateKey = parser.extractPrivateKey(privateKey);

    // Create RsaSignifier for signing
    final rsaSignifier = RsaSignifier(privateKey: rsaPrivateKey);

    // JwtBuilder encodes the token to string and signs it
    final jwtBuilder = JwtBuilder(signifier: rsaSignifier);
    final jwtToken = jwtBuilder.buildToken(fcmToken);

    return jwtToken;
  }

  static Future<String> generateServiceAccountJwt(
      ServiceAccount serviceAccount) async {
    final String? iss = serviceAccount.clientEmail;
    final String scope =
        'https://www.googleapis.com/auth/firebase.database https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/identitytoolkit';
    final String aud = 'https://oauth2.googleapis.com/token';

    return await generateCustomToken(
      FcmTokenDto(
        iss: iss!,
        aud: aud,
        scope: scope,
      ),
      serviceAccount.privateKey!,
    );
  }

  static Future<String> generateSignInJwt(
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
        sub: iss,
        aud: aud,
        scope: scope,
        uid: uid ?? customUid,
        additionalClaims: additionalClaims,
      ),
      serviceAccount.privateKey!,
    );
  }
}
