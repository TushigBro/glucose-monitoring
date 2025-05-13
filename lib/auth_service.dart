import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:glucose_monitoring/api.dart';

class AuthService {
  static AuthService? _instance;

  factory AuthService() => _instance ??= AuthService._();

  AuthService._();

  Future<Response> login(
      {required String email, required String password}) async {
    Response response = await Api().dio.post('auth/login', data: {
      'email': email,
      'password': password,
    });

    return response;
  }

  Future<Response> register(
      {required int age,
      required String sex,
      required String pregnancy,
      required String nationality,
      required String firstName,
      required String lastName,
      required String email,
      required String password}) async {
    Response response = await Api().dio.post('auth/signup', data: {
      'password': password,
      'confirmPassword': password,
      'nationality': nationality,
      'age': age,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'pregnancy': pregnancy,
      'sex': sex,
    });
    
    return response;
  }
}
