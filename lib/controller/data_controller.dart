import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:shared_preferences/shared_preferences.dart';

class DataController extends GetxController {
  final Rx<dynamic> _userData = Rx<dynamic>(null);
  dynamic get userData => _userData.value;

  void setUserData(dynamic userData) async {
    _userData.value = userData;
    if (userData != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('user', <String>[
        userData.id,
        userData.email,
        userData.firstName,
        userData.lastName,
        userData.nationality,
        userData.sex,
        userData.pregnancy,
        userData.age,
      ]);
    }
  }
}
