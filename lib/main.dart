import 'package:flutter/material.dart';
import 'services/api.dart';
import 'widgets/stock_in_form.dart';
import 'widgets/stock_out_form.dart';
import 'screens/report_screen.dart';

void main() {
  runApp(const KayoniApp());
}

class KayoniApp extends StatelessWidget {
  const KayoniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kayoni Stock Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _handleStockIn(String item, int qty, double price) async {
    try {
      await Api.stockIn(item, qty, price);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _handleStockOut(String item, int qty, double price) async {
    try {
      await Api.stockOut(item, qty, price);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  int _currentIndex = 0;

  final _pages = const [
    _EntryPage(),
    ReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayoni Graphics - Stock Manager')),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.playlist_add), label: 'Entry'),
          NavigationDestination(icon: Icon(Icons.assessment), label: 'Report'),
        ],
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _EntryPage extends StatelessWidget {
  const _EntryPage();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_HomePageState>()!;
    return SingleChildScrollView(
      child: Column(
        children: [
          StockInForm(onSubmit: state._handleStockIn),
          StockOutForm(onSubmit: state._handleStockOut),
        ],
      ),
    );
  }
}
