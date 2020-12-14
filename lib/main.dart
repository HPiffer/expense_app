import 'dart:math';
import 'package:expenses/components/chart.dart';
import 'package:flutter/material.dart';
import 'components/transaction_list.dart';
import 'components/transaction_form.dart';
import 'models/transaction.dart';
import 'dart:io';

main(List<String> args) => runApp(ExpensesApp());

// =========================================== //
// Nome do App: Expenses App
// ------------------------------------------- //
// Dev        : Hayron S. Piffer
// Descrição  : App para despesas pessoais
// =========================================== //

// =========================================== //
// Main Application
// =========================================== //
class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

// =========================================== //
// HomePage
// =========================================== //
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

    return Scaffold(
      //* Barra Superior do App ~~
      appBar: appBar,
      //* Corpo da Aplicação ~~
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
