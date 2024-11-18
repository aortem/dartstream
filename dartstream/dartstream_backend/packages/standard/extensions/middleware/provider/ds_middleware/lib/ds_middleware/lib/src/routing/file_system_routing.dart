import 'dart:io';
import '../model/ds_request_model.dart';
import '../model/ds_response_model.dart';

class FileSystemRouter {
  final String basePath;
  final Map<String, Function(DsCustomMiddleWareRequest)> _routes = {};

  FileSystemRouter(this.basePath) {
    _loadRoutes(basePath);
  }

  void _loadRoutes(String dir) {
    final directory = Directory(dir);
    for (var entity in directory.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final relativePath = entity.path.substring(basePath.length);
        final routePath =
            relativePath.replaceAll('.dart', '').replaceAll(r'\', '/');
        _routes[routePath] = _createHandler(entity.path);
      }
    }
  }

  Function(DsCustomMiddleWareRequest) _createHandler(String filePath) {
    return (request) async {
      try {
        final fileContent = await File(filePath).readAsString();
        return DsCustomMiddleWareResponse(
          200,
          {'Content-Type': 'text/plain'},
          'File System Route: $filePath\n\nContent:\n$fileContent',
        );
      } catch (e) {
        return DsCustomMiddleWareResponse(
          500,
          {'Content-Type': 'text/plain'},
          'Error reading file: $e',
        );
      }
    };
  }

  Future<DsCustomMiddleWareResponse> handleRequest(
      DsCustomMiddleWareRequest request) async {
    final handler = _routes[request.uri.path];
    if (handler != null) {
      return await handler(request);
    }
    return DsCustomMiddleWareResponse.notFound();
  }

  List<String> getRegisteredRoutes() {
    return _routes.keys.toList();
  }
}
