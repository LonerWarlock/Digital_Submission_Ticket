import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> generatePDF(Map UT_1_marks, Map UT_2_marks, Map Attendance, Map ApprovalStatus) async {

  print(UT_1_marks);

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
            children : [
              pw.Text('E - Submission Ticket',
                  style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _buildReason(UT_1_marks, UT_2_marks, Attendance, ApprovalStatus)

            ]
        );
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/results.pdf');
  print('${output.path}/results.pdf');
  await file.writeAsBytes(await pdf.save());

  OpenFile.open(file.path);
}


pw.Widget _buildReason(Map UT_1_marks, Map UT_2_marks, Map Attendancd, Map ApprovalStatus) {
  print(UT_1_marks);
  print(ApprovalStatus);
  final List<pw.TableRow> rows = [];

  if (UT_1_marks.isNotEmpty ) {
    rows.add(
        pw.TableRow(
          children: [
            pw.Container(
              color: PdfColor.fromHex('#102C57'),
              alignment: pw.Alignment.center,
              padding: pw.EdgeInsets.all(10), // Increase padding to 10
              child: pw.Text(
                'Subject',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 19,
                  color: PdfColor.fromHex('#FFFFFF'), // White text color
                ),
              ),
            ),
            pw.Container(
              color:PdfColor.fromHex('#102C57'),
              alignment: pw.Alignment.center,
              padding: pw.EdgeInsets.all(10), // Increase padding to 10
              child: pw.Text(
                'U1 1',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 19,
                  color: PdfColor.fromHex('#FFFFFF'), // White text color
                ),
              ),
            ),
            pw.Container(
              color: PdfColor.fromHex('#102C57'),
              alignment: pw.Alignment.center,
              padding: pw.EdgeInsets.all(10), // Increase padding to 10
              child: pw.Text(
                'UT 2',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 19,
                  color: PdfColor.fromHex('#FFFFFF'), // White text color
                ),
              ),
            ),
            pw.Container(
              color: PdfColor.fromHex('#102C57'),
              alignment: pw.Alignment.center,
              padding: pw.EdgeInsets.all(10), // Increase padding to 10
              child: pw.Text(
                'Approval',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 19,
                  color: PdfColor.fromHex('#FFFFFF'), // White text color
                ),
              ),
            ),
          ],
        ),
    );
  }

  else
  {
    rows.add(
        pw.TableRow(children: [
          pw.Padding(
            padding: pw.EdgeInsets.all(10), // Increase padding to 10
            child: pw.Text('You have not Updated Marks', textAlign: pw.TextAlign.center, style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, fontSize: 15)),
          ),]));
  }
  
  UT_1_marks.forEach((subject, marks) {
        int marks2 = UT_2_marks[subject];
        String approvalStatus = ApprovalStatus[subject]["status"];
        print(approvalStatus);
        rows.add(
          pw.TableRow(
            children: [
              pw.Container(
                alignment: pw.Alignment.center,
                child : pw.Padding(
                  padding: pw.EdgeInsets.all(10), // Increase padding to 10
                  child: pw.Text("$subject", style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 18)),
                ),
              ),
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(10), // Increase padding to 10
                  child: marks != -1
                      ? pw.Text(
                    "$marks",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
                  )
                      : null, // Return null if marks is -1
                ),
              ),
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(10), // Increase padding to 10
                  child: marks2 != -1
                      ? pw.Text(
                    "$marks2",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
                  )
                      : null, // Return null if marks is -1
                ),
              ),
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(10), // Increase padding to 10
                  child: approvalStatus == "Completed"
                      ? pw.Text(
                    "Approved",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18, color: PdfColor.fromHex("#2C7865")),
                  )
                      : pw.Text(
                    "Pending",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18, color: PdfColor.fromHex("#B80000")),
                  ), // Return null if marks is -1
                ),
              )
            ],

          ),
        );
  });

  return pw.Table(
    border: pw.TableBorder.all(width: 1), // Add borders to the table cells
    children: rows,
  );
}