import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  String? _pdfUrl;
  Future<void> _uploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final pdfFile = result.files.single;
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('pdfs/${pdfFile.name}');
      final UploadTask uploadTask =
          storageReference.putFile(File(pdfFile.path!));
      final TaskSnapshot taskSnapshot = await uploadTask;

      if (taskSnapshot.state == TaskState.success) {
        final pdfUrl = await storageReference.getDownloadURL();
        setState(() {
          _pdfUrl = pdfUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xerox'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          TextButton.icon(
            onPressed: _uploadPDF,
            icon: Icon(Icons.cloud_upload_outlined),
            label: Text('Upload PDF'),
          ),
        ],
      ),
    );
  }
}
