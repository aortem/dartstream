// Always Import the Utillities Base Class
import 'ds_utilities_base.dart';

//Import Other Packages

import 'package:shelf/shelf.dart' as shelf;

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
