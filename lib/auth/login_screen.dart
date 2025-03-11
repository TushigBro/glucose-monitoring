import 'package:flutter/cupertino.dart';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 130),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 159,
                      width: 113,
                    ),
                    const Text(
                      'gGauge',
                      style: TextStyle(fontSize: 32),
                    ),
                    const Text(
                      'Lets be healthy',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                    ),
                    const SizedBox(height: 90),
                    TextField(
                      onChanged: (value) {
                        username = value;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        hintText: 'Email address',
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
                          hintText: 'Password',
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
                              builder: (context) => const MainScreen(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 57,
                        decoration: BoxDecoration(
                          color: Color(0xFF18786F),
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
        ),
      ),
    );
  }
}
