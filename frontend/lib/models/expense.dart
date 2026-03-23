class Expense {
  final String id;
  final String description;
  final double amount;
  final String paidBy;
  final List<String> splitAmong;

  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.splitAmong,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['_id'],
      description: json['description'],
      amount: (json['amount'] as num).toDouble(),
      paidBy: json['paidBy'],
      splitAmong: List<String>.from(json['splitAmong']),
    );
  }
}