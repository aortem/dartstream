import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart';
import '../models/ds_custom_middleware_model.dart';

class DsBodyParser {
  Future<Map<String, dynamic>> parseBody(
      DsCustomMiddleWareRequest request) async {
    final contentType = request.headers['content-type'];
    final body = await utf8.decoder.bind(request.read()).join();

    if (contentType?.contains('application/json') == true) {
      return jsonDecode(body) as Map<String, dynamic>;
    } else if (contentType?.contains('application/x-www-form-urlencoded') ==
        true) {
      return Uri.splitQueryString(body);
    } else {
      return {'rawBody': body};
    }
  }

  Future<DsCustomMiddleWareRequest> addParsedBodyToRequest(
      DsCustomMiddleWareRequest request) async {
    final parsedBody = await parseBody(request);
    return request.copyWith(body: parsedBody);
  }
}
