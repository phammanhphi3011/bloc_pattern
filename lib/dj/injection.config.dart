// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:test_load_more/repository/test_repo.dart' as _i5;
import 'package:test_load_more/services/data_source/local/shared_preferences.dart'
    as _i3;
import 'package:test_load_more/services/data_source/remote/api_client.dart'
    as _i4;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.SharedPreferencesRepo>(_i3.SharedPreferencesRepo());
    gh.singleton<_i4.ApiClient>(_i4.ApiClient(gh<_i3.SharedPreferencesRepo>()));
    gh.singleton<_i5.ITestRepo>(_i5.TestRepoImpl(gh<_i4.ApiClient>()));
    return this;
  }
}
