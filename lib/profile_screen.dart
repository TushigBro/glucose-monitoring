import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glucose_monitoring/controller/data_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DataController _dataController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1B5E53);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

            const Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/user.jpg'),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: primaryColor,
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Name and Email
            Text(
              _dataController.userData['firstName'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _dataController.userData['email'],
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // Edit Profile Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              ),
              onPressed: () {},
              child: const Text("Edit Profile", style: TextStyle(fontSize: 16)),
            ),

            const SizedBox(height: 30),

            // Info Card
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
                    const Text(
                      "Personal Information",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    infoRow(Icons.calendar_today, "Date of Birth", "5 Feb 2003",
                        primaryColor),
                    infoRow(Icons.male, "Sex", "Male", primaryColor),
                    infoRow(Icons.height, "Height", "170 cm", primaryColor),
                    infoRow(
                        Icons.monitor_weight, "Weight", "80 kg", primaryColor),
                    infoRow(
                        Icons.phone, "Contact", "+976-99119911", primaryColor),
                  ],
                ),
              ),
            ),
          ],
        ),
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
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
