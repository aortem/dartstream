import 'dart:typed_data';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// Your Firebase SDK

class StorageExample extends StatefulWidget {
  @override
  _StorageExampleState createState() => _StorageExampleState();
}

class _StorageExampleState extends State<StorageExample> {
  final FirebaseStorage storage = FirebaseApp.instance.getStorage();
  Uint8List? fileBytes; // File data
  String? fileName; // File name

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        fileBytes = kIsWeb
            ? result.files.single.bytes
            : await result.files.single.readStream!.toList().then(
                (parts) => Uint8List.fromList(parts.expand((x) => x).toList()));
        fileName = result.files.single.name;
        setState(() {});
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  Future<void> uploadFile() async {
    if (fileBytes != null && fileName != null) {
      try {
        await storage.uploadFile(
          'uploads/$fileName',
          fileBytes!,
          //Set appropriate MIME type based on file
        );
        print("File uploaded successfully");
      } catch (e) {
        print("Failed to upload file: $e");
      }
    } else {
      print('No file selected or file data is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Storage Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: Text('Pick a File'),
            ),
            SizedBox(height: 20),
            if (fileName != null) Text('Picked File: $fileName'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadFile,
              child: Text('Upload File to Firebase Storage'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StorageExample(),
  ));
}
