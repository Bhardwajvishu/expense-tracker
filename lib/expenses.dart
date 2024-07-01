import 'package:expense_treacker/widget/chart/chart.dart';
import 'package:expense_treacker/widget/expenses_list.dart';
import 'package:expense_treacker/widget/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_treacker/models/expense.dart';
import 'package:flutter/widgets.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredList = [
    Expense(
        amount: 100.99,
        title: 'hellopwo',
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        amount: 39.09,
        title: 'theere',
        date: DateTime.now(),
        category: Category.food),
    Expense(
        amount: 5999.100,
        title: 'make',
        date: DateTime.now(),
        category: Category.travel),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredList.add(expense);
    });
    Navigator.pop(context);
  }

  void _removeExpense(Expense expense) {
    final indexOfExpense = _registeredList.indexOf(expense);
    setState(() {
      _registeredList.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredList.insert(indexOfExpense, expense);
              });
            }),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpnese(
        onAddExpense: _addExpense,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bodyWidth = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found, Start adding some!'),
    );
    if (_registeredList.isNotEmpty) {
      mainContent = ExpensesList(
        expense: _registeredList,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: bodyWidth < 600
          ? Column(
              children: [
                Chart(expenses: _registeredList),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredList),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
