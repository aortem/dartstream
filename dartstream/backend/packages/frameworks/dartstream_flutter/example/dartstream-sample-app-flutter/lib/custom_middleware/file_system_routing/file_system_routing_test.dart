import 'package:ds_custom_middleware/src/routing/file_system_routing.dart';
import 'package:ds_custom_middleware/src/model/ds_request_model.dart';

Future<String> testFileSystemRouting() async {
  final router = FileSystemRouter('path/to/your/route/files');

  final request = DsCustomMiddleWareRequest(
    'GET',
    Uri.parse('/example/route'),
    {},
    null,
  );

  final response = await router.handleRequest(request);

  if (response.statusCode == 200) {
    return 'File system routing successful. Response: ${response.body}';
  } else {
    return 'File system routing failed. Status code: ${response.statusCode}';
  }
}
