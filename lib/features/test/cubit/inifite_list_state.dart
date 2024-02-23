import 'package:equatable/equatable.dart';
import 'package:test_load_more/post_model.dart';

class PostState extends Equatable {
  const PostState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class PostUninitialized extends PostState {
  @override
  String toString() => 'PostUninitialized';
}

class PostLoading extends PostState {}

class PostError extends PostState {
  final String? message;

  const PostError({this.message});

  @override
  String toString() => 'PostError';

  @override
  List<Object?> get props => [message];
}

class PostLoaded extends PostState {
  final List<PostModel>? posts;
  final bool? hasReachedMax;

  const PostLoaded({
    this.posts,
    this.hasReachedMax,
  });

  @override
  List<Object?> get props => [posts,hasReachedMax];

  @override
  String toString() =>
      'PostLoaded { posts: $posts, hasReachedMax: $hasReachedMax }';
}
