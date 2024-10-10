// This is a stub file for non-web platforms
class Window {
  dynamic open(String url, String target, [String? features]) {
    throw UnsupportedError(
        'Window.open is only supported on the web platform.');
  }

  void addEventListener(String type, Function listener,
      [bool useCapture = false]) {
    throw UnsupportedError(
        'Window.addEventListener is only supported on the web platform.');
  }

  void removeEventListener(String type, Function listener,
      [bool useCapture = false]) {
    throw UnsupportedError(
        'Window.removeEventListener is only supported on the web platform.');
  }
}

class Document {
  Element? get head => null;
}

class Element {
  List<Element> get children => [];
  void add(Element child) {}
}

class ScriptElement extends Element {
  String src = '';
  bool async = false;
  bool defer = false;
  Stream<Event> get onLoad => Stream.empty();
}

class Event {}

final window = Window();
final document = Document();

class MessageEvent extends Event {
  dynamic get data => null;
}
