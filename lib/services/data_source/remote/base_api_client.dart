import 'package:dio/dio.dart';
import 'package:test_load_more/logger/app_logger.dart';

abstract class BaseApiClient {
  Dio getDio({
    required String? endPoint,
    int? timeOut,
    String? contentType,
  }) {
    var dio = Dio();

    //API end point
    dio.options.baseUrl = endPoint ?? '';

    //Set time out
    dio.options.connectTimeout = Duration(milliseconds: timeOut ?? 20000);
    dio.options.receiveTimeout = Duration(milliseconds: timeOut ?? 35000);
    dio.options.contentType = contentType ?? 'application/json';

    dio.interceptors.addAll([
      LogInterceptor(
        // request: true,
        // requestBody: true,
        // requestHeader: true,
        // responseBody: true,
      ),
      InterceptorsWrapper(onRequest: (
        RequestOptions options,
        RequestInterceptorHandler handler,
      ) {
        var header = getHeaders();
        if (header != null && header['Authorization'] != null) {
          options.headers.addAll(header);
        }
        return handler.next(options);
      }, onError: (DioException e, ErrorInterceptorHandler handler) {
        if (e.response?.statusCode == 401) {
          onTokenExpired();
          return;
        }
        return handler.next(e);
      }),
    ]);
    return dio;
  }

  Map<String, dynamic>? getHeaders();

  void onTokenExpired();
}
