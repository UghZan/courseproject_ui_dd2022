import 'package:courseproject_ui_dd2022/data/clients/api_client.dart';

import '../../domain/models/refresh_token_request.dart';
import '../../domain/models/user.dart';
import '../../domain/repository/api_repository.dart';
import '../../domain/models/token_request.dart';
import '../../domain/models/token_response.dart';
import '../clients/auth_client.dart';

class ApiDataRepository extends ApiRepository {
  final AuthClient _auth;
  final ApiClient _api;
  ApiDataRepository(this._auth, this._api);

  @override
  Future<TokenResponse?> getToken({
    required String login,
    required String password,
  }) async {
    return await _auth.getToken(TokenRequest(
      login: login,
      password: password,
    ));
  }

  @override
  Future<User?> getCurrentUser() async {
    return await _api.getCurrentUser();
  }

  @override
  Future<TokenResponse?> refreshToken({required String token}) async {
    return await _auth.refreshToken(RefreshTokenRequest(token: token));
  }
}