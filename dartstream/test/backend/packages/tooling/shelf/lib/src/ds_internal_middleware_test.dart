// Import Top Level Package
import 'package:ds_shelf/ds_shelf_test.dart' as shelf; //Coverage for shelf
//Coverage for other packages

//Import other core packages

shelf.Middleware myCustomMiddleware() {
  return (shelf.Handler handler) {
    return (shelf.Request request) async {
      // Middleware logic before calling the handler
      final modifiedRequest = request.change(context: {'foo': 'bar'});
      final response = await handler(modifiedRequest);
      // Modify the response or perform actions after the handler call
      return response;
    };
  };
}
