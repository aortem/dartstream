import 'package:ds_custom_middleware/src/static_files/ds_static_file_handler.dart';
import 'package:ds_custom_middleware/src/model/ds_request_model.dart';

Future<String> testStaticFiles() async {
  final staticFileHandler = DsStaticFileHandler('path/to/your/static/files');

  final request = DsCustomMiddleWareRequest(
    'GET',
    Uri.parse('/index.html'),
    {},
    null,
  );

  final response = await staticFileHandler.handleRequest(request);

  if (response.statusCode == 200) {
    return 'Static file served successfully. Content-Type: ${response.headers['Content-Type']}';
  } else {
    return 'Failed to serve static file. Status code: ${response.statusCode}';
  }
}
