import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataController extends GetxController {
  // Store the user data as an observable map
  final Rx<Map<String, dynamic>?> userData = Rx<Map<String, dynamic>?>(null);

  void setUserData(Map<String, dynamic> data) async {
    userData.value = data;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user', <String>[
      data['id'] ?? '',
      data['email'] ?? '',
      data['firstName'] ?? '',
      data['lastName'] ?? '',
      data['nationality'] ?? '',
      data['sex'] ?? '',
      data['pregnancy'] ?? '',
      data['age'] ?? '',
    ]);
  }

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 2), () {
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
    });
  }
}
