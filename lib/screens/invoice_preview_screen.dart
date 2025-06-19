import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'dart:io' show File;
import 'package:universal_html/html.dart' as html show AnchorElement, Blob, Url;
import '../models/article.dart';
import '../widgets/invoice_preview.dart';

class InvoicePreviewScreen extends StatelessWidget {
  final String clientName;
  final String clientEmail;
  final DateTime invoiceDate;
  final List<Article> articles;

  const InvoicePreviewScreen({
    super.key,
    required this.clientName,
    required this.clientEmail,
    required this.invoiceDate,
    required this.articles,
  });

  Future<void> _generatePDF(BuildContext context) async {
    try {
      final pdf = pw.Document();
      final dateFormat = DateFormat('dd/MM/yyyy');
      final totalHT = articles.fold(0.0, (sum, a) => sum + a.totalHT);
      final tva = totalHT * 0.2;
      final totalTTC = totalHT + tva;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                'INVOICE',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Invoice #${DateTime.now().millisecondsSinceEpoch % 10000}'),
              pw.Text('Date: ${dateFormat.format(invoiceDate)}'),
              pw.SizedBox(height: 20),
              // Client Info
              pw.Text('Client Information', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.Text('Name: $clientName'),
              pw.Text('Email: $clientEmail'),
              pw.SizedBox(height: 20),
              // Articles Table
              pw.Text('Articles', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Qty x Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...articles.map((a) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(a.description.isEmpty ? 'No description' : a.description),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('${a.quantity} x ${a.priceHT.toStringAsFixed(2)}'),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('${a.totalHT.toStringAsFixed(2)} TND'),
                          ),
                        ],
                      )),
                ],
              ),
              pw.SizedBox(height: 20),
              // Totals
              pw.Text('Summary', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total HT:'),
                  pw.Text('${totalHT.toStringAsFixed(2)} TND'),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TVA (20%):'),
                  pw.Text('${tva.toStringAsFixed(2)} TND'),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total TTC:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${totalTTC.toStringAsFixed(2)} TND', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      );

      final pdfBytes = await pdf.save();
      final fileName = 'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';

      if (kIsWeb) {
        // Web: Trigger browser download
        final blob = html.Blob([pdfBytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)..setAttribute('download', fileName)..click();
        html.Url.revokeObjectUrl(url);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF downloaded')),
        );
      } else {
        // Mobile/Desktop: Save to temporary directory
        final outputDir = await getTemporaryDirectory();
        final file = File('${outputDir.path}/$fileName');
        await file.writeAsBytes(pdfBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF saved to ${file.path}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice Preview"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share Invoice',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Share functionality coming soon!")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Print as PDF',
            onPressed: () => _generatePDF(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: InvoicePreview(
            clientName: clientName,
            clientEmail: clientEmail,
            invoiceDate: invoiceDate,
            articles: articles,
            onPrint: () => _generatePDF(context),
          ),
        ),
      ),
    );
  }
}