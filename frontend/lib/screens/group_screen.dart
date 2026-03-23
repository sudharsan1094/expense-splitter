import 'package:flutter/material.dart';
import '../models/group.dart';
import '../models/expense.dart';
import '../services/api_service.dart';
import 'add_expense_screen.dart';

class GroupScreen extends StatefulWidget {
  final Group group;
  const GroupScreen({super.key, required this.group});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<Expense> _expenses = [];
  Map<String, double> _balances = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final expenses = await ApiService.getExpenses(widget.group.id);
    final balances = await ApiService.getBalances(widget.group.id);
    setState(() {
      _expenses = expenses;
      _balances = balances;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balances card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Balances',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          if (_balances.isEmpty)
                            const Text('No expenses yet')
                          else
                            ..._balances.entries.map((e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(e.key,
                                          style: const TextStyle(fontSize: 16)),
                                      Text(
                                        '₹${e.value.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: e.value >= 0
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Expenses list
                  const Text('Expenses',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (_expenses.isEmpty)
                    const Text('No expenses added yet')
                  else
                    ..._expenses.map((e) => Card(
                          child: ListTile(
                            title: Text(e.description),
                            subtitle: Text('Paid by ${e.paidBy}'),
                            trailing: Text(
                              '₹${e.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddExpenseScreen(group: widget.group),
          ),
        ).then((_) => _loadData()),
        child: const Icon(Icons.add),
      ),
    );
  }
}