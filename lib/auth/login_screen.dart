import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glucose_monitoring/api_wrapper.dart';
import 'package:glucose_monitoring/auth/forgot_screen.dart';
import 'package:glucose_monitoring/info_screen.dart';
import 'package:glucose_monitoring/main_screen.dart';
import 'package:glucose_monitoring/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = ' ';
  String password = ' ';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 120),
                      Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 110,
                          width: 80,
                        ),
                      ),
                      Center(
                        child: const Text(
                          'gGauge',
                          style:
                              TextStyle(fontSize: 32, color: Color(0xff086A61)),
                        ),
                      ),
                      Center(
                        child: const Text(
                          "Let's be healthy",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w200),
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        onChanged: (value) {
                          username = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          }
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return "Enter valid email.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Email address',
                          hintStyle: TextStyle(fontWeight: FontWeight.w200),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF18786F))),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(fontWeight: FontWeight.w200),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF18786F)))),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotScreen(),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            'Forgot your password?',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            //handleApiCall(
                            //apiCall: () {}, loadingMessage: "Loading..");
                            if (username == 'admin' && password == 'admin') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),
                              );
                            }
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
                      const SizedBox(height: 25),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'Are you new? ',
                            children: [
                              WidgetSpan(
                                  child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen()),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff086A61)),
                                ),
                              )),
                            ],
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
      ),
    );
  }
}
