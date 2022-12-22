import 'package:flutter/material.dart';
import 'package:network_layer/core/network_layer/network_manager.dart';
import 'package:network_layer/json_place_holder/model/photo_model.dart';
import 'package:network_layer/json_place_holder/model/user_model.dart';
import 'package:network_layer/json_place_holder/service/json_place_holder_service.dart';
import './json_place_holder.dart';

abstract class jsonPlaceHolderViewModel extends State<jsonPlaceHolder> {
  List<PhotoModel> photoList = [];
  List<UserModel> usersList = [];

  servicePath? currentServicePath;

  void setServicePath(servicePath path) {
    currentServicePath = path;
  }

  late JsonPlaceHolderService _jsonService;

  bool isLoading = false;

  void changeIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    _jsonService = JsonPlaceHolderService();
  }

  Future<void> getPhotos() async {
    changeIsLoading();
    try {
      photoList = await _jsonService.getPhotos();
    } catch (e) {
      showErrorWidget(e.toString());
    }
    changeIsLoading();
  }

  Future<void> getUsers() async {
    changeIsLoading();
    try {
      usersList = await _jsonService.getUsers();
    } catch (e) {
      showErrorWidget(e.toString());
    }
    changeIsLoading();
  }

  void showErrorWidget(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Text(message),
        );
      },
    );
  }
}
