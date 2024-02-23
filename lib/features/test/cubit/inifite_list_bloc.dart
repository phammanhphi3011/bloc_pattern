import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:test_load_more/post_model.dart';
import 'package:test_load_more/repository/test_repo.dart';
import 'package:test_load_more/schema/response.dart';

import 'inifite_list_state.dart';

class PostBloc extends Cubit<PostState> {
  PostBloc(this._testRepo) : super(PostUninitialized()) {
    GetIt.instance.get<ITestRepo>();
  }

  final ITestRepo _testRepo;
  int _page = 1;
  int _limit = 10;
  var _posts = <PostModel>[];
  var canLoadMore = false;

  int get page => _page;

  List<PostModel> get posts => _posts;

  set setPage(vl) {
    _page = vl;
  }

  set setPosts(vl) {
    _posts = vl;
  }

  final scrollController = ScrollController();

  Future<APIResponse<List<PostModel>>> fetchPosts(
      int startIndex, int limit) async {
    final res = await _testRepo.test(startIndex, limit);
    if (res.isSuccess) {
      setPosts = res.data;
      if (_page == 1) {
        emit(
          PostLoaded(
            posts: _posts,
          ),
        );
      } else {
        _posts.addAll(posts.toList());
        emit(
          PostLoaded(
            posts: _posts,
          ),
        );
      }
    } else {
      PostError(message: res.message);
    }
    return res;
  }

  void loadMore() {
    var maxExtent = scrollController.position.maxScrollExtent;
    var currentPos = scrollController.position.pixels;
    print(currentPos);
    if (currentPos == maxExtent) {
      _page++;
      fetchPosts(_limit, _limit + 10);
    }
  }

  Future<void> refresh() async {
    setPage = 1;
    setPosts = <PostModel>[];
    await fetchPosts(0, 5);
  }

  // Future<void> getPost() async {
  //   var res = await fetchPosts(0, 20);
  //   try {
  //     if (state is PostUninitialized) {}
  //     if (state is PostLoaded) {
  //       final posts =
  //           await fetchPosts((state as PostLoaded).posts?.length ?? 0, 20);
  //       if (posts.data!.isEmpty) {
  //         (state as PostLoaded).copyWith(hasReachedMax: true);
  //       } else {
  //         emit(PostLoaded(
  //           posts: (state as PostLoaded).posts! + posts.data!,
  //           hasReachedMax: false,
  //         ));
  //       }
  //     }
  //   } catch (_) {}
  // }

  bool _hasReachedMax(PostState state) =>
      state is PostLoaded && state.hasReachedMax!;
}
