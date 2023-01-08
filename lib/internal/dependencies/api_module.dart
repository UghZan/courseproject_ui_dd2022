import 'package:courseproject_ui_dd2022/internal/token_storage.dart';

import '../../data/clients/api_client.dart';
import '../../data/clients/auth_client.dart';
import 'package:dio/dio.dart';

import '../../data/service/auth_service.dart';
import '../../domain/models/refresh_token_request.dart';
import '../../ui/navigation/app_navigator.dart';
import '../app_config.dart';

class ApiModule {
  static AuthClient? _authClient;
  static ApiClient? _apiClient;

  static AuthClient auth() =>
      _authClient ??
      AuthClient(
        Dio(),
        baseUrl: baseUrl,
      );

  static ApiClient api() =>
      _apiClient ??
      ApiClient(
        _addInterceptors(Dio()),
        baseUrl: baseUrl,
      );

  static Dio _addInterceptors(Dio dio) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: ((options, handler) async {
        final token = await TokenStorage.getAccessToken();
        options.headers.addAll({"Authorization": "Bearer $token"});
        return handler.next(options);
      }),
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          // ignore: deprecated_member_use
          dio.lock();
          RequestOptions options = e.response!.requestOptions;

          var rt = await TokenStorage.getRefreshToken();
          try {
            if (rt != null) {
              var token =
                  await auth().refreshToken(RefreshTokenRequest(token: rt));
              await TokenStorage.setStoredToken(token);
              options.headers["Authorization"] = "Bearer ${token!.accessToken}";
            }
          } catch (e) {
            var service = AuthService();
            await service.logout();
            AppNavigator.toLoader();

            return handler
                .resolve(Response(statusCode: 400, requestOptions: options));
          } finally {
            // ignore: deprecated_member_use
            dio.unlock();
          }

          return handler.resolve(await dio.fetch(options));
        } else {
          return handler.next(e);
        }
      },
    ));

    return dio;
  }
}
