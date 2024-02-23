import 'dart:io';

import 'package:dio/dio.dart';
import 'package:test_load_more/logger/app_logger.dart';

class APIResponse<T> {
  //From Api
  T? data;

  int? statusCode;
  String? message;
  String? resultCode;

  APIResponse({
    this.data,
    this.statusCode = 200,
    this.message,
    this.resultCode,
  });

  bool get isSuccess => statusCode == 200;

  bool get isBadRequest => statusCode == 400;

  factory APIResponse.fromJson(Map<String, dynamic> json) => APIResponse(
        data: json['data'],
        statusCode: json['statusCode'],
        message: json['message'],
        resultCode: json['resultCode'],
      );

  factory APIResponse.fromException(ex) {
    AppLogger.e(ex);
    var errCode = 500;
    String? messageError;
    if (ex is Exception) {
      if (ex is DioException) {
        switch (ex.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            errCode = 408;
            break;
          case DioExceptionType.badResponse:
            switch (ex.response?.statusCode) {
              case 400:
                errCode = 400;
                break;
              case 404:
                errCode = 404;
                break;
              case 502:
                errCode = 502;
                break;
            }
          case DioExceptionType.cancel:
            errCode = 499;
            break;
          case DioExceptionType.unknown:
            switch (ex.error.runtimeType) {
              case SocketException:
                messageError = ex.error.toString();
            }
          default:
            errCode = 500;
        }
      }
    }
    return APIResponse(
        statusCode: errCode,
        message: getStringMessage(errCode, errorMessage: messageError));
  }
}

String getStringMessage(int errorCode, {String? errorMessage}) {
  var errorText = '';
  switch (errorCode) {
    case 51:
      errorText = errorMessage ?? 'No internet connection';
      break;
    case 101:
      errorText = errorMessage ?? 'No internet connection';
      break;
    case 61:
      errorText = errorMessage ?? 'Connection refused';
      break;
    case 408:
      errorText = 'Receive Timeout';
      break;
    case 400:
      errorText = 'Bad request: $errorMessage';
      break;
    case 404:
      errorText = 'Not Found';
      break;
    case 409:
      errorText = 'Cancel request';
      break;
    case 502:
      errorText = 'Bad Gateway';
      break;
    case 500:
      errorText = 'Internal server error';
      break;
    default:
      errorText = 'Internal server error';
  }
  return errorText;
}
