import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glucose_monitoring/auth/login_screen.dart';
import 'package:glucose_monitoring/auth/register_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key, required this.username});
  final String username;
  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final List<String> choices = ['Not Set', 'Male', 'Female', 'Other'];
  int chosenIndex = 0;
  final TextEditingController first_name_controller = TextEditingController();
  final FocusNode first_name_focus = FocusNode();
  @override
  void initState() {
    first_name_controller.text = 'Not Set';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                  ),
                ),
                const SizedBox(height: 150),
                Column(
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
                          child: EditableText(
                            controller: first_name_controller,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w200,
                                color: Colors.black),
                            focusNode: first_name_focus,
                            cursorColor: Color(0xff00AAFF),
                            backgroundCursorColor: Color(0xff00AAFF),
                            selectionColor: Colors.black,
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
                        const Text(
                          'Not Set',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w200),
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
                        const Text('Not Set',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w200)),
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
                              children: List<Widget>.generate(choices.length,
                                  (index) {
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
                        const Text('Not Set',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w200)),
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
                        const Text('Not Set',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w200)),
                      ],
                    ),
                  ],
                ),
              ],
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
