import 'http_exception_handler.dart';

Future<T?> handleApiCall<T>({
  required Future<T> Function() apiCall,
  String? loadingMessage,
}) async {
  try {
    // if (loadingMessage != null) {
    //   Get.snackbar(loadingMessage, " ");
    // }
    final result = await apiCall();
    return result;
  } catch (e) {
    HttpExceptionHandler.handle(e);
    return null;
  } finally {
    if (loadingMessage != null) {}
  }
}
