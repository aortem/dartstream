import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';

/// Creates a Shelf handler that serves static files from a directory.
///
/// [directory] is the path to the directory to serve files from.
/// [useHeaderBytesForContentType] can be set to true to sniff the content type
/// from the bytes of the file.
/// [defaultDocument] is the file to serve if the request path is a directory.
/// [listDirectories] can be set to true to list the files in a directory.
Handler createStaticFileHandler(
  String directory, {
  bool useHeaderBytesForContentType = false,
  String? defaultDocument,
  bool listDirectories = false,
}) {
  return createStaticHandler(
    directory,
    useHeaderBytesForContentType: useHeaderBytesForContentType,
    defaultDocument: defaultDocument,
    listDirectories: listDirectories,
  );
}
