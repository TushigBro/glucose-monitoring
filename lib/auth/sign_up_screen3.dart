import 'package:flutter/material.dart';
import 'package:glucose_monitoring/auth/register_screen.dart';
import 'package:glucose_monitoring/info_screen.dart';

class SignUpScreen3 extends StatefulWidget {
  const SignUpScreen3({super.key, required this.email, required this.password});
  final String email;
  final String password;
  @override
  State<SignUpScreen3> createState() => _SignUpScreen3State();
}

class _SignUpScreen3State extends State<SignUpScreen3> {
  String first_name = ' ';
  String last_name = ' ';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 182),
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff086A61)),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Please fill in your details.',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                    ),
                    const SizedBox(height: 50),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        if (!RegExp(r"^[a-zA-Z'-]{2,}$").hasMatch(value)) {
                          return 'Invalid characters or too short';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          first_name = value;
                        });
                        _formKey.currentState!.validate();
                      },
                      obscureText: false,
                      decoration: const InputDecoration(
                          hintText: 'First name',
                          hintStyle: TextStyle(fontWeight: FontWeight.w200),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xFF18786F)))),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        if (!RegExp(r"^[a-zA-Z'-]{2,}$").hasMatch(value)) {
                          return 'Invalid characters or too short';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          last_name = value;
                        });
                        _formKey.currentState!.validate();
                      },
                      obscureText: false,
                      decoration: const InputDecoration(
                          hintText: 'Last name',
                          hintStyle: TextStyle(fontWeight: FontWeight.w200),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xFF18786F)))),
                    ),
                    const SizedBox(height: 15),
                    const Center(
                      child: Text(
                        'Please fill your real information.',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w200),
                      ),
                    ),
                    const SizedBox(height: 25),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InfoScreen(
                                firstName: first_name,
                                lastName: last_name,
                                password: widget.password,
                                email: widget.email),
                          ),
                        );
                      },
                      child: Container(
                        height: 57,
                        decoration: BoxDecoration(
                          color: const Color(0xFF18786F),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: const Center(
                          child: Text(
                            'Continue',
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
      ),
    );
  }
}
