import 'package:flutter/material.dart';
import 'package:glucose_monitoring/auth/login_screen.dart';
import 'package:glucose_monitoring/auth/register_screen.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _emailController = TextEditingController();
  String email = ' ';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                    'Forgot your password?',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff086A61)),
                  ),
                  const Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text:
                          'Please enter your email for a password resetting \n',
                      style:
                          TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                      children: [
                        TextSpan(
                            text: 'link.',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: const Color(0xFF18786F),
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Email address',
                      hintStyle: TextStyle(fontWeight: FontWeight.w200),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF18786F))),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    child: Container(
                      height: 57,
                      decoration: BoxDecoration(
                        color: const Color(0xFF18786F),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: const Center(
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
    );
  }
}
