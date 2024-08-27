import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final allowed = <String>["/api/auth/connect"];
  final GetStorage _box;
  AuthInterceptor() : _box = GetStorage() {}

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();

    if (allowed.contains(options.path.toString())) {
      return handler.next(options);
    }

    var token = _box.read("access_token");

    options.headers.addAll({"Authorization": "Bearer $token"});
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 &&
        !allowed.contains(err.requestOptions.path.toString())) {
      return handler.next(err);
    }
    return handler.next(err);
  }
}
