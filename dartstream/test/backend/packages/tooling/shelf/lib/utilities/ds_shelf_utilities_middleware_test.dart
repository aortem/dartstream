// Import Top Level Package
import 'package:ds_shelf/ds_shelf_test.dart' as shelf; //Coverage for shelf
//Coverage for other packages

//Import other core packages

shelf.Middleware corsHeaders({Map<String, String>? headers}) {
  return (shelf.Handler innerHandler) {
    return (shelf.Request request) async {
      final mapHeaders = {
        'Access-Control-Allow-Origin': '*',
        ...?headers,
      };

      if (request.method == 'OPTIONS') {
        return shelf.Response.ok('', headers: mapHeaders);
      }

      final response = await innerHandler(request);
      return response.change(headers: mapHeaders);
    };
  };
}
