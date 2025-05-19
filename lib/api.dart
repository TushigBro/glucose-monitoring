import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final dio = createDio();

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;

  static Dio createDio() {
    var dio = Dio(
      BaseOptions(
        baseUrl: 'https://undergraduate-project-ry8h.onrender.com/',
        receiveTimeout: 15000,
        connectTimeout: 15000,
        sendTimeout: 15000,
      ),
    );

    dio.interceptors.add(AppInterceptors(dio));

    return dio;
  }

  // In Api.dart
  Future<List<Map<String, dynamic>>> getGlucoseReadings(String userId) async {
    try {
      final response = await dio.get('/glucose/$userId/readings');
      if (response.statusCode == 200 && response.data is List) {
        // Sort by timestamp (assuming each reading has a `timestamp` field)
        final List<Map<String, dynamic>> readings =
            List<Map<String, dynamic>>.from(response.data)
              ..sort((a, b) => DateTime.parse(b['timestamp'])
                  .compareTo(DateTime.parse(a['timestamp'])));
        return readings;
      }
      throw NotFoundException(
          RequestOptions(path: '/glucose/readings'), 'No readings found');
    } on DioError catch (e) {
      throw e;
    }
  }
}

class AppInterceptors extends Interceptor {
  final Dio dio;

  AppInterceptors(this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    String errorMessage = 'Unknown error';
    if (err.response?.data != null && err.response?.data['message'] != null) {
      errorMessage = err.response?.data['message'] is String
          ? err.response?.data['message']
          : (err.response?.data['message'] as List<dynamic>).join(', ');
    } else {
      errorMessage = 'Unknown error';
    }
    switch (err.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioErrorType.response:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions, errorMessage);
          case 401:
            throw UnauthorizedException(err.requestOptions, errorMessage);
          case 404:
            throw NotFoundException(err.requestOptions, errorMessage);
          case 409:
            throw ConflictException(err.requestOptions, errorMessage);
          case 429:
            throw TooManyRequestsException(err.requestOptions, errorMessage);
          case 500:
            throw InternalServerErrorException(
                err.requestOptions, errorMessage);
        }
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        throw NoInternetConnectionException(err.requestOptions);
    }
    return handler.next(err);
  }
}

class TooManyRequestsException extends DioError {
  final String? _message;
  TooManyRequestsException(RequestOptions r, this._message)
      : super(requestOptions: r);

  @override
  String toString() {
    return _message ?? 'Too many requests';
  }
}

class BadRequestException extends DioError {
  final String? _message;
  BadRequestException(RequestOptions r, this._message)
      : super(requestOptions: r);

  @override
  String toString() {
    return _message ?? 'Invalid request';
  }
}

class InternalServerErrorException extends DioError {
  final String? _message;
  InternalServerErrorException(RequestOptions r, this._message)
      : super(requestOptions: r);

  @override
  String get message =>
      _message ?? 'Unknown error occurred, please try again later.';
}

class ConflictException extends DioError {
  final String? _message;
  ConflictException(RequestOptions r, this._message) : super(requestOptions: r);

  @override
  String toString() {
    return _message ?? 'Conflict occurred';
  }
}

class UnauthorizedException extends DioError {
  final String? _message;
  UnauthorizedException(RequestOptions r, this._message)
      : super(requestOptions: r);

  @override
  String toString() {
    return _message ?? 'Access denied';
  }
}

class NotFoundException extends DioError {
  final String? _message;
  NotFoundException(RequestOptions r, this._message) : super(requestOptions: r);

  @override
  String toString() {
    return _message ?? 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends DioError {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class DeadlineExceededException extends DioError {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}
