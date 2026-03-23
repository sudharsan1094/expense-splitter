import 'package:flutter/material.dart';
import '../models/group.dart';
import '../services/api_service.dart';

class AddExpenseScreen extends StatefulWidget {
  final Group group;
  const AddExpenseScreen({super.key, required this.group});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  String? _paidBy;
  List<String> _selectedMembers = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedMembers = List.from(widget.group.members);
    _paidBy = widget.group.members.first;
  }

  Future<void> _submit() async {
    final desc = _descController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());

    if (desc.isEmpty || amount == null || _selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _saving = true);

    await ApiService.addExpense(
      groupId: widget.group.id,
      description: desc,
      amount: amount,
      paidBy: _paidBy!,
      splitAmong: _selectedMembers,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (₹)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Paid by:', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _paidBy,
              isExpanded: true,
              items: widget.group.members
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (val) => setState(() => _paidBy = val),
            ),
            const SizedBox(height: 16),
            const Text('Split among:', style: TextStyle(fontSize: 16)),
            ...widget.group.members.map((m) => CheckboxListTile(
                  title: Text(m),
                  value: _selectedMembers.contains(m),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedMembers.add(m);
                      } else {
                        _selectedMembers.remove(m);
                      }
                    });
                  },
                )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _submit,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _saving
                    ? const CircularProgressIndicator()
                    : const Text('Add Expense',
                        style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}