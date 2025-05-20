import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glucose_monitoring/controller/data_controller.dart';
import 'package:glucose_monitoring/auth/login_screen.dart';
import 'package:glucose_monitoring/landing_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DataController _dataController = Get.put(DataController());
  bool _isEditing = false;

  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController contactController;

  @override
  void initState() {
    super.initState();
    heightController = TextEditingController();
    weightController = TextEditingController();
    contactController = TextEditingController();

    ever<Map<String, dynamic>?>(
      _dataController.userData,
      (data) {
        if (data != null && !_isEditing) {
          heightController.text = data['height'] ?? '';
          weightController.text = data['weight'] ?? '';
          contactController.text = data['contact'] ?? '';
        }
      },
    );
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1B5E53);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          final userData = _dataController.userData.value;
          if (userData == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/user.jpg'),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: primaryColor,
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData['firstName'] ?? '',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userData['email'] ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 12),
                    ),
                    onPressed: () {
                      if (_isEditing) {
                        final updatedData = {
                          ...userData,
                          'height': heightController.text,
                          'weight': weightController.text,
                          'contact': contactController.text,
                        };
                        _dataController.setUserData(updatedData);
                      }

                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child: Text(
                      _isEditing ? "Save" : "Edit Profile",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Personal Information",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 20),
                          infoRow(Icons.cake, "Age",
                              userData['age']?.toString() ?? '', primaryColor),
                          infoRow(Icons.male, "Sex", userData['sex'] ?? '',
                              primaryColor),
                          _isEditing
                              ? editableRow(
                                  Icons.height, "Height", heightController)
                              : infoRow(Icons.height, "Height",
                                  userData['height'] ?? '', primaryColor),
                          _isEditing
                              ? editableRow(Icons.monitor_weight, "Weight",
                                  weightController)
                              : infoRow(Icons.monitor_weight, "Weight",
                                  userData['weight'] ?? '', primaryColor),
                          _isEditing
                              ? editableRow(
                                  Icons.phone, "Contact", contactController)
                              : infoRow(Icons.phone, "Contact",
                                  userData['contact'] ?? '', primaryColor),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      _showLogoutConfirmationDialog(context);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Log Out',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget infoRow(IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }

  Widget editableRow(
      IconData icon, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1B5E53)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 15)),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel"),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xff22C55E),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _dataController.clearUserData();

              // Clear all routes and go to LandingScreen
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LandingScreen()),
                (route) => false,
              );
            },
            child: const Text("Log Out"),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFDA2C38), // Set text color
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
