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
            const SizedBox(height: 250),
            Center(
              child: const Text(
                'gGauge',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'SF Pro Text',
                ),
              ),
            ),
            const SizedBox(height: 12),

            //Spacer -> Дараагийн widget хүртэлх боломжтой бүх зайг авч байгаа (Expanded)
            const Spacer(flex: 1),
            Center(
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 57,
                  width: 290,
                  decoration: BoxDecoration(
                    color: Color(0xffD5F1FF),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Center(
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 57,
                  width: 290,
                  decoration: BoxDecoration(
                    color: Color(0xff00AAFF),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Center(
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'SF Pro Text'),
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
