import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:xerox/models/pdf.dart';
import 'package:xerox/widgets/pdf_list.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key, required this.username});
  final String username;

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  final database = FirebaseDatabase.instance;
  String? _pdfUrl;
  var isLoading = false;

  var pdfData;

  final uuid = const Uuid();

  List<Pdf> uploadedPdf = [];

  @override
  void initState() {
    retrievePdf();
    super.initState();
  }

  void retrievePdf() async {
    uploadedPdf = [];

    setState(() {
      isLoading = true;
    });
    final pdfSnapShot = await database.ref().child('uploadedPdf/').get();
    if (pdfSnapShot.exists) {
      pdfData = pdfSnapShot.value;

      if (pdfData != null) {
        for (final item in pdfData.entries) {
          if (item.value['uid'] == firebaseAuth.currentUser!.uid) {
            uploadedPdf.add(
              Pdf(
                pdfKey: item.key,
                date: item.value['date'],
                pdfName: item.value['pdfName'],
                pdfUrl: item.value['pdfUrl'],
                uid: item.value['uid'],
                username: item.value['username'],
                printed: item.value['printed'],
              ),
            );
          }
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _uploadPDF() async {
    final url = Uri.https(
      'xerox-800f7-default-rtdb.firebaseio.com',
      'uploadedPdf.json',
    );

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    setState(() {
      isLoading = true;
    });

    if (result != null) {
      final pdfFile = result.files.single;
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('pdfs/${firebaseAuth.currentUser!.uid}/${uuid.v4()}');
      final UploadTask uploadTask =
          storageReference.putFile(File(pdfFile.path!));
      final TaskSnapshot taskSnapshot = await uploadTask;

      if (taskSnapshot.state == TaskState.success) {
        final pdfUrl = await storageReference.getDownloadURL();
        setState(() {
          _pdfUrl = pdfUrl;
        });

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'username': widget.username,
              'pdfUrl': _pdfUrl,
              'date': DateTime.now().toString(),
              'uid': firebaseAuth.currentUser!.uid,
              'pdfName': pdfFile.name,
              'printed': 'No',
            },
          ),
        );
        setState(() {
          uploadedPdf.add(
            Pdf(
                pdfKey: 'dummy',
                date: DateTime.now().toString(),
                pdfName: pdfFile.name,
                pdfUrl: pdfUrl,
                uid: firebaseAuth.currentUser!.uid,
                username: widget.username,
                printed: 'No'),
          );
        });
      }
    }
    setState(() {
      isLoading = false;
    });
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
          TextButton.icon(
            onPressed: () {
              firebaseAuth.signOut();
            },
            icon: Icon(Icons.logout),
            label: Text('Logout'),
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    'Files uploaded',
                    style: GoogleFonts.openSans().copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: uploadedPdf.length,
                    itemBuilder: (context, index) => PdfList(
                      uploadedPdf: uploadedPdf,
                      index: index,
                      userType: 'student',
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
