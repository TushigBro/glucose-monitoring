import 'package:flutter/material.dart';
import 'package:glucose_monitoring/info_screen.dart';
import 'package:glucose_monitoring/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = ' ';
  String password = ' ';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 182),
                const Text(
                  'Log in',
                  style: TextStyle(fontSize: 32),
                ),
                const Text(
                  'Please log in to continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                ),
                const SizedBox(height: 60),
                TextField(
                  onChanged: (value) {
                    username = value;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    hintText: 'username',
                    hintStyle: TextStyle(fontWeight: FontWeight.w200),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'password',
                      hintStyle: TextStyle(fontWeight: FontWeight.w200),
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 100),
                InkWell(
                  onTap: () {
                    if (username == 'admin' && password == 'admin') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InfoScreen(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 57,
                    decoration: BoxDecoration(
                      color: Color(0xff00AAFF),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Center(
                      child: Text(
                        'Log In',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
