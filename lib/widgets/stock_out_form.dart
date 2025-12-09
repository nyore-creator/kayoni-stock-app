import 'package:flutter/material.dart';

class StockOutForm extends StatefulWidget {
  final void Function(String itemName, int quantity, double price) onSubmit;
  const StockOutForm({super.key, required this.onSubmit});

  @override
  State<StockOutForm> createState() => _StockOutFormState();
}

class _StockOutFormState extends State<StockOutForm> {
  final _formKey = GlobalKey<FormState>();
  final _itemController = TextEditingController();
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _itemController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Stock Out',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _itemController,
                decoration: const InputDecoration(labelText: 'Item name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter item name' : null,
              ),
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(labelText: 'Quantity sold'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Enter a valid quantity';
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                    labelText: 'Selling price per item (Ksh)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final p = double.tryParse(v ?? '');
                  if (p == null || p < 0) return 'Enter a valid price';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit(
                      _itemController.text.trim(),
                      int.parse(_qtyController.text.trim()),
                      double.parse(_priceController.text.trim()),
                    );
                    _itemController.clear();
                    _qtyController.clear();
                    _priceController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Stock Out recorded')),
                    );
                  }
                },
                child: const Text('Record sale'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
