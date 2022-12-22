import 'package:network_layer/core/network_layer/network_manager.dart';
import 'package:network_layer/json_place_holder/model/photo_model.dart';
import 'package:network_layer/json_place_holder/model/user_model.dart';
import 'package:network_layer/json_place_holder/service/base_service.dart';

class JsonPlaceHolderService extends BaseService {
  Future<List<PhotoModel>> getPhotos() async {
    return await get<PhotoModel>(
        servicePath.PHOTOS.servicePathValue, PhotoModel());
  }

  Future<List<UserModel>> getUsers() async {
    return await get<UserModel>(
        servicePath.USERS.servicePathValue, UserModel());
  }
}
