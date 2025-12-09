import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl =
      'http://localhost:5000'; // change to deployed URL

  static Future<void> stockIn(
      String itemName, int quantity, double price) async {
    final res = await http.post(
      Uri.parse('$baseUrl/stock/in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'itemName': itemName, 'quantity': quantity, 'price': price}),
    );
    if (res.statusCode != 201) {
      throw Exception('Failed to record stock in: ${res.body}');
    }
  }

  static Future<void> stockOut(
      String itemName, int quantity, double price) async {
    final res = await http.post(
      Uri.parse('$baseUrl/stock/out'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'itemName': itemName, 'quantity': quantity, 'price': price}),
    );
    if (res.statusCode != 201) {
      throw Exception('Failed to record stock out: ${res.body}');
    }
  }

  static Future<Map<String, dynamic>> report() async {
    final res = await http.get(Uri.parse('$baseUrl/stock/report'));
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch report: ${res.body}');
    }
    return jsonDecode(res.body)['matrix'] as Map<String, dynamic>;
  }
}
