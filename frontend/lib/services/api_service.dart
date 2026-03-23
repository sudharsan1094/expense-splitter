import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/group.dart';
import '../models/expense.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // ── Groups ──────────────────────────────────────

  static Future<List<Group>> getGroups() async {
    final res = await http.get(Uri.parse('$baseUrl/groups'));
    final List data = jsonDecode(res.body);
    return data.map((g) => Group.fromJson(g)).toList();
  }

  static Future<Group> createGroup(String name, List<String> members) async {
    final res = await http.post(
      Uri.parse('$baseUrl/groups'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'members': members}),
    );
    return Group.fromJson(jsonDecode(res.body));
  }

  // ── Expenses ─────────────────────────────────────

  static Future<List<Expense>> getExpenses(String groupId) async {
    final res = await http.get(Uri.parse('$baseUrl/expenses/$groupId'));
    final List data = jsonDecode(res.body);
    return data.map((e) => Expense.fromJson(e)).toList();
  }

  static Future<void> addExpense({
    required String groupId,
    required String description,
    required double amount,
    required String paidBy,
    required List<String> splitAmong,
  }) async {
    await http.post(
      Uri.parse('$baseUrl/expenses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'groupId': groupId,
        'description': description,
        'amount': amount,
        'paidBy': paidBy,
        'splitAmong': splitAmong,
      }),
    );
  }

  // ── Balances ─────────────────────────────────────

  static Future<Map<String, double>> getBalances(String groupId) async {
    final res = await http.get(
        Uri.parse('$baseUrl/expenses/$groupId/balances'));
    final Map<String, dynamic> data = jsonDecode(res.body);
    return data.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }
}