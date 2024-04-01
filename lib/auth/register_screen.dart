import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                  'Sign up',
                  style: TextStyle(fontSize: 32, fontFamily: 'Manrope'),
                ),
                const Text(
                  'Please sign up to continue',
                  style: TextStyle(fontSize: 16, fontFamily: 'Manrope'),
                ),
                const SizedBox(height: 60),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    hintText: 'username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Confirm your password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 70),
                InkWell(
                  child: Container(
                    height: 57,
                    decoration: BoxDecoration(
                      color: Color(0xff00AAFF),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: Colors.black),
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
