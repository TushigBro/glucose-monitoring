import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DataController extends GetxController {
  final Rx<Map<String, dynamic>?> userData = Rx<Map<String, dynamic>?>(null);
  static const String _userDataKey = 'user_data';

  static const String backendBaseUrl =
      'https://undergraduate-project-ry8h.onrender.com/api';

  void setUserData(Map<String, dynamic> data) async {
    userData.value = data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_userDataKey, jsonEncode(data));

    await updateUserDataToBackend(data);
  }

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
    await loadUserData();

    if (userData.value == null) {
      userData.value = {
        'id': '',
        'firstName': '',
        'lastName': '',
        'email': '',
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

  void clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
    userData.value = null;
  }

  Future<void> updateUserDataToBackend(Map<String, dynamic> updatedData) async {
    try {
      final userId = updatedData['id'];
      if (userId == null || userId.isEmpty) return;

      final url = Uri.parse('$backendBaseUrl/users/$userId');

      final body = jsonEncode({
        'height': updatedData['height'],
        'weight': updatedData['weight'],
        'contact': updatedData['contact'],
      });

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 201) {
        print(
            'Failed to update user data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print("Error updating user data to backend: $e");
    }
  }
}
