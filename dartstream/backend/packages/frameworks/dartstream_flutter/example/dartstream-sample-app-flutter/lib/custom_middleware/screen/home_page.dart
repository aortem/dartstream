import 'package:ds_custom_middleware/ds_custom_middleware_interceptor.dart';
import 'package:ds_custom_middleware/src/model/ds_request_model.dart';
import 'package:ds_custom_middleware/src/model/ds_response_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RequestInterceptor _requestInterceptor = RequestInterceptor();

  Future<void> _testRouting() async {
    // Example request for dynamic routing
    final dynamicRequest = DsCustomMiddleWareRequest(
      'GET',
      Uri.parse('/users/123'),
      {},
      null,
    );
    final dynamicResponse =
        await _requestInterceptor.handle(dynamicRequest, (request) async {
      // Forward the request to the next middleware (if any)
      return DsCustomMiddleWareResponse.ok('Dynamic routing handled');
    });
    print('Dynamic Routing Response: ${dynamicResponse.body}');

    // Example request for index routing
    final indexRequest = DsCustomMiddleWareRequest(
      'GET',
      Uri.parse('/index'),
      {},
      null,
    );
    final indexResponse =
        await _requestInterceptor.handle(indexRequest, (request) async {
      // Forward the request to the next middleware (if any)
      return DsCustomMiddleWareResponse.ok('Index routing handled');
    });
    print('Index Routing Response: ${indexResponse.body}');

    // Example request for print routing
    final printRequest = DsCustomMiddleWareRequest(
      'GET',
      Uri.parse('/print/someinfo'),
      {'Accept': 'text/plain'},
      null,
    );
    final printResponse =
        await _requestInterceptor.handle(printRequest, (request) async {
      // Forward the request to the next middleware (if any)
      return DsCustomMiddleWareResponse.ok('Print routing handled');
    });
    print('Print Routing Response: ${printResponse.body}');

    // Example request for nested routing
    final nestedRequest = DsCustomMiddleWareRequest(
      'GET',
      Uri.parse('/users/123/profile'),
      {},
      null,
    );
    final nestedResponse =
        await _requestInterceptor.handle(nestedRequest, (request) async {
      // Forward the request to the next middleware (if any)
      return DsCustomMiddleWareResponse.ok('Nested routing handled');
    });
    print('Nested Routing Response: ${nestedResponse.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Middleware Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _testRouting,
          child: Text('Test Routing'),
        ),
      ),
    );
  }
}
