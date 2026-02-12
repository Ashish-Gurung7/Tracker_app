import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:tracker_app/models/lend_borrow_model.dart';
import 'package:tracker_app/models/transaction_model.dart';

// this class handles generating PDF reports
class PdfService {

  // generate a PDF report for transactions
  static Future<void> generateTransactionPdf(
      BuildContext context, List<TransactionModel> transactions) async {
    // create a new pdf document
    final doc = pw.Document();

    // add a page with a table of transactions
    doc.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            // title header
            pw.Header(
              level: 0,
              child: pw.Text('Transaction Report',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            // table with transaction data
            pw.Table.fromTextArray(
              context: context,
              headers: ['Date', 'Description', 'Type', 'Amount'],
              data: transactions.map((t) {
                return [
                  "${t.date.day}/${t.date.month}/${t.date.year}",
                  t.description,
                  t.type == TransactionType.income ? 'Income' : 'Expense',
                  "Rs ${t.amount.toStringAsFixed(0)}",
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    // save the pdf
    final bytes = await doc.save();
    await _saveOrShare(context, bytes, 'transactions.pdf');
  }

  // generate a PDF report for lend/borrow records
  static Future<void> generateLendBorrowPdf(
      BuildContext context, List<LendBorrowModel> records) async {
    // create new pdf document
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            // title
            pw.Header(
              level: 0,
              child: pw.Text('Lend/Borrow Report',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            // table with lend borrow data
            pw.Table.fromTextArray(
              context: context,
              headers: ['Date', 'Person', 'Type', 'Amount', 'Note'],
              data: records.map((r) {
                return [
                  "${r.date.day}/${r.date.month}/${r.date.year}",
                  r.personName,
                  r.type == DebtType.lend ? 'Lend' : 'Borrow',
                  "Rs ${r.amount.toStringAsFixed(0)}",
                  r.note,
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    final bytes = await doc.save();
    await _saveOrShare(context, bytes, 'lend_borrow_report.pdf');
  }

  // save the pdf to downloads or share it
  static Future<void> _saveOrShare(
      BuildContext context, Uint8List bytes, String fileName) async {
    try {
      // check if we are on android
      if (Platform.isAndroid) {
        // ask for storage permission
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }

        if (status.isGranted) {
          // try to save to downloads folder
          final downloadDir = Directory('/storage/emulated/0/Download');
          if (await downloadDir.exists()) {
            final file = File('${downloadDir.path}/$fileName');
            await file.writeAsBytes(bytes);
            // show success message
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Saved to Downloads: $fileName')),
              );
            }
            return;
          }
        }
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // on desktop, save to downloads directory
        final directory = await getDownloadsDirectory();
        if (directory != null) {
          final file = File('${directory.path}/$fileName');
          await file.writeAsBytes(bytes);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Saved to ${file.path}')),
            );
          }
          return;
        }
      }
    } catch (e) {
      // if something goes wrong, print the error
      debugPrint('Error saving file directly: $e');
    }

    // if direct save failed, use share sheet instead
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }
}
