import 'package:flutter/material.dart';
import 'package:glucose_monitoring/auth/login_screen.dart';
import 'package:glucose_monitoring/auth/register_screen.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Welcome',
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 20),
                const Text(
                  'please tell us about yourself',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
