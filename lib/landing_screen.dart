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
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              //Asset-aas zurag unshih
              Image.asset(
                'assets/images/logo.png',
                height: 159,
                width: 113,
              ),
              const Text(
                'gGauge',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff086A61)),
              ),
              Text.rich(
                textAlign: TextAlign.center,
                const TextSpan(
                  text:
                      'for diabetic patients that who \n needs control over their \n',
                  children: [
                    TextSpan(
                        text: 'glucose',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
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
                    color: Color(0xFF18786F),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
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
