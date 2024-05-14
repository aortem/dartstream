import 'dart:io';

//Standard Testing Tools
import 'package:ds_tools_testing/ds_tools_testing.dart';

//General Tools
import 'package:ds_tools_general/ds_tools_general.dart';

void main(List<String> arguments) async {
  var uploadDir = 'upload';
  var currentDirectory = Directory(uploadDir);
  var images = [];

  await for (var fileEntity in currentDirectory.list()) {
    images.add(fileEntity.uri.path);
  }

  var server = await HttpServer.bind('localhost', 8080);

  await for (var request in server) {
    var queryParams = request.uri.queryParameters;
    var fileToDownload = queryParams['file-to-download'];

    if (fileToDownload is String) {
      // print(fileToDownload);
      var file = File(fileToDownload);

      if (await file.exists()) {
        var fileStream = file.openRead();
        String mimeType = lookupMimeType(fileToDownload) ??
            'application/octet-stream'; // Provide a default MIME type if lookup fails
        request.response
          ..headers.set('Content-Type', mimeType)
          ..headers.set('Content-Disposition',
              'attachment; filename="${fileToDownload.split('/').last}"');
        await request.response.addStream(fileStream);
        await request.response.close();
      } else {
        await request.response.redirect(Uri(path: '/'));
      }
    } else {
      request.response
        ..headers.set('Content-Type', 'text/html')
        ..write('''
        <!doctype html>
<html lang="en">

<head>
  <title>title</title>
</head>
<body>
<h3>Wajeeha USman</h3>
    <label>Choose a Image:</label>
    <form>
    <select name="file-to-download">
        <option value="">Choose Image</option>
        <option>${images.join('</option><option>')}</option>
    </select>
<button>Download</button>
</form>
</body>

</html>
      ''');
      request.response.close();
    }
  }
}
