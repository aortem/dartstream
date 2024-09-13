import 'package:ds_custom_middleware/src/query_string/ds_query_string_handler.dart';
import 'package:ds_custom_middleware/src/model/ds_request_model.dart';

String testQueryString() {
  final request = DsCustomMiddleWareRequest(
    'GET',
    Uri.parse('/test?name=John&age=30&hobbies=reading&hobbies=swimming'),
    {},
    null,
  );

  final allParams = DsQueryStringHandler.getAll(request);
  final name = DsQueryStringHandler.getValue(request, 'name');
  final age = DsQueryStringHandler.getValue(request, 'age');
  final hobbies = DsQueryStringHandler.getValues(request, 'hobbies');
  final hasEmail = DsQueryStringHandler.hasKey(request, 'email');

  return 'All parameters: $allParams\n'
      'Name: $name\n'
      'Age: $age\n'
      'Hobbies: $hobbies\n'
      'Has email: $hasEmail';
}
