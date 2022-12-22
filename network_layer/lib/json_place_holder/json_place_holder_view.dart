import 'package:flutter/material.dart';
import 'package:network_layer/core/network_layer/network_manager.dart';
import './json_place_holder_view_model.dart';
import 'package:network_layer/json_place_holder/model/photo_model.dart';
import 'package:network_layer/json_place_holder/model/user_model.dart';

class jsonPlaceHolderView extends jsonPlaceHolderViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBard(),
        body: Column(
          children: [
            _buildButtonRows(),
            currentServicePath == null
                ? _empytSizedBox()
                : _buildInformationBox(),
          ],
        ));
  }

  AppBar _buildAppBard() {
    return AppBar(
      title: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : _empytSizedBox(),
    );
  }

  Expanded _buildInformationBox() {
    return Expanded(
        child: currentServicePath == servicePath.PHOTOS
            ? _buildPhotosList()
            : _buildUsersList());
  }

  Row _buildButtonRows() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildShowPhotosButton(),
        _empytSizedBox(width: 20),
        _buildShowUsersButton()
      ],
    );
  }

  ElevatedButton _buildShowUsersButton() {
    return ElevatedButton(
        onPressed: () async {
          setServicePath(servicePath.USERS);
          await getUsers();
        },
        child: const Text("Show Users"));
  }

  ElevatedButton _buildShowPhotosButton() {
    return ElevatedButton(
        onPressed: () async {
          setServicePath(servicePath.PHOTOS);
          await getPhotos();
        },
        child: const Text("Show Photos"));
  }

  SizedBox _empytSizedBox({double width = 0}) => SizedBox(width: width);

  Widget _buildPhotosList() {
    return ListView.builder(
      itemCount: photoList.length,
      itemBuilder: (context, index) {
        final _photoModel = photoList[index];
        return _buildPhotosCard(_photoModel);
      },
    );
  }

  Card _buildPhotosCard(PhotoModel photoModel) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          child: Image.network(
            photoModel.url ?? "",
          ),
        ),
        title: Text(photoModel.title ?? ""),
        trailing: Text(photoModel.albumId.toString()),
      ),
    );
  }

  Widget _buildUsersList() {
    return ListView.builder(
      itemCount: usersList.length,
      itemBuilder: (context, index) {
        final _userModel = usersList[index];
        return _buildUserCard(_userModel);
      },
    );
  }

  Card _buildUserCard(UserModel userModel) {
    return Card(
      color: userModel.id == null || userModel.id!.isEven
          ? Colors.green
          : Colors.grey,
      child: ListTile(
        leading: Text(userModel.id.toString()),
        title: Text(userModel.address?.zipcode ?? ""),
        //subtitle: Text(_userModel.phone ?? ""),
        trailing: Text(userModel.company?.name ?? ""),
      ),
    );
  }
}
