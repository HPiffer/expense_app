import 'package:expenses/app/pages/home_page.dart';
import 'package:flutter/material.dart';

// =========================================== //
// Main Application
// =========================================== //
class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildThemeData(),
      home: MyHomePage(),
    );
  }

  // =========================================== //
  // Personal Theme
  // =========================================== //
  ThemeData buildThemeData() {
    return ThemeData(
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
    );
  }
}
