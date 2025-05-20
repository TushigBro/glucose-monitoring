import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:glucose_monitoring/api_wrapper.dart';
import 'package:glucose_monitoring/auth/forgot_screen.dart';
import 'package:glucose_monitoring/auth_service.dart';
import 'package:glucose_monitoring/controller/data_controller.dart';
import 'package:glucose_monitoring/info_screen.dart';
import 'package:glucose_monitoring/main_screen.dart';
import 'package:glucose_monitoring/auth/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                      const Center(
                        child: Text(
                          'gGauge',
                          style:
                              TextStyle(fontSize: 32, color: Color(0xff086A61)),
                        ),
                      ),
                      const Center(
                        child: Text(
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
                        decoration: const InputDecoration(
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
                        decoration: const InputDecoration(
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
                        child: const Center(
                          child: Text(
                            'Forgot your password?',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              Response response = await AuthService().login(
                                email: username,
                                password: password,
                              );
                              DataController dataController =
                                  Get.put(DataController());
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setString(
                                  'accessToken', response.data['access_token']);
                              dataController.setUserData(response.data['user']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),
                              );
                            } catch (err) {
                              String errorMessage =
                                  'Login failed. Please try again.';
                              if (err is DioError) {
                                errorMessage = err.response?.data['message'] ??
                                    err.message;
                              }

                              final snackBar = SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.white,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                content: Row(
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: Color(0xFFB00020)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        errorMessage,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                duration: const Duration(seconds: 3),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        },
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
                                child: const Text(
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
