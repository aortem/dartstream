import 'dart:io';

//Standard Testing Tools
import 'package:ds_tools_testing/ds_tools_testing.dart';

//General Tools
import 'package:ds_tools_general/ds_tools_general.dart';

void main(List<String> arguments) async {
  var server = await HttpServer.bind('localhost', 8080);

  server.listen((request) async {
    if (request.uri.path == '/fileupload') {
      // accessing /fileupload endpoint
      List<int> dataBytes = [];

      await for (var data in request) {
        dataBytes.addAll(data);
      }

      String? boundary = request.headers.contentType?.parameters['boundary'];
      final transformer = MimeMultipartTransformer(boundary ?? '');
      final uploadDirectory = './upload';

      final bodyStream = Stream.fromIterable([dataBytes]);
      final parts = await transformer.bind(bodyStream).toList();

      for (var part in parts) {
        print(part.headers);
        final contentDisposition = part.headers['content-disposition'];
        final filename = RegExp(r'filename="([^"]*)"')
            .firstMatch(contentDisposition ?? '')
            ?.group(1);
        final content = await part.toList();

        if (!Directory(uploadDirectory).existsSync()) {
          await Directory(uploadDirectory).create();
        }

        await File('$uploadDirectory/$filename').writeAsBytes(content[0]);
        request.response.write('Image uploaded Successfully!');
      }
    }

    await request.response.close();
  });
}
