import 'package:get_it/get_it.dart';
import '../services/data_source/local/shared_preferences.dart';

final sl = GetIt.instance;

void setUpInjector() {
  ///Setup Prefs
  sl.registerSingleton(SharedPreferencesRepo());

  ///Setup repo
  // sl.registerLazySingleton<ITestRepo>(() => TestRepoImpl(_apiClient));
}
