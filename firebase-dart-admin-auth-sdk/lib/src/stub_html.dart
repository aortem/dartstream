/// This is a stub file for non-web platforms
class Window {
  ///open
  dynamic open(String url, String target, [String? features]) {
    throw UnsupportedError(
        'Window.open is only supported on the web platform.');
  }

  ///alert

  void addEventListener(String type, Function listener,
      [bool useCapture = false]) {
    throw UnsupportedError(
        'Window.addEventListener is only supported on the web platform.');
  }

  ///removeEventListener

  void removeEventListener(String type, Function listener,
      [bool useCapture = false]) {
    throw UnsupportedError(
        'Window.removeEventListener is only supported on the web platform.');
  }
}

///document

class Document {
  ///head
  Element? get head => null;
}

///elemet

class Element {
  ///
  List<Element> get children => [];

  ///
  void add(Element child) {}
}

///script element

class ScriptElement extends Element {
  ///src
  String src = '';

  ///async
  bool async = false;

  ///defer
  bool defer = false;

  ///onload
  Stream<Event> get onLoad => Stream.empty();
}

///event handler
class Event {}

///window handler

final window = Window();

///document handler
final document = Document();

///script element handler

class MessageEvent extends Event {
  ///data
  dynamic get data => null;
}
