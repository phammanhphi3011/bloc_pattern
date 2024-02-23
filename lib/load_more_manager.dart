// import 'package:flutter/material.dart';
//
// typedef void OnLoadMore();
//
// typedef Widget OnBuildItem<T>(int index, T post, int maxlength);
// typedef Widget OnEmptyWidget<T>();
// typedef Widget OnHeaderBuild();
// typedef Function OnInitScroller(ScrollController scrollController);
// typedef Function OnRefresh();
//
// class InfinityList<T, Z extends PostBloc<T>> extends StatefulWidget {
//   final OnLoadMore onLoadMore;
//   final OnBuildItem<T> onBuildItem;
//   final OnEmptyWidget onBuildEmptyItem;
//   final OnHeaderBuild onHeaderBuild;
//   final OnInitScroller onInitScroller;
//   final bool reverse;
//   final offsetScrollInit;
//   final String messageEmpty;
//   final enableEmptyCustomView;
//   final bool initialRefresh;
//   final OnRefresh onRefresh;
//   final double scrollThreshold;
//   final bool disableLoadingIndicator;
//   final bool jumpToBottom;
//   final bool scrollAppBar;
//   final ScrollController initScrollController;
//
//   /// mặc định là listview, còn truyền false thì là gridview
//   final bool isListView;
//   InfinityList(
//       {required this.onLoadMore,
//         this.disableLoadingIndicator = false,
//         this.offsetScrollInit = 0.0,
//         required this.onBuildItem,
//         this.messageEmpty = "emptyList",
//         this.onRefresh,
//         this.initialRefresh = false,
//         this.onBuildEmptyItem,
//         this.enableEmptyCustomView = false,
//         this.reverse = false,
//         this.onHeaderBuild,
//         this.scrollThreshold,
//         this.onInitScroller,
//         this.jumpToBottom = false,
//         this.initScrollController,
//         this.scrollAppBar = false,
//         this.isListView = true});
//
//   @override
//   _InfinityListState createState() => _InfinityListState<T, Z>();
// }
//
// class _InfinityListState<T, Z extends PostBloc<T>> extends State<InfinityList> {
//   ScrollController _scrollController;
//   double _scrollThreshold = 200.0;
//   int postSize = 0;
//   RefreshController _refreshController;
//   bool firstJump = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.scrollThreshold != null) {
//       _scrollThreshold = widget.scrollThreshold;
//     }
//     if (widget.initScrollController != null) {
//       _scrollController = widget.initScrollController;
//     } else {
//       _scrollController =
//           ScrollController(initialScrollOffset: widget.offsetScrollInit);
//     }
//     _refreshController =
//         RefreshController(initialRefresh: this.widget.initialRefresh);
//     _scrollController.addListener(_onScroll);
//     if (widget.onInitScroller != null) {
//       widget.onInitScroller(_scrollController);
//     }
//   }
//
//   void _onRefresh() async {
//     // print("_onRefresh");
//     if (this.widget.onRefresh != null) {
//       this.widget.onRefresh();
//     }
//     _refreshController.refreshCompleted();
//   }
//
//   void _onLoading() async {
//     // print("_onLoading");
//     _refreshController.loadComplete();
//   }
//
//   _onBuildHeader() {
//     return Row(
//       children: <Widget>[this.widget.onHeaderBuild()],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Z, PostState<T>>(
//       builder: (context, state) {
//         if (state is PostUninitialized) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         if (state is PostError) {
//           return Center(
//             child: UIText("errorNetworkUnstable"),
//           );
//         }
//         if (state is PostLoaded<T>) {
//           postSize = state.posts.length;
//           if (state.posts.isEmpty) {
//             Widget res;
//             if (this.widget.enableEmptyCustomView) {
//               res = widget.onBuildEmptyItem();
//             } else {
//               res = Center(
//                 child: UIText(this.widget.messageEmpty),
//               );
//             }
//
//             // if has header build => set up header
//             if (this.widget.onHeaderBuild != null) {
//               res = Flex(
//                 direction: Axis.vertical,
//                 children: <Widget>[
//                   this.widget.onHeaderBuild(),
//                   Expanded(child: res),
//                 ],
//               );
//             }
//
//             return SmartRefresher(
//                 enablePullDown: true,
//                 scrollDirection: Axis.vertical,
//                 header: widget.scrollAppBar == true
//                     ? CustomWaterDropHeader(
//                   refreshStyle: RefreshStyle.Front,
//                 )
//                     : CustomWaterDropHeader(),
//                 controller: _refreshController,
//                 onRefresh: _onRefresh,
//                 onLoading: _onLoading,
//                 child: ListView(
//                   shrinkWrap: true,
//                   children: [
//                     Container(
//                       child: Container(
//                         child: res,
//                         height: Dimension.height,
//                       ),
//                       margin: EdgeInsets.only(bottom: 100),
//                     )
//                   ],
//                 ));
//           }
//           _jumpBottom();
//           return SmartRefresher(
//             enablePullDown: true,
//             scrollDirection: Axis.vertical,
//             header: widget.scrollAppBar == true
//                 ? CustomWaterDropHeader(
//               refreshStyle: RefreshStyle.Front,
//             )
//                 : CustomWaterDropHeader(),
//             controller: _refreshController,
//             onRefresh: _onRefresh,
//             onLoading: _onLoading,
//             child: widget.isListView == true
//                 ? buildListView(state)
//                 : buildGridview(state),
//           );
//         }
//         return Container();
//       },
//     );
//   }
//
//   void _jumpBottom() async {
//     if (widget.jumpToBottom && firstJump == false) {
//       firstJump = true;
//       await Future.delayed(Duration(milliseconds: 500));
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         curve: Curves.easeOut,
//         duration: const Duration(milliseconds: 350),
//       );
//     }
//   }
//
//   Widget buildListView(PostLoaded state) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: widget.scrollAppBar == true
//           ? ClampingScrollPhysics()
//           : (widget.jumpToBottom ? ClampingScrollPhysics() : null),
//       itemBuilder: (BuildContext context, int index) {
//         if (index == 0) {
//           if (this.widget.onHeaderBuild != null) {
//             return Column(
//               children: <Widget>[
//                 this._onBuildHeader(),
//                 this
//                     .widget
//                     .onBuildItem(index, state.posts[index], state.posts.length)
//               ],
//             );
//           }
//         }
//         if (index >= state.posts.length) {
//           if (this.widget.disableLoadingIndicator) {
//             return Container();
//           } else {
//             return BottomLoader();
//           }
//         }
//         if (index == state.posts.length - 1) {
//           return Container(
//             padding: EdgeInsets.only(bottom: 100),
//             child: this
//                 .widget
//                 .onBuildItem(index, state.posts[index], state.posts.length),
//           );
//         }
//         return this
//             .widget
//             .onBuildItem(index, state.posts[index], state.posts.length);
//       },
//       reverse: this.widget.reverse,
//       itemCount:
//       state.hasReachedMax ? state.posts.length : state.posts.length + 1,
//       controller: _scrollController,
//     );
//   }
//
//   Widget buildGridview(PostLoaded state) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: widget.scrollAppBar == true
//           ? ClampingScrollPhysics()
//           : (widget.jumpToBottom ? ClampingScrollPhysics() : null),
//       itemBuilder: (BuildContext context, int index) {
//         if (index == 0) {
//           if (this.widget.onHeaderBuild != null) {
//             return Column(
//               children: <Widget>[
//                 this._onBuildHeader(),
//                 this
//                     .widget
//                     .onBuildItem(index, state.posts[index], state.posts.length)
//               ],
//             );
//           }
//         }
//         if (index >= state.posts.length) {
//           if (this.widget.disableLoadingIndicator) {
//             return Container();
//           } else {
//             return BottomLoader();
//           }
//         }
//         if (index == state.posts.length - 1) {
//           return Container(
//             // padding: EdgeInsets.only(bottom: 100),
//             child: this
//                 .widget
//                 .onBuildItem(index, state.posts[index], state.posts.length),
//           );
//         }
//         return this
//             .widget
//             .onBuildItem(index, state.posts[index], state.posts.length);
//       },
//       reverse: this.widget.reverse,
//       itemCount:
//       state.hasReachedMax ? state.posts.length : state.posts.length + 1,
//       controller: _scrollController,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 0.9,
//         mainAxisSpacing: 13,
//         crossAxisSpacing: 13,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     final maxScroll = _scrollController.position.maxScrollExtent;
//     final currentScroll = _scrollController.position.pixels;
//     if (maxScroll - currentScroll <= _scrollThreshold) {
//       this.widget.onLoadMore();
//     }
//   }
// }
