import 'package:ds_custom_middleware/ds_custom_middleware_interceptor.dart';
import 'package:ds_custom_middleware/src/model/ds_request_model.dart';
import 'package:ds_custom_middleware/src/model/ds_response_model.dart';
import 'package:flutter/material.dart';

// Import the new test files
import '../body_parsing/body_parsing_test.dart';
import '../cors/cors_test.dart';
import '../error_handling/error_handling_test.dart';
import '../http_helpers/http_helpers_test.dart';
import '../logger/logger_test.dart';
import '../query_string/query_string_test.dart';
import '../websocket/websocket_test.dart';
import '../static_files/static_files_test.dart';
import '../authorization/authorization_test.dart';
import '../route_params/route_params_test.dart';
import '../file_system_routing/file_system_routing_test.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RequestInterceptor _requestInterceptor = RequestInterceptor();
  String _webSocketStatus = '';
  String _testResult = '';

  void _updateTestResult(String result) {
    setState(() {
      _testResult = result;
    });
  }

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
  Future<void> _testBodyParsing() async {
    final result = await testBodyParsing();
    print(result);
  }

  Future<void> _testCors() async {
    final result = await testCors();
    print(result);
  }

  Future<void> _testErrorHandling() async {
    final result = await testErrorHandling();
    print(result);
  }

  void _testHttpHelpers() {
    final result = testHttpHelpers();
    print(result);
  }

  void _testLogger() {
    final result = testLogger();
    _updateTestResult(result);
    print(result);
  }

  void _testQueryString() {
    final result = testQueryString();
    print(result);
  }

  Future<void> _testWebSocket() async {
    setState(() {
      _webSocketStatus = 'Connecting...';
    });
    final result = await testWebSocket();
    setState(() {
      _webSocketStatus = result;
    });
  }

  Future<void> _testStaticFiles() async {
    final result = await testStaticFiles();
    print(result);
  }

  Future<void> _testAuthorization() async {
    final result = await testAuthorization();
    _updateTestResult(result);
    print(result);
  }

  Future<void> _testRouteParams() async {
    final result = await testRouteParams();
    print(result);
  }

  Future<void> _testFileSystemRouting() async {
    final result = await testFileSystemRouting();
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
                onPressed: _testBodyParsing,
                child: Text('Test Body Parsing'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testCors,
                child: Text('Test CORS'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testErrorHandling,
                child: Text('Test Error Handling'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testHttpHelpers,
                child: Text('Test HTTP Helpers'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testLogger,
                child: Text('Test Logging'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testQueryString,
                child: Text('Test Query String'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testWebSocket,
                child: Text('Test WebSocket'),
              ),
              SizedBox(height: 8),
              Text(_webSocketStatus,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testStaticFiles,
                child: Text('Test Static Files'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testAuthorization,
                child: Text('Test Authorization'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testRouteParams,
                child: Text('Test Route Params'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _testFileSystemRouting,
                child: Text('Test File System Routing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
