import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../post_model.dart';
import '../../../repository/test_repo.dart';
import '../../../schema/response.dart';
import 'loadmore_state.dart';

class LoadMoreCubit<T> extends Cubit<LoadMoreState> {
  LoadMoreCubit(this._testRepo) : super(LoadMoreInitial());

  int _page = 1;
  var _data = <dynamic>[];
  var _posts = <PostModel>[];

  List<dynamic> get data => _data;

  List<PostModel> get posts => _posts;

  set setData(vl) {
    _data = vl;
  }

  set setPosts(vl) {
    _posts = vl;
  }

  final ITestRepo _testRepo;

  Future<APIResponse<List<PostModel>>> fetchPosts(
      int startIndex, int limit) async {
    final res = await _testRepo.test(startIndex, limit);
    return res;
  }

  void loadMoreData() async {
    emit(LoadMoreLoading());
    // Simulate fetching more data
    try {
      // Replace this with your actual data fetching logic
      var res = await fetchPosts(0, 5);
      if (res != null) {
        if (_page == 1) {
          setPosts = res.data;
          emit(LoadMoreLoaded(_posts, isHasReached: true));
        } else {
          _posts.addAll(res.data!.toList());
          emit(LoadMoreLoaded(_posts, isHasReached: true));
        }
      }
    } catch (e) {
      emit(LoadMoreError(message: 'Error loading more data'));
    }
  }
}
