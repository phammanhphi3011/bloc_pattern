import 'package:injectable/injectable.dart';
import 'package:test_load_more/core/base_repo.dart';
import 'package:test_load_more/core/base_repo_impl.dart';
import 'package:test_load_more/post_model.dart';
import 'package:test_load_more/schema/response.dart';
import 'package:test_load_more/services/data_source/remote/api_client.dart';

abstract class ITestRepo extends BaseRepo {
  Future<APIResponse<List<PostModel>>> test(int start,int limit);
}

@Singleton(as: ITestRepo)
class TestRepoImpl extends BaseRepoImpl implements ITestRepo {
  final ApiClient _apiClient;

  TestRepoImpl(this._apiClient);

  @override
  Future<APIResponse<List<PostModel>>> test(int start,int limit) async {
    try {
      return await _apiClient.testService.fetchPosts(start,limit);
    } catch (e) {
      return APIResponse.fromException(e);
    }
  }
}
