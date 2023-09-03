import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xerox/models/pdf.dart';
import 'package:xerox/widgets/pdf_list.dart';

class XeroxShopScreen extends StatefulWidget {
  @override
  State<XeroxShopScreen> createState() => _XeroxShopScreenState();
}

class _XeroxShopScreenState extends State<XeroxShopScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  final database = FirebaseDatabase.instance;
  var isLoading = false;
  var pdfData;

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
                      userType: 'xerox',
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
