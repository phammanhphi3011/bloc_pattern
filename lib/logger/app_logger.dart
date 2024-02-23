import 'package:logger/logger.dart';

final logger = Logger();

class AppLogger {
  static void d(dynamic message) {
    return logger.d(message);
  }

  static void e(dynamic message) {
    return logger.e(message);
  }

  static void w(dynamic message) {
    return logger.w(message);
  }

  static void i(dynamic message) {
    return logger.i(message);
  }
}
