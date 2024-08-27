import 'dart:developer';

import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';

import 'firebase_presistance.dart';

class PersistenceSelectorDropdown extends StatefulWidget {
  PersistenceSelectorDropdown();

  @override
  _PersistenceSelectorDropdownState createState() =>
      _PersistenceSelectorDropdownState();
}

class _PersistenceSelectorDropdownState
    extends State<PersistenceSelectorDropdown> {
  String? _selectedPersistence;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: DropdownButton<String>(
        value: _selectedPersistence,
        hint: Text('Choose Persistence Option'),
        onChanged: (String? newValue) async {
          setState(() {
            _selectedPersistence = newValue;
          });
          if (newValue != null) {
            if (_selectedPersistence != null) {
              try {
                final response = await FirebaseApp.firebaseAuth
                    ?.setPresistanceMethod(
                        _selectedPersistence!, 'firebasdartadminauthsdk');
                //  log("response of pressitance $response");
              } catch (e) {
                log("response of pressitance $e");
              }
            }
          }
        },
        items: [
          DropdownMenuItem(
            value: FirebasePersistence.LOCAL,
            child: Text('Local'),
          ),
          DropdownMenuItem(
            value: FirebasePersistence.SESSION,
            child: Text('Session'),
          ),
          DropdownMenuItem(
            value: FirebasePersistence.NONE,
            child: Text('None'),
          ),
        ],
      ),
    ));
  }
}
