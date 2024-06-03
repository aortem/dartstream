import 'package:aortem_firebase_dart_sdk/database.dart' show FirebaseDatabaseException;

import '../event.dart';

class CancelEvent extends Event {
  final FirebaseDatabaseException? error;

  final StackTrace? stackTrace;

  CancelEvent(this.error, this.stackTrace) : super('cancel');
}
