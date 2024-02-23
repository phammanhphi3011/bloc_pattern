import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_load_more/features/loadmore/cubit/loadmore_cubit.dart';
import 'package:test_load_more/features/loadmore/cubit/loadmore_state.dart';

typedef void OnLoadMore();

typedef Widget OnBuildItem<T>(int index, T post, int maxlength);
typedef Widget OnEmptyWidget<T>();
typedef Widget OnHeaderBuild();
typedef Function OnInitScroller(ScrollController scrollController);
typedef Function OnRefresh();

class InfinityList<T, Z extends LoadMoreCubit<T>> extends StatefulWidget {
  final OnLoadMore onLoadMore;
  final OnBuildItem<T> onBuildItem;
  final OnEmptyWidget? onBuildEmptyItem;
  final OnHeaderBuild? onHeaderBuild;
  final OnInitScroller? onInitScroller;
  final bool reverse;
  final offsetScrollInit;
  final String messageEmpty;
  final enableEmptyCustomView;
  final bool initialRefresh;
  final OnRefresh? onRefresh;
  final double? scrollThreshold;
  final bool disableLoadingIndicator;
  final bool jumpToBottom;
  final bool scrollAppBar;
  final ScrollController? initScrollController;

  /// mặc định là listview, còn truyền false thì là gridview
  final bool isListView;

  InfinityList(
      {required this.onLoadMore,
      this.disableLoadingIndicator = false,
      this.offsetScrollInit = 0.0,
      required this.onBuildItem,
      this.messageEmpty = "emptyList",
      this.onRefresh,
      this.initialRefresh = false,
      this.onBuildEmptyItem,
      this.enableEmptyCustomView = false,
      this.reverse = false,
      this.onHeaderBuild,
      this.scrollThreshold,
      this.onInitScroller,
      this.jumpToBottom = false,
      this.initScrollController,
      this.scrollAppBar = false,
      this.isListView = true});

  @override
  _InfinityListState createState() => _InfinityListState<T, Z>();
}

class _InfinityListState<T, Z extends LoadMoreCubit<T>>
    extends State<InfinityList> {
  late ScrollController _scrollController;
  double _scrollThreshold = 200.0;
  int dataize = 0;

  // RefreshController _refreshController;
  bool firstJump = false;

  @override
  void initState() {
    super.initState();
    if (widget.scrollThreshold != null) {
      _scrollThreshold = widget.scrollThreshold ?? 200;
    }
    if (widget.initScrollController != null) {
      _scrollController = widget.initScrollController ?? ScrollController();
    } else {
      _scrollController =
          ScrollController(initialScrollOffset: widget.offsetScrollInit);
    }
    // _refreshController =
    //     RefreshController(initialRefresh: this.widget.initialRefresh);
    _scrollController.addListener(_onScroll);
    if (widget.onInitScroller != null) {
      widget.onInitScroller!(_scrollController);
    }
  }

  // void _onRefresh() async {
  //   // print("_onRefresh");
  //   if (this.widget.onRefresh != null) {
  //     this.widget.onRefresh();
  //   }
  //   _refreshController.refreshCompleted();
  // }
  //
  // void _onLoading() async {
  //   // print("_onLoading");
  //   _refreshController.loadComplete();
  // }

  // _onBuildHeader() {
  //   return Row(
  //     children: <Widget>[this.widget.onHeaderBuild!()],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Z, LoadMoreState>(
      builder: (context, state) {
        if (state is LoadMoreLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
         if (state is LoadMoreError) {
          return Center(
            child: Text(state.message ?? ''),
          );
        }
         if (state is LoadMoreLoaded) {
          dataize = state.data.length;
          if (state.data.isEmpty) {
            Widget res;
            if (this.widget.enableEmptyCustomView) {
              res = widget.onBuildEmptyItem!();
            } else {
              res = Center(
                child: Text(this.widget.messageEmpty),
              );
            }

            // if has header build => set up header
            if (this.widget.onHeaderBuild != null) {
              res = Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  // this.widget.onHeaderBuild!(),
                  Expanded(child: res),
                ],
              );
            }

            return ListView(
              shrinkWrap: true,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 100),
                  child: SizedBox(
                    height: 200,
                    child: res,
                  ),
                )
              ],
            );
          }
          _jumpBottom();
          return widget.isListView == true
              ? buildListView(state)
              : buildGridview(state);
        }
        return Text('Out off data');
      },
    );
  }

  void _jumpBottom() async {
    if (widget.jumpToBottom && firstJump == false) {
      firstJump = true;
      await Future.delayed(const Duration(milliseconds: 500));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 350),
      );
    }
  }

  Widget buildListView(LoadMoreLoaded state) {
    print('state.data${state.data.runtimeType}');
    return ListView.builder(
      shrinkWrap: true,
      physics: widget.scrollAppBar == true
          ? const ClampingScrollPhysics()
          : (widget.jumpToBottom ? const ClampingScrollPhysics() : null),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          if (this.widget.onHeaderBuild != null) {
            return Column(
              children: <Widget>[
                // this._onBuildHeader(),
                this
                    .widget
                    .onBuildItem(index, state.data[index], state.data.length)
              ],
            );
          }
        }
        if (index >= state.data.length) {
          if (this.widget.disableLoadingIndicator) {
            return Container();
          } else {
            return BottomLoader();
          }
        }
        if (index == state.data.length - 1) {
          return Container(
            padding: const EdgeInsets.only(bottom: 100),
            child: this
                .widget
                .onBuildItem(index, state.data[index], state.data.length),
          );
        }
        return this
            .widget
            .onBuildItem(index, state.data[index], state.data.length);
      },
      reverse: this.widget.reverse,
      itemCount: state.isHasReached ? state.data.length : state.data.length + 1,
      controller: _scrollController,
    );
  }

  Widget buildGridview(LoadMoreLoaded state) {
    return GridView.builder(
      shrinkWrap: true,
      physics: widget.scrollAppBar == true
          ? const ClampingScrollPhysics()
          : (widget.jumpToBottom ? const ClampingScrollPhysics() : null),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          if (this.widget.onHeaderBuild != null) {
            return Column(
              children: <Widget>[
                // this._onBuildHeader(),
                this
                    .widget
                    .onBuildItem(index, state.data[index], state.data.length)
              ],
            );
          }
        }
        if (index >= state.data.length) {
          if (this.widget.disableLoadingIndicator) {
            return Container();
          } else {
            return BottomLoader();
          }
        }
        if (index == state.data.length - 1) {
          return Container(
            // padding: EdgeInsets.only(bottom: 100),
            child: this
                .widget
                .onBuildItem(index, state.data[index], state.data.length),
          );
        }
        return this
            .widget
            .onBuildItem(index, state.data[index], state.data.length);
      },
      reverse: this.widget.reverse,
      itemCount: state.isHasReached ? state.data.length : state.data.length + 1,
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        mainAxisSpacing: 13,
        crossAxisSpacing: 13,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      this.widget.onLoadMore();
    }
  }

  Widget BottomLoader() {
    return CircularProgressIndicator();
  }
}
