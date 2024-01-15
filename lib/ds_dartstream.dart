/// Support for doing something awesome.
///
/// More dartdocs go here.
library;
// lib/db_connector.dart


// lib/ds_dartstream.dart

import 'package:sqflite/sqflite.dart';
import 'package:postgres/postgres.dart';
import 'package:googleapis_firestore/v1.dart' as firestore;
import 'package:http/http.dart' as http;
import 'package:aws_signature_v4/aws_signature_v4.dart';
// Add imports for MySQL, MS SQL, and Oracle

class DsDartstream {
  late Database _sqliteDb;
  late PostgreSQLConnection _postgreSQLConnection;
  late firestore.FirestoreApi _firestoreApi;
  late http.Client _httpClient;
  // Add variables for MySQL, MS SQL, Oracle, GCP Firestore, AWS DynamoDB, and other connections

  // Initialize HTTP client
  DsDartstream() {
    _httpClient = http.Client();
  }

  // SQLite connection
  Future<void> connectToSQLite(String dbName) async {
    _sqliteDb = await openDatabase(dbName);
  }

  // PostgreSQL connection
  Future<void> connectToPostgreSQL(String host, int port, String dbName, String user, String password) async {
    _postgreSQLConnection = PostgreSQLConnection(
      host,
      port,
      dbName,
      username: user,
      password: password,
    );
    await _postgreSQLConnection.open();
  }

  // GCP Firestore connection
  Future<void> connectToFirestore(String projectId) async {
    final client = http.Client();
    final clientViaApiKey = firestore.FirestoreApi(client, rootUrl: 'https://firestore.googleapis.com/');

    _firestoreApi = firestore.FirestoreApi(clientViaApiKey, projectId);
  }

  // AWS DynamoDB connection
  Future<void> connectToDynamoDB(String accessKey, String secretKey, String region) async {
    final awsClient = http.Client();
    final awsSigner = AwsSignatureV4(accessKey, secretKey, 'dynamodb', region: region);
    // Additional configuration for AWS DynamoDB connection

    // Use awsClient with awsSigner for DynamoDB operations
  }

  // GCP Cloud Auth Proxy connection
  Future<void> connectToGcpCloudAuthProxy(String proxyUrl, String targetUrl) async {
    // Make an HTTP request through the Cloud Auth Proxy
    final response = await _httpClient.get(Uri.parse('$proxyUrl/v1/$targetUrl'));

    if (response.statusCode == 200) {
      // Successfully connected through the Cloud Auth Proxy
      print('Connected to GCP Cloud Auth Proxy');
    } else {
      // Handle error
      print('Error connecting to GCP Cloud Auth Proxy: ${response.statusCode}');
    }
  }

  // Add methods for MySQL, MS SQL, Oracle, and other connections

  // Close connections
  Future<void> closeConnections() async {
    await _sqliteDb.close();
    await _postgreSQLConnection.close();
    // Close other connections as needed
    _httpClient.close();
  }
}


export 'src/ds_dartstream_base.dart';

// TODO: Export any libraries intended for clients of this package.
