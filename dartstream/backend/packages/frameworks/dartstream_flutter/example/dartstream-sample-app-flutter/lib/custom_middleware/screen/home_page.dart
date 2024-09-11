import 'package:ds_custom_middleware/ds_custom_middleware_interceptor.dart';
import 'package:ds_custom_middleware/src/model/ds_request_model.dart';
import 'package:ds_custom_middleware/src/model/ds_response_model.dart';
import 'package:flutter/material.dart';

// Import the new test files
import '../body_parser/body_parser_test.dart';
import '../cors_middleware/cors_middleware_test.dart';
import '../error_handler/error_handler_test.dart';
import '../http_helpers/http_helpers_test.dart';

import '../logger/logger_test.dart';
import '../query_string_handler/query_string_handler_test.dart';
import '../websocket/websocket_test.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RequestInterceptor _requestInterceptor = RequestInterceptor();

  Future<void> _testDynamicRouting() async {
    final dynamicRequest = DsCustomMiddleWareRequest(
      'GET',
      Uri.parse('https://api.example.com/users/123'),
      {},
      null,
    );
    final dynamicResponse =
        await _requestInterceptor.handle(dynamicRequest, (request) async {
      return DsCustomMiddleWareResponse.ok('Dynamic routing handled');
    });
    print('Dynamic Routing Response: ${dynamicResponse.body}');
  }

  Future<void> _testIndexRouting() async {
    final indexRequest = DsCustomMiddleWareRequest(
      'GET',
      Uri.parse('https://api.example.com/index'),
      {},
      null,
    );
    final indexResponse =
        await _requestInterceptor.handle(indexRequest, (request) async {
      return DsCustomMiddleWareResponse.ok('Index routing handled');
    });
    print('Index Routing Response: ${indexResponse.body}');
  }

  Future<void> _testPrintRouting() async {
    final printRequest = DsCustomMiddleWareRequest(
      'GET',
      Uri.parse('https://api.example.com/print/someinfo'),
      {'Accept': 'text/plain'},
      null,
    );
    final printResponse =
        await _requestInterceptor.handle(printRequest, (request) async {
      return DsCustomMiddleWareResponse.ok('Print routing handled');
    });
    print('Print Routing Response: ${printResponse.body}');
  }

  Future<void> _testNestedRouting() async {
    final nestedRequest = DsCustomMiddleWareRequest(
      'GET',
      Uri.parse('https://api.example.com/users/123/profile'),
      {},
      null,
    );
    final nestedResponse =
        await _requestInterceptor.handle(nestedRequest, (request) async {
      return DsCustomMiddleWareResponse.ok('Nested routing handled');
    });
    print('Nested Routing Response: ${nestedResponse.body}');
  }

  // New test functions
  Future<void> _testBodyParser() async {
    final result = await testBodyParser();
    print(result);
  }

  Future<void> _testCorsMiddleware() async {
    final result = await testCorsMiddleware();
    print(result);
  }

  Future<void> _testErrorHandler() async {
    final result = await testErrorHandler();
    print(result);
  }

  void _testHttpHelpers() {
    final result = testHttpHelpers();
    print(result);
  }

  void _testLogger() {
    final result = testLogger();
    print(result);
  }

  void _testQueryStringHandler() {
    final result = testQueryStringHandler();
    print(result);
  }

  void _testWebSocket() {
    final result = testWebSocket();
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Middleware Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: _testDynamicRouting,
                child: Text('Test Dynamic Routing'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testIndexRouting,
                child: Text('Test Index Routing'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testPrintRouting,
                child: Text('Test Print Routing'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testNestedRouting,
                child: Text('Test Nested Routing'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testBodyParser,
                child: Text('Test Body Parser'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testCorsMiddleware,
                child: Text('Test CORS Middleware'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testErrorHandler,
                child: Text('Test Error Handler'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testHttpHelpers,
                child: Text('Test HTTP Helpers'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testLogger,
                child: Text('Test Logger'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testQueryStringHandler,
                child: Text('Test Query String Handler'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testWebSocket,
                child: Text('Test WebSocket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
