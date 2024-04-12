import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glucose_monitoring/auth/login_screen.dart';
import 'package:glucose_monitoring/auth/register_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key, required this.username});
  final String username;
  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
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
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    'Welcome ${widget.username}',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: const Text(
                    'please tell us about yourself',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                  ),
                ),
                const SizedBox(height: 150),
                Container(
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
                          const Text('Not Set',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w200)),
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
                          CupertinoPicker(
                            itemExtent: 64,
                            children: [],
                            onSelectedItemChanged: (index) {},
                          ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
