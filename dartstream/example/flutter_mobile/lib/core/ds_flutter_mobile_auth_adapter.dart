import 'package:flutter/material.dart';
import 'package:dartstream_backend/extensions/auth/lib/ds_auth_export.dart';
import 'package:dartstream_auth/ds_auth_export.dart';
import 'package:dartstream_backend/extensions/auth/ds_user.dart';

/// AuthAdapter for Flutter Mobile framework
class DSFlutterMobileAuthAdapter extends ChangeNotifier {
  final DSAuthManager _authManager;
  DSUser? _user;

  DSFlutterMobileAuthAdapter(String providerName)
      : _authManager = DSAuthManager(providerName);

  Future<void> signIn(String username, String password) async {
    await _authManager.signIn(username, password);
    _user = await _authManager.getUser("123");
    notifyListeners(); // Notify Flutter widgets of changes
  }

  Future<void> signOut() async {
    await _authManager.signOut();
    _user = null;
    notifyListeners();
  }

  DSUser? get user => _user;
}
