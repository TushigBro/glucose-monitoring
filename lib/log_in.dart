import 'package:flutter/material.dart';

//StatefulWidget -> Ямар нэгэн төлвийн өөрчлөлт ордог.
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 128),
            Center(
              child: Text(
                'Welcome! Lets log in!',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('E-mail'),
            TextField(
              onChanged: (value) {
                print(value);
              },
            ),
            const SizedBox(height: 12),
            Text('Password'),
            TextField(
              obscureText: true,
              onChanged: (value) {
                print(value);
              },
            ),
            //Spacer -> Дараагийн widget хүртэлх боломжтой бүх зайг авч байгаа (Expanded)
            const Spacer(flex: 1),
            Center(
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 42,
                  width: 128,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      'Нэвтрэх',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
