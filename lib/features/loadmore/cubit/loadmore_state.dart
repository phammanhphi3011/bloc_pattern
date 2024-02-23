abstract class LoadMoreState<T> {}

class LoadMoreInitial extends LoadMoreState {}

class LoadMoreLoading extends LoadMoreState {}

class LoadMoreLoaded<T> extends LoadMoreState {
  final List<T> data;
  final bool isHasReached;

  LoadMoreLoaded(this.data, {this.isHasReached = false});
}

class LoadMoreError extends LoadMoreState {
  final String? message;

  LoadMoreError({this.message});
}
