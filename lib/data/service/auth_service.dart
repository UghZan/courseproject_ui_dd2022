import 'dart:io';
import 'package:courseproject_ui_dd2022/domain/models/create_models/create_user_model.dart';
import 'package:courseproject_ui_dd2022/internal/shared_prefs.dart';
import 'package:dio/dio.dart';

import '../../domain/repository/api_repository.dart';
import '../../internal/dependencies/repository_module.dart';
import '../../internal/token_storage.dart';
import 'data_service.dart';

class AuthService {
  final ApiRepository _api = RepositoryModule.apiRepository();
  final DataService _dataService = DataService();

  Future auth(String? login, String? password) async {
    if (login != null && password != null) {
      try {
        var token = await _api.getToken(login: login, password: password);
        if (token != null) {
          await TokenStorage.setStoredToken(token);
          var user = await _api.getCurrentUser();
          var prevUser = await SharedPrefs.getStoredUser();
          if (user?.id != prevUser?.id) {
            _dataService.clearDB();
          }

          if (user != null) {
            SharedPrefs.setStoredUser(user);
          }
        }
      } on DioError catch (e) {
        if (e.error is SocketException) {
          throw NoNetworkException();
        } else if (<int>[401, 406].contains(e.response?.statusCode)) {
          throw WrongCredentionalException();
        } else if (e.response?.statusCode == 500) {
          throw ServerException();
        }
      }
    }
  }

  Future<bool> checkAuth() async {
    var res = false;

    if (await TokenStorage.getAccessToken() != null) {
      var user = await _api.getCurrentUser();
      if (user != null) {
        await SharedPrefs.setStoredUser(user);
        await _dataService.createOrUpdateUser(user);
      }

      res = true;
    }

    return res;
  }

  void createUser(CreateUserModel model) async {
    try {
      _api.createUser(model);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 409) {
        throw UserAlreadyExists();
      }
    }
  }

  Future logout() async {
    await TokenStorage.setStoredToken(null);
  }
}

class WrongCredentionalException implements Exception {}

class NoNetworkException implements Exception {}

class ServerException implements Exception {}

class UserAlreadyExists implements Exception {}
