import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:test_load_more/features/loadmore/cubit/loadmore_state.dart';
import 'package:test_load_more/features/test/cubit/inifite_list_bloc.dart';
import 'package:test_load_more/features/test/view/test_screen.dart';
import 'package:test_load_more/post_model.dart';
import 'package:test_load_more/repository/test_repo.dart';
import 'dj/injection.dart';
import 'features/loadmore/cubit/loadmore_cubit.dart';
import 'features/loadmore/view/loadmore_w.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoadMoreCubit>(
          create: (context) =>
              LoadMoreCubit(GetIt.instance.get<ITestRepo>())..loadMoreData(),
        ),
        BlocProvider<PostBloc>(
          create: (context) => PostBloc(
            GetIt.instance.get<ITestRepo>(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TestInfinityListScreenRoot());
  }
}
