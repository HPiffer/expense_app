import 'dart:io';
import 'dart:math';

import 'package:expenses/app/components/chart.dart';
import 'package:expenses/app/components/transaction_form.dart';
import 'package:expenses/app/components/transaction_list.dart';
import 'package:expenses/app/models/transaction.dart';
import 'package:flutter/material.dart';

// =========================================== //
// HomePage
// =========================================== //
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // =========================================== //
  // Declarations
  // =========================================== //
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  // =========================================== //
  // Functions
  // =========================================== //
  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        //* Form de transações ~~
        return TransactionForm(onSubmit: _addTransaction);
      },
    );
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    //* Alterando lista de transações ~~
    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  List<Transaction> get _recentTransaction {
    return _transactions.where((tr) {
      return tr.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  // =========================================== //
  // Screen
  // =========================================== //
  @override
  Widget build(BuildContext context) {
    // =========================================== //
    // Build Declarations
    // =========================================== //
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text('Despesas Pessoais'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context),
        ),
        if (isLandscape)
          IconButton(
            icon: Icon(_showChart ? Icons.list : Icons.bar_chart),
            onPressed: () => setState(() => _showChart = !_showChart),
          ),
      ],
    );

    final availabeHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    // =========================================== //
    // Widget
    // =========================================== //
    return Scaffold(
      //* Barra Superior do App ~~
      appBar: appBar,
      //* Corpo da Aplicação ~~
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //* Grafico
            if (_showChart || !isLandscape)
              Container(
                height: availabeHeight * (isLandscape ? 0.8 : 0.3),
                child: Chart(recentTransaction: _recentTransaction),
              ),
            //* Lista de transações ~~
            if (!_showChart || !isLandscape)
              Container(
                height: availabeHeight * (isLandscape ? 1 : 0.7),
                child: TransactionList(
                  transaction: _transactions,
                  onRemove: _removeTransaction,
                ),
              ),
          ],
        ),
      ),
      //* Botão para adicionar transação ~~
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _openTransactionFormModal(context),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
