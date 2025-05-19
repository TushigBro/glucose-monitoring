// data_controller.dart - Updated version
import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataController extends GetxController {
  // Store the user data as an observable map
  final Rx<Map<String, dynamic>?> userData = Rx<Map<String, dynamic>?>(null);

  // Key for SharedPreferences storage
  static const String _userDataKey = 'user_data';

  // Save user data to both memory and SharedPreferences
  void setUserData(Map<String, dynamic> data) async {
    userData.value = data;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert map to JSON string for reliable storage
    await prefs.setString(_userDataKey, jsonEncode(data));
  }

  // Retrieve user data from SharedPreferences
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString(_userDataKey);

    if (userDataJson != null) {
      userData.value = jsonDecode(userDataJson);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    loadUserData();

    // Load existing user data from SharedPreferences
    await loadUserData();

    // If no data found, set default structure (for demo purposes)
    if (userData.value == null) {
      userData.value = {
        'id': '',
        'firstName': '',
        'lastName': '',
        'email': '',
        'dob': '',
        'sex': '',
        'height': '',
        'weight': '',
        'contact': '',
        'nationality': '',
        'pregnancy': '',
        'age': '',
      };
    }
  }

  // Clear user data (for logout functionality)
  void clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
    userData.value = null;
  }
}
