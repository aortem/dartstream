library firebase_dart_admin_auth_sdk;

export 'src/firebase_auth.dart';
export 'src/user_credential.dart';
export 'src/exceptions.dart';
export 'src/utils.dart';
export 'src/confirmation_result.dart';
export 'src/auth_credential.dart';
export 'src/firebase_app.dart';
export 'src/auth_provider.dart';
export 'src/application_verifier.dart';
export 'src/user.dart';

// Conditional export for auth_link_with_phone_number.dart
export 'src/auth/auth_link_with_phone_number_stub.dart'
    if (dart.library.html) 'src/auth/auth_link_with_phone_number.dart';

export 'src/auth/auth_redirect_link_stub.dart'
    if (dart.library.html) 'src/auth/auth_redirect_link.dart';
export 'src/firebase_storage.dart';
