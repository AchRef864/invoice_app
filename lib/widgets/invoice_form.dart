import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class InvoiceForm extends StatelessWidget {
  final TextEditingController clientNameController;
  final TextEditingController clientEmailController;
  final DateTime invoiceDate;
  final Function(DateTime) onDateChanged;

  const InvoiceForm({
    super.key,
    required this.clientNameController,
    required this.clientEmailController,
    required this.invoiceDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: clientNameController,
            decoration: InputDecoration(
              labelText: "Client Name",
              hintText: "Enter client name",
              prefixIcon: const Icon(Icons.person, size: 20, color: Colors.black54),
              labelStyle: GoogleFonts.poppins(color: Colors.black54),
              errorText: clientNameController.text.isEmpty ? "Client name is required" : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
            style: GoogleFonts.poppins(),
            onChanged: (_) => (context as Element).markNeedsBuild(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: clientEmailController,
            decoration: InputDecoration(
              labelText: "Client Email",
              hintText: "Enter client email",
              prefixIcon: const Icon(Icons.email, size: 20, color: Colors.black54),
              labelStyle: GoogleFonts.poppins(color: Colors.black54),
              errorText: clientEmailController.text.isEmpty
                  ? "Email is required"
                  : !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(clientEmailController.text)
                      ? "Enter a valid email"
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
            style: GoogleFonts.poppins(),
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => (context as Element).markNeedsBuild(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                "Invoice Date: ",
                style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: invoiceDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Colors.black,
                            onPrimary: Colors.white,
                            surface: Colors.white,
                          ),
                          dialogBackgroundColor: Colors.white,
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) onDateChanged(picked);
                },
                child: Text(
                  dateFormat.format(invoiceDate),
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}