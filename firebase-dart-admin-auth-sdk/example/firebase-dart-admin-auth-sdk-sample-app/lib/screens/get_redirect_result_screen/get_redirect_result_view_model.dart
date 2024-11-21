import 'dart:developer';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class RedirectResult {
  final User? user;
  final AuthCredential? credential;
  final AdditionalUserInfo? additionalUserInfo;
  final String? operationType;

  RedirectResult({
    this.user,
    this.credential,
    this.additionalUserInfo,
    this.operationType,
  });

  factory RedirectResult.fromJson(Map<String, dynamic> json) {
    return RedirectResult(
      user: json['user'] != null
          ? User(
              uid: json['user']['uid'],
              email: json['user']['email'],
              displayName: json['user']['displayName'],
              photoURL: json['user']['photoUrl'],
              emailVerified: json['user']['emailVerified'] ?? false,
              idToken: json['user']['idToken'],
              refreshToken: json['user']['refreshToken'],
            )
          : null,
      credential: json['credential'] != null
          ? OAuthCredential(
              providerId: json['credential']['providerId'] ?? 'google.com',
              accessToken: json['credential']['accessToken'],
              idToken: json['credential']['idToken'],
              signInMethod: json['credential']['signInMethod'] ?? 'redirect',
            )
          : null,
      additionalUserInfo: json['additionalUserInfo'] != null
          ? AdditionalUserInfo.fromJson(json['additionalUserInfo'])
          : null,
      operationType: json['operationType'],
    );
  }
}

class GetRedirectResultViewModel extends ChangeNotifier {
  bool _loading = false;
  String? _error;
  RedirectResult? _redirectResult;

  bool get loading => _loading;
  String? get error => _error;
  RedirectResult? get redirectResult => _redirectResult;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> getRedirectResults() async {
    _setLoading(true);
    _error = null;
    _redirectResult = null;

    try {
      // First check if we have a current user
      final currentUser = FirebaseApp.instance.getCurrentUser();
      if (currentUser == null) {
        _error = 'No signed-in user found';
        return;
      }

      final result = await FirebaseApp.firebaseAuth?.getRedirectResult();
      log('Redirect result: $result');

      if (result != null) {
        _redirectResult = RedirectResult.fromJson(result);
        BotToast.showText(text: 'Successfully retrieved redirect result');
      } else {
        _error = 'No redirect result available';
        BotToast.showText(text: 'No redirect result available');
      }
    } catch (e) {
      log('Error getting redirect result: $e');
      _error = e is FirebaseAuthException
          ? e.message
          : 'Failed to get redirect result';
      BotToast.showText(text: 'Error: $_error');
    } finally {
      _setLoading(false);
    }
  }
}
