import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:test_load_more/features/test/cubit/inifite_list_bloc.dart';
import 'package:test_load_more/features/test/cubit/inifite_list_state.dart';
import 'package:test_load_more/repository/test_repo.dart';

class TestInfinityListScreenRoot extends StatelessWidget {
  const TestInfinityListScreenRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(
        GetIt.instance.get<ITestRepo>(),
      )..fetchPosts(0, 10),
      child: const TestInfinityListScreen(),
    );
  }
}

class TestInfinityListScreen extends StatefulWidget {
  const TestInfinityListScreen({Key? key}) : super(key: key);

  @override
  State<TestInfinityListScreen> createState() => _TestInfinityListScreenState();
}

class _TestInfinityListScreenState extends State<TestInfinityListScreen> {
  @override
  void initState() {
    // BlocProvider.of<PostBloc>(context).scrollController.addListener(
    //       BlocProvider.of<PostBloc>(context).loadMore,
    //     );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Data Fetching Example'),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoaded) {
            return RefreshIndicator(
              onRefresh: () {
                return Future.value(
                  [
                    Future.delayed(
                      Duration(
                        milliseconds: 500,
                      ),
                    ),
                    context.read<PostBloc>().refresh()
                  ],
                );
              },
              child: ListView.builder(
                controller: BlocProvider.of<PostBloc>(context).scrollController,
                itemCount: state.posts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Text('${state.posts?[index].id}'),
                    title: Text(state.posts?[index].title ?? ''),
                    subtitle: Text(
                      state.posts?[index].body ?? '',
                      style: const TextStyle(color: Colors.yellow),
                    ),
                  );
                },
              ),
            );
          } else if (state is PostError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
