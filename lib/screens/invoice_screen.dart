import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/article.dart';
import '../widgets/article_item.dart';
import '../widgets/invoice_form.dart';
import 'invoice_preview_screen.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController clientEmailController = TextEditingController();
  DateTime invoiceDate = DateTime.now();
  List<Article> articles = [];

  double get totalHT => articles.fold(0.0, (sum, a) => sum + a.totalHT);
  double get tva => totalHT * 0.2;
  double get totalTTC => totalHT + tva;

  void addArticle() => setState(() => articles.add(Article()));
  void removeArticle(int index) => setState(() => articles.removeAt(index));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Invoice",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey[50]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: InvoiceForm(
                      clientNameController: clientNameController,
                      clientEmailController: clientEmailController,
                      invoiceDate: invoiceDate,
                      onDateChanged: (newDate) => setState(() => invoiceDate = newDate),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Articles",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
            ),
            const SizedBox(height: 16),
            ...articles.asMap().entries.map((entry) => AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: ArticleItem(
                    article: entry.value,
                    onDelete: () => removeArticle(entry.key),
                    onUpdate: () => setState(() {}),
                  ),
                )),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: addArticle,
                icon: const Icon(Icons.add, size: 20),
                label: Text(
                  "Add Article",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
            const SizedBox(height: 32),
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey[50]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total HT", style: Theme.of(context).textTheme.titleLarge),
                            Text("${totalHT.toStringAsFixed(2)} TND", style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("TVA (20%)", style: Theme.of(context).textTheme.bodyMedium),
                            Text("${tva.toStringAsFixed(2)} TND", style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total TTC",
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "${totalTTC.toStringAsFixed(2)} TND",
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: clientNameController.text.isNotEmpty &&
                        clientEmailController.text.isNotEmpty &&
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(clientEmailController.text) &&
                        articles.isNotEmpty &&
                        articles.every((a) => a.description.isNotEmpty && a.quantity > 0 && a.priceHT > 0)
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvoicePreviewScreen(
                              clientName: clientNameController.text,
                              clientEmail: clientEmailController.text,
                              invoiceDate: invoiceDate,
                              articles: articles,
                            ),
                          ),
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  disabledForegroundColor: Colors.grey[600],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
                child: Text(
                  "Preview Invoice",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}