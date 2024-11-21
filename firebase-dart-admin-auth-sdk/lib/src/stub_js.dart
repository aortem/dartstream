/// This is a stub file for non-web platforms
class JsObject {
  ///call method
  dynamic callMethod(String method, [List<dynamic>? args]) {
    throw UnsupportedError('JS interop is only supported on the web platform.');
  }
}

///context

final context = JsObject();
