import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:glucose_monitoring/auth/login_screen.dart';
import 'package:glucose_monitoring/auth/register_screen.dart';
import 'package:glucose_monitoring/main_screen.dart';
import 'package:glucose_monitoring/auth/sign_up_screen3.dart';
import 'package:country_picker/country_picker.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key, required this.username});
  final String username;
  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final List<String> choices = ['Not Set', 'Male', 'Female', 'Other'];
  int chosenIndex = 0;
  final List<String> choices1 = ['Not Set', 'Yes', 'No', 'Not Certain'];
  int chosenIndex1 = 0;
  late TextEditingController controller3;
  int age = 0;
  @override
  void initState() {
    super.initState();

    controller3 = TextEditingController();
  }

  @override
  void dispose() {
    controller3.dispose();
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
                      style: TextStyle(fontSize: 32, color: Color(0xFF18786F)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: const Text(
                      "Let's fill in your details.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Form(
                    child: Column(
                      children: [
                        Row(
                          children: [
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
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              'Pregnancy',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w200),
                            ),
                            const Spacer(),
                            InkWell(
                              child: Text(
                                choices1[chosenIndex1],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w200),
                              ),
                              onTap: () => _showDialog(
                                CupertinoPicker(
                                  onSelectedItemChanged: (int value) {
                                    setState(() {
                                      chosenIndex1 = value;
                                    });
                                  },
                                  children: List<Widget>.generate(
                                      choices1.length, (index) {
                                    return Center(
                                      child: Text(choices1[index],
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
                        color: Color(0xFF18786F),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Center(
                        child: Text(
                          "Continue",
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
