import 'package:flutter/material.dart';
import 'package:glucose_monitoring/info_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String username = '';
  String password = '';
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
                    'Sign up',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                  ),
                  const Text(
                    "Let's fill in your details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                  ),
                  const SizedBox(height: 60),
                  TextField(
                    onChanged: (value) {
                      username = value;
                    },
                    decoration: InputDecoration(
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
                      hintText: 'password',
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
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(fontWeight: FontWeight.w200),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 70),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InfoScreen(username: username)));
                    },
                    child: Container(
                      height: 57,
                      decoration: BoxDecoration(
                        color: Color(0xFF18786F),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Center(
                        child: Text(
                          'Sign up',
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
