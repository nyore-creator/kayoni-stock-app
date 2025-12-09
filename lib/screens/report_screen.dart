import 'package:flutter/material.dart';
import '../services/api.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Map<String, dynamic> matrix = {};
  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      matrix = await Api.report();
    } catch (e) {
      error = e.toString();
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _printReport() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Kayoni Graphics Stock Report',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              ...matrix.entries.map((e) {
                final m = e.value as Map<String, dynamic>;
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(e.key,
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        'Purchased Qty: ${m['purchasedQty']} @ Ksh ${m['purchaseCostPerItem']} | Total Purchase: Ksh ${m['totalPurchaseCost']}'),
                    pw.Text(
                        'Sold Qty: ${m['soldQty']} @ Ksh ${m['salePricePerItem']} | Total Sales: Ksh ${m['totalSalesRevenue']}'),
                    pw.Text(
                        'Remaining Qty: ${m['remainingQty']} | Remaining Value: Ksh ${m['remainingValue']}'),
                    pw.Text(
                        'COGS: Ksh ${m['cogs']} | Profit: Ksh ${m['profit']}'),
                    pw.SizedBox(height: 8),
                  ],
                );
              }).toList()
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(child: Text(error!));
    }
    if (matrix.isEmpty) {
      return const Center(child: Text('No data yet'));
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ElevatedButton(
                  onPressed: _loadReport, child: const Text('Refresh report')),
              const SizedBox(width: 12),
              OutlinedButton(
                  onPressed: _printReport, child: const Text('Print'))
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: matrix.entries.map((e) {
              final m = e.value as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.key,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      _row('Purchased Qty', '${m['purchasedQty']}'),
                      _row('Cost per item', 'Ksh ${m['purchaseCostPerItem']}'),
                      _row('Total purchase cost',
                          'Ksh ${m['totalPurchaseCost']}'),
                      _row('Sold Qty', '${m['soldQty']}'),
                      _row('Sale price per item',
                          'Ksh ${m['salePricePerItem']}'),
                      _row('Total sales revenue',
                          'Ksh ${m['totalSalesRevenue']}'),
                      _row('Remaining Qty', '${m['remainingQty']}'),
                      _row('Remaining Value', 'Ksh ${m['remainingValue']}'),
                      _row('COGS', 'Ksh ${m['cogs']}'),
                      _row('Profit', 'Ksh ${m['profit']}'),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
