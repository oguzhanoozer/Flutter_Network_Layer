import 'package:dio/dio.dart';

class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance {
    if (_instance != null) {
      return _instance!;
    } else
      _instance = NetworkManager._init();
    return _instance!;
  }

  late Dio dio;
  final _baseUrl = "https://jsonplaceholder.typicode.com/";

  NetworkManager._init() {
    dio = Dio(BaseOptions(baseUrl: _baseUrl));
  }
}

enum servicePath { PHOTOS, ALBUMS, USERS }

extension servicePathExtension on servicePath {
  String get servicePathValue {
    switch (this) {
      case servicePath.USERS:
        return 'users';
      case servicePath.PHOTOS:
        return 'photos';
      case servicePath.ALBUMS:
        return 'albums';
      default:
        throw "Service Path Not Found";
    }
  }
}
