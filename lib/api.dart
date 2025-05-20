import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// === DTOs / Models ===
class Nutrition {
  final double? calories;
  final double? protein;
  final double? fat;
  final double? sugar;

  Nutrition({this.calories, this.protein, this.fat, this.sugar});

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: json['calories']?.toDouble(),
      protein: json['protein']?.toDouble(),
      fat: json['fat']?.toDouble(),
      sugar: json['sugar']?.toDouble(),
    );
  }
}

class Food {
  final String id;
  final String name;
  final int giValue;
  final String mealType;
  final String imageUrl;
  final String recipeLink;
  final Nutrition nutrition;
  final List<String> allergens;
  final List<String> tags;

  Food({
    required this.id,
    required this.name,
    required this.giValue,
    required this.mealType,
    required this.imageUrl,
    required this.recipeLink,
    required this.nutrition,
    required this.allergens,
    required this.tags,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      giValue: json['giValue'],
      mealType: json['mealType'],
      imageUrl: json['imageUrl'],
      recipeLink: json['recipeLink'],
      nutrition: Nutrition.fromJson(json['nutrition']),
      allergens: List<String>.from(json['allergens']),
      tags: List<String>.from(json['tags']),
    );
  }
}

class RecommendationResponse {
  final List<Food> recommendations;
  final String glucoseTrend;

  RecommendationResponse({
    required this.recommendations,
    required this.glucoseTrend,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    var list = json['recommendations'] as List;
    List<Food> foods = list.map((i) => Food.fromJson(i)).toList();

    return RecommendationResponse(
      recommendations: foods,
      glucoseTrend: json['glucoseTrend'],
    );
  }
}
// === End of Models ===

class Api {
  final dio = createDio();

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;

  static Dio createDio() {
    var dio = Dio(
      BaseOptions(
        baseUrl: 'https://undergraduate-project-ry8h.onrender.com/ ',
        receiveTimeout: 15000,
        connectTimeout: 15000,
        sendTimeout: 15000,
      ),
    );

    dio.interceptors.add(AppInterceptors(dio));

    return dio;
  }

  // Get food recommendations from backend
  Future<Response> getFoodRecommendations() async {
    
      final Response response = await dio.get('/recommendations');
      return response;
  }

  // Get glucose readings
  Future<List<Map<String, dynamic>>> getGlucoseReadings(String userId) async {
    try {
      final response = await dio.get('/glucose/$userId/readings');
      if (response.statusCode == 200 && response.data is List) {
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

  // Get predicted glucose values
  Future<List<Map<String, dynamic>>> getPredictedGlucose(String userId) async {
    try {
      final response = await dio.get('/glucose/$userId/predictions');
      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      throw NotFoundException(
          RequestOptions(path: '/glucose/predictions'), 'No predictions found');
    } on DioError catch (e) {
      throw e;
    }
  }
}

// === Interceptors and Custom Exceptions ===
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

// === Custom Exception Classes ===
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
