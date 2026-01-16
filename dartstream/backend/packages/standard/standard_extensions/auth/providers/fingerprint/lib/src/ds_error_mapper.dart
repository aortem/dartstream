import 'package:ds_auth_base/ds_auth_base_export.dart';

class DSFingerprintErrorMapper {
  static DSAuthError mapError(dynamic error) {
    if (error is DSAuthError) {
      return error;
    }

    return DSAuthError(
      error.toString(),
      code: 500,
    );
  }
}
