import 'dart:io';
import 'package:courseproject_ui_dd2022/internal/shared_prefs.dart';
import 'package:dio/dio.dart';

import '../../domain/repository/api_repository.dart';
import '../../internal/dependencies/repository_module.dart';
import '../../internal/token_storage.dart';

class AuthService {
  final ApiRepository _api = RepositoryModule.apiRepository();

  Future auth(String? login, String? password) async {
    if (login != null && password != null) {
      try {
        var token = await _api.getToken(login: login, password: password);
        if (token != null) {
          await TokenStorage.setStoredToken(token);
          var user = await _api.getCurrentUser();
          if (user != null) {
            SharedPrefs.setStoredUser(user);
          }
        }
      } on DioError catch (e) {
        if (e.error is SocketException) {
          throw NoNetworkException();
        } else if (<int>[401, 406].contains(e.response?.statusCode)) {
          throw WrongCredentionalException();
        } else if (<int>[500].contains(e.response?.statusCode)) {
          throw ServerException();
        }
      }
    }
  }

  Future<bool> checkAuth() async {
    return ((await TokenStorage.getAccessToken()) != null) &&
        ((await SharedPrefs.getStoredUser()) != null);
  }

  Future<bool> tryGetUser() async {
    try {
      var user = await _api.getCurrentUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future logout() async {
    await TokenStorage.setStoredToken(null);
  }
}

class WrongCredentionalException implements Exception {}

class NoNetworkException implements Exception {}

class ServerException implements Exception {}
