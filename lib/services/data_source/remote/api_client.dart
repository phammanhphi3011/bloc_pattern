import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:test_load_more/config/app_config.dart';
import 'package:test_load_more/services/data_source/remote/base_api_client.dart';
import 'package:test_load_more/services/data_source/remote/test/test_service.dart';

import '../../../logger/app_logger.dart';
import '../local/shared_preferences.dart';

@singleton
class ApiClient extends BaseApiClient {
  final SharedPreferencesRepo _sharedPreferencesRepo;

  late Dio dio;
  late TestService testService;

  ApiClient(this._sharedPreferencesRepo) {
    AppLogger.d('Init dio api client');

    dio = getDio(
      endPoint: Env.dev().endPoint,
    );
    testService = TestService(dio);
    dio.options.connectTimeout = const Duration(milliseconds: 20000);
    dio.options.receiveTimeout = const Duration(milliseconds: 20000);
  }

  @override
  Map<String, dynamic>? getHeaders() {
    var headers = {
      'Platform': Platform.isIOS ? 'iOS' : 'Android',
      'App-Version': '1.0.0'
    };
    var token = _sharedPreferencesRepo.getToken();
    if (token?.isNotEmpty == true) {
      headers.addAll(
          {'Authorization': 'Bearer ${_sharedPreferencesRepo.getToken()}'});
    }
    return headers;
  }

  @override
  void onTokenExpired() {
    //If token expired out login
  }
}
