import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:network_layer/json_place_holder/model/base_model.dart';

import '../../core/network_layer/network_manager.dart';

abstract class IBaseService {
  final Dio _dio = NetworkManager.instance.dio;
  Future<dynamic> get<T extends IBaseModel>(String path, IBaseModel model);
}

class BaseService extends IBaseService {
  @override
  Future<dynamic> get<T extends IBaseModel>(
      String path, IBaseModel model) async {
    try {
      CancelToken cancelToken = CancelToken();
      Timer(Duration(milliseconds: 100), () {
        print("Cancelling now!");
        cancelToken.cancel('Not Need Anymore');
      });

      final _response = await _dio.get(path);
      // .catchError((err) {
      //  if (CancelToken.isCancel(err)) {
      //    print('Request canceled! Reason: ' + err.message);
      //  }
      // });

      if (_response.statusCode == HttpStatus.ok) {
        return _jsonBodyParser<T>(model, _response.data);
      }
    } catch (e) {
      rethrow;
    }
  }

  dynamic _jsonBodyParser<T>(IBaseModel model, dynamic data) {
    if (data is Map<String, dynamic>) {
      return model.fromJson(data);
    } else if (data is List) {
      var x = data.map((e) => model.fromJson(e)).toList().cast<T>();
      return data.map((e) => model.fromJson(e)).toList().cast<T>();
    } else {
      return data;
    }
  }
}

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.message,
        );
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioErrorType.other:
        if (dioError.message.contains("SocketException")) {
          message = 'No Internet';
          break;
        }
        message = "Unexpected error occurred";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String _handleError(int? statusCode, dynamic errorMessage) {
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
