// import 'package:ds_dartstream/ds_dartstream.dart';

// void main() async {
//   // Initialize the DsDartstream
//   var dsDartstream = DsDartstream();

//   // Connect to SQLite
//   await dsDartstream.connectToSQLite('my_database.db');

//   // Connect to PostgreSQL
//   await dsDartstream.connectToPostgreSQL('localhost', 5432, 'my_postgres_db', 'postgres_user', 'password');

//   // Connect to GCP Firestore
//   await dsDartstream.connectToFirestore('your-project-id');

//   // Connect to AWS DynamoDB
//   await dsDartstream.connectToDynamoDB('your-access-key', 'your-secret-key', 'your-region');

//   // Connect to GCP Cloud Auth Proxy
//   await dsDartstream.connectToGcpCloudAuthProxy('https://cloud-auth-proxy.example.com', 'your-gcp-target-url');

//   // Use other connections for your database operations

//   // Close connections when done
//   await dsDartstream.closeConnections();
// }
