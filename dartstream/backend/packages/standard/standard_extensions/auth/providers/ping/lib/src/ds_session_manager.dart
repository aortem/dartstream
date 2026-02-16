import 'package:ds_auth_base/ds_auth_provider.dart';

class DSPingSessionManager {
  final Map<String, _MockUser> _users = {};
  String? _currentUserId;

  DSAuthUser? get currentUser =>
      _currentUserId == null ? null : _users[_currentUserId!]?.user;

  bool userExists(String email) =>
      _users.values.any((u) => u.user.email == email);

  void createUser({
    required String email,
    required String password,
    required String displayName,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _users[id] = _MockUser(
      password: password,
      user: DSAuthUser(
        id: id,
        email: email,
        displayName: displayName,
      ),
    );
  }

  DSAuthUser authenticate(String email, String password) {
    final entry = _users.entries.firstWhere(
      (e) =>
          e.value.user.email == email &&
          e.value.password == password,
      orElse: () => throw DSAuthError('Invalid credentials'),
    );

    _currentUserId = entry.key;
    return entry.value.user;
  }

  DSAuthUser? getUserById(String id) => _users[id]?.user;

  void clearSession() {
    _currentUserId = null;
  }
}

class _MockUser {
  final String password;
  final DSAuthUser user;

  _MockUser({required this.password, required this.user});
}
