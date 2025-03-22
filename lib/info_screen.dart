import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:glucose_monitoring/auth/login_screen.dart';
import 'package:glucose_monitoring/auth/register_screen.dart';
import 'package:glucose_monitoring/main_screen.dart';
import 'package:glucose_monitoring/auth/sign_up_screen3.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key, required this.username});
  final String username;
  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final List<String> choices = ['Not Set', 'Male', 'Female', 'Other'];
  int chosenIndex = 0;
  late TextEditingController controller;
  String FirstName = ' ';
  late TextEditingController controller2;
  String LastName = ' ';
  late TextEditingController controller3;
  int age = 0;
  late TextEditingController controller4;
  int weight = 0;
  late TextEditingController controller5;
  int height = 0;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
    controller4 = TextEditingController();
    controller5 = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    ;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(30.0),
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Welcome ${widget.username}',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Center(
                    child: const Text(
                      'please tell us about yourself',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Container(
                    padding: EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45.0),
                      color: Color(0xffD5F1FF),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'First Name',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w200),
                            ),
                            const Spacer(),
                            Expanded(
                              child: TextField(
                                controller: controller,
                                onSubmitted: (String value) {
                                  setState(() {
                                    FirstName = controller.text;
                                  });
                                },
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w200),
                                decoration: InputDecoration(
                                  hintText: 'Not Set',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.black,
                                      decorationColor: Colors.black),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Text(
                              'Last Name',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w200),
                            ),
                            const Spacer(),
                            Expanded(
                              child: TextField(
                                controller: controller2,
                                onSubmitted: (String value) {
                                  setState(() {
                                    LastName = controller2.text;
                                  });
                                },
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w200),
                                decoration: InputDecoration(
                                  hintText: 'Not Set',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.black,
                                      decorationColor: Colors.black),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Text(
                              'Age',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w200),
                            ),
                            const Spacer(),
                            Expanded(
                              child: TextField(
                                controller: controller3,
                                onSubmitted: (String value) {
                                  setState(() {
                                    age = controller3.hashCode;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w200),
                                decoration: InputDecoration(
                                  hintText: 'Not Set',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.black),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Text(
                              'Sex',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w200),
                            ),
                            const Spacer(),
                            InkWell(
                              child: Text(
                                choices[chosenIndex],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w200),
                              ),
                              onTap: () => _showDialog(
                                CupertinoPicker(
                                  onSelectedItemChanged: (int value) {
                                    setState(() {
                                      chosenIndex = value;
                                    });
                                  },
                                  children: List<Widget>.generate(
                                      choices.length, (index) {
                                    return Center(
                                      child: Text(choices[index],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w200)),
                                    );
                                  }),
                                  magnification: 1.22,
                                  squeeze: 1.2,
                                  useMagnifier: true,
                                  itemExtent: 64,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Text(
                              'Weight',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w200),
                            ),
                            const Spacer(),
                            Expanded(
                              child: TextField(
                                controller: controller4,
                                onSubmitted: (String value) {
                                  setState(() {
                                    weight = controller4.hashCode;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w200),
                                decoration: InputDecoration(
                                  hintText: 'Not Set',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.black),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Text(
                              'Height',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w200),
                            ),
                            const Spacer(),
                            Expanded(
                              child: TextField(
                                controller: controller5,
                                onSubmitted: (String value) {
                                  setState(() {
                                    height = controller5.hashCode;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w200),
                                decoration: InputDecoration(
                                  hintText: 'Not Set',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.black),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 130),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 57,
                      decoration: BoxDecoration(
                        color: Color(0xff00AAFF),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Center(
                        child: Text(
                          "Let's get started",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
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

  void _showDialog(Widget child) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }
}
