import 'package:ds_custom_middleware/app/parsers/ds_body_parser.dart';
import 'package:ds_custom_middleware/ds_custom_middleware.dart';

Future<String> testBodyParser() async {
  final bodyParser = DsBodyParser();
  final request = DsCustomMiddleWareRequest(
    'POST',
    Uri.parse('http://localhost:8080/api'),
    {'content-type': 'application/json'},
    '{"key": "value"}',
    {},
  );
  final parsedRequest = await bodyParser.addParsedBodyToRequest(request);
  return 'Body parsed: ${(parsedRequest.body as Map)['key']}';
}
