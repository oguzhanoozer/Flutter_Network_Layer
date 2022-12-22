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
    final _response = await _dio.get(path);

    if (_response.statusCode == HttpStatus.ok) {
      return _jsonBodyParser<T>(model, _response.data);
    }
    throw _response.data;
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
