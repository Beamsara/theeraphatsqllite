import 'package:flutter/material.dart';
import 'package:theeraphatsqllite/pages/sqlite_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQL Lite',
      home: SqlitePage(),
    );
  }
}



