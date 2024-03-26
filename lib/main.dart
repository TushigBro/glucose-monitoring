import 'package:flutter/material.dart';
import 'package:glucose_monitoring/log_in.dart';

//Хамгийн эхэнд ажиллана.
void main() {
  runApp(const MyApp());
}

//StatelessWidget -> Ямар нэгэн төлвийн өөрчлөлт орохгүй.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Widget-ыг зурах функц
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glucose Monitoring',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
