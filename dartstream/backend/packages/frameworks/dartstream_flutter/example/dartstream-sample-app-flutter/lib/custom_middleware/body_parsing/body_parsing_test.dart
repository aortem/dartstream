import 'package:ds_custom_middleware/src/body_parsing/ds_body_parser.dart';
import 'package:ds_custom_middleware/src/model/ds_request_model.dart';

Future<String> testBodyParsing() async {
  final jsonRequest = DsCustomMiddleWareRequest(
    'POST',
    Uri.parse('/test'),
    {'Content-Type': 'application/json'},
    '{"name": "John", "age": 30}',
  );

  final formDataRequest = DsCustomMiddleWareRequest(
    'POST',
    Uri.parse('/test'),
    {'Content-Type': 'application/x-www-form-urlencoded'},
    'name=John&age=30',
  );

  final jsonResult = await DsBodyParser.parse(jsonRequest);
  final formDataResult = await DsBodyParser.parse(formDataRequest);

  return 'JSON parsing result: $jsonResult\n'
      'Form data parsing result: $formDataResult';
}
