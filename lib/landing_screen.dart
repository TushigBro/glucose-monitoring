import 'package:flutter/material.dart';
import 'package:glucose_monitoring/auth/login_screen.dart';
import 'package:glucose_monitoring/auth/register_screen.dart';

//StatefulWidget -> Ямар нэгэн төлвийн өөрчлөлт ордог.
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              //Asset-aas zurag unshih
              Image.asset(
                'assets/images/logo.png',
                height: 159,
                width: 113,
              ),
              const Text(
                'gGauge',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              //Spacer -> Дараагийн widget хүртэлх боломжтой бүх зайг авч байгаа (Expanded)
              const Spacer(flex: 1),
              InkWell(
                onTap: () {
                  //Login screen ruu usrene
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 57,
                  width: 290,
                  decoration: BoxDecoration(
                    color: Color(0xffD5F1FF),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Log In',
                      style: TextStyle(
                          color: Color(0xff00AAFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  //Navigator
                  //Register screen ruu usrene
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 57,
                  width: 290,
                  decoration: BoxDecoration(
                    color: Color(0xff00AAFF),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Center(
                    child: Text(
                      'Sign Up',
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
    );
  }
}
