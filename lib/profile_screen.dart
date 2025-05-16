import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controller/data_controller.dart';
import 'package:glucose_monitoring/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DataController _dataController = Get.put(DataController());
  bool _isEditing = false;

  late TextEditingController dobController;
  late TextEditingController sexController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController contactController;

  @override
  void initState() {
    super.initState();
    dobController = TextEditingController();
    sexController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    contactController = TextEditingController();

    ever<Map<String, dynamic>?>(
      _dataController.userData,
      (data) {
        if (data != null && !_isEditing) {
          dobController.text = data['dob'] ?? '';
          sexController.text = data['sex'] ?? '';
          heightController.text = data['height'] ?? '';
          weightController.text = data['weight'] ?? '';
          contactController.text = data['contact'] ?? '';
        }
      },
    );
  }

  @override
  void dispose() {
    dobController.dispose();
    sexController.dispose();
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
                        _dataController.userData.value = {
                          ...userData,
                          'dob': dobController.text,
                          'sex': sexController.text,
                          'height': heightController.text,
                          'weight': weightController.text,
                          'contact': contactController.text,
                        };
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
                          _isEditing
                              ? editableRow(Icons.calendar_today,
                                  "Date of Birth", dobController)
                              : infoRow(Icons.calendar_today, "Date of Birth",
                                  userData['dob'] ?? '', primaryColor),
                          _isEditing
                              ? editableRow(Icons.male, "Sex", sexController)
                              : infoRow(Icons.male, "Sex",
                                  userData['sex'] ?? '', primaryColor),
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
                  const SizedBox(height: 30),
                  // Log Out Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Replace this with your actual logout logic
                      // Example: _dataController.logout(); or Get.offAll(LoginScreen());
                      Get.defaultDialog(
                        title: "Log Out",
                        middleText: "Are you sure you want to log out?",
                        confirm: ElevatedButton(
                          onPressed: () {
                            // Perform logout logic here
                            // Clear data and navigate to login screen
                            _dataController.userData.value = null;
                            Get.offAllNamed(
                                '/login'); // Or use your LoginScreen widget
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text("Yes"),
                        ),
                        cancel: TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Cancel"),
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Log Out",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
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
                if (label == "Date of Birth")
                  GestureDetector(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        controller.text =
                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: controller,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          border: UnderlineInputBorder(),
                          hintText: "YYYY-MM-DD",
                        ),
                      ),
                    ),
                  )
                else if (label == "Sex")
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      controller.text,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  TextField(
                    controller: controller,
                    keyboardType: (label == "Height" ||
                            label == "Weight" ||
                            label == "Contact")
                        ? TextInputType.number
                        : TextInputType.text,
                    inputFormatters: (label == "Height" ||
                            label == "Weight" ||
                            label == "Contact")
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : null,
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
}
