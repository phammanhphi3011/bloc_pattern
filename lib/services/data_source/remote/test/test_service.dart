import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:test_load_more/post_model.dart';
import 'package:test_load_more/schema/response.dart';


class TestService {
  final Dio dio;
  TestService(this.dio);

  Future<APIResponse<List<PostModel>>> fetchPosts(int start,int limit) async {
    var res = await dio
        .get('https://jsonplaceholder.typicode.com/posts?_start=$start&_limit=$limit');
    var parseData =
        (res.data as List).map((e) => PostModel.fromJson(e)).toList();
    return APIResponse(data: parseData);
  }
}
