class Pdf {
  const Pdf({
    required this.date,
    required this.pdfName,
    required this.pdfUrl,
    required this.uid,
    required this.username,
    required this.printed,
    required this.pdfKey,
  });

  final String pdfKey;
  final String date;
  final String pdfName;
  final String pdfUrl;
  final String uid;
  final String username;
  final String printed;
}
