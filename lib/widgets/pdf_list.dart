import 'package:flutter/material.dart';
import 'package:xerox/models/pdf.dart';

class PdfList extends StatelessWidget {
  PdfList({
    super.key,
    required this.uploadedPdf,
    required this.index,
    required this.userType,
  });

  String userType;

  List<Pdf> uploadedPdf;
  var index;
  @override
  Widget build(BuildContext context) {
    if (userType == 'Student') {
      return Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Text(
              (index + 1).toString(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(width: 20),
            Text(
              uploadedPdf[index].pdfName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Spacer(),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    uploadedPdf[index].printed == 'No'
                        ? Icons.timelapse_rounded
                        : Icons.done,
                    color: uploadedPdf[index].printed == 'No'
                        ? Colors.deepOrange
                        : Colors.green,
                  ),
                  SizedBox(width: 5),
                  Text(
                    uploadedPdf[index].printed == 'No'
                        ? 'On Process'
                        : 'Completed',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: uploadedPdf[index].printed == 'No'
                              ? Colors.deepOrange
                              : Colors.green,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Text(
              (index + 1).toString(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(width: 20),
            Text(
              uploadedPdf[index].pdfName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            // Spacer(),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.download)),
                  SizedBox(width: 5),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.done),
                    label: Text('Printed'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
