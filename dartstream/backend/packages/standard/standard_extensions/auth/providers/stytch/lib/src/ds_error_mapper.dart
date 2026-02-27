import 'package:ds_auth_base/ds_auth_base_export.dart';

class DSStytchErrorMapper {
  static DSAuthError map(dynamic e) {
    if (e is DSAuthError) return e;
    return DSAuthError(e.toString());
  }
}
