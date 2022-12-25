import 'package:dio/dio.dart';

class ServiceException implements Exception {
  late String message;

  ServiceException.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Request was cancalled from server";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection timeout error with API Server";
        break;
      case DioErrorType.receiveTimeout:
        message = "Received timeout error with API Server";
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout error with API Server";
        break;
      case DioErrorType.other:
        if (dioError.message.contains("SocketException")) {
          message = "No Internet or wrong server path";
          break;
        }
        message = "UnExpected error occured";
        break;
      case DioErrorType.response:
        message = _handleErrorCode(
            dioError.response?.statusCode, dioError.response?.statusMessage);
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String _handleErrorCode(int? statusCode, dynamic errorMessage) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return errorMessage;
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
