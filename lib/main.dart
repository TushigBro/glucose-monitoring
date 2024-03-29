import 'package:flutter/material.dart';
import 'package:glucose_monitoring/landing_screen.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Glucose Monitoring',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffF5FFFF),
        fontFamily: 'Manrope.Regular.ttf',
        useMaterial3: true,
      ),
      home: const LandingScreen(),
    );
  }
}
