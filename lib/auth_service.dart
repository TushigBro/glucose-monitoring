import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:glucose_monitoring/api.dart';

class AuthService {
  static AuthService? _instance;

  factory AuthService() => _instance ??= AuthService._();

  AuthService._();

  Future<Response> login(
      {required String number, required String password}) async {
    Response response = await Api().dio.post('auth/login', data: {
      'phoneNumber': number,
      'password': password,
    });

    return response;
  }

  Future<Response> register(
      {required String firstName,
      required String lastName,
      required String email,
      required String password}) async {
    Response response = await Api().dio.post('auth/signup', data: {
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    });
    return response;
  }
}
