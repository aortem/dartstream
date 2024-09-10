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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Middleware Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _testDynamicRouting,
              child: Text(' Dynamic Routing'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testIndexRouting,
              child: Text(' Index Routing'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testPrintRouting,
              child: Text(' Print Routing'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testNestedRouting,
              child: Text(' Nested Routing'),
            ),
          ],
        ),
      ),
    );
  }
}
