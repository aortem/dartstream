import 'dart:developer';

import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';

import 'firebase_presistance.dart';

class PersistenceSelectorDropdown extends StatefulWidget {
  const PersistenceSelectorDropdown({super.key});

  @override
  State<PersistenceSelectorDropdown> createState() =>
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
          hint: const Text('Choose Persistence Option'),
          onChanged: (String? newValue) async {
            setState(() {
              _selectedPersistence = newValue;
            });
            if (newValue != null) {
              if (_selectedPersistence != null) {
                try {
                  await FirebaseApp.firebaseAuth?.setPresistanceMethod(
                    _selectedPersistence!,
                    'firebasdartadminauthsdk',
                  );
                  //  log("response of pressitance $response");
                } catch (e) {
                  log("response of pressitance $e");
                }
              }
            }
          },
          items: const [
            DropdownMenuItem(
              value: FirebasePersistence.local,
              child: Text('Local'),
            ),
            DropdownMenuItem(
              value: FirebasePersistence.session,
              child: Text('Session'),
            ),
            DropdownMenuItem(
              value: FirebasePersistence.none,
              child: Text('None'),
            ),
          ],
        ),
      ),
    );
  }
}
