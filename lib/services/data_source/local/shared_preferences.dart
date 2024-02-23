import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class SharedPreferencesRepo {
  final tokenKey = 'TOKEN_KEY';
  var box = GetStorage();

  String? getToken() {
    return box.read(tokenKey);
  }

  Future<void> saveToken(String? token) {
    return box.write(tokenKey, token);
  }
}
