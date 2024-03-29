import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
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
              style:
                  TextStyle(fontSize: 16, fontFamily: 'Manrope-ExtraLight.ttf'),
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
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 100),
            InkWell(
              child: Container(
                height: 57,
                decoration: BoxDecoration(
                  color: Color(0xff00AAFF),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                  child: Text(
                    'Log In',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
