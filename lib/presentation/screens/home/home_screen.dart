import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medace_app/data/models/app_settings/app_settings.dart';
import 'package:medace_app/presentation/bloc/home/home_bloc.dart';
import 'package:medace_app/presentation/screens/home/widgets/categories_widget.dart';
import 'package:medace_app/presentation/screens/home/widgets/new_courses_widget.dart';
import 'package:medace_app/presentation/screens/home/widgets/top_instructors_widget.dart';
import 'package:medace_app/presentation/screens/home/widgets/trending_widget.dart';
import 'package:medace_app/presentation/widgets/error_widget.dart';
import 'package:medace_app/presentation/widgets/loader_widget.dart';
import 'package:medace_app/theme/app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen() : super();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeEvent()),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: ColorApp.mainColor,
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is InitialHomeState) {
              return LoaderWidget(
                loaderColor: ColorApp.mainColor,
              );
            }

            if (state is LoadedHomeState) {
              return RefreshIndicator(
                onRefresh: () async => context.read<HomeBloc>().add(LoadHomeEvent()),
                child: ListView.builder(
                  itemCount: state.layout.length,
                  itemBuilder: (context, index) {
                    HomeLayoutBean? item = state.layout[index];

                    switch (item?.id) {
                      case 1:
                        return CategoriesWidget(item?.name, state.categoryList);
                      case 2:
                        return NewCoursesWidget(item?.name, state.coursesNew);
                      case 3:
                        return TrendingWidget(true, item?.name, state.coursesTrending);
                      case 4:
                        return TopInstructorsWidget(item?.name, state.instructors);
                      case 5:
                        return TrendingWidget(false, item?.name, state.coursesFree);
                      default:
                        return NewCoursesWidget(item?.name, state.coursesNew);
                    }
                  },
                ),
              );
            }

            if (state is ErrorHomeState) {
              return ErrorCustomWidget(
                onTap: () => context.read<HomeBloc>().add(LoadHomeEvent()),
              );
            }

            return ErrorCustomWidget(
              onTap: () => context.read<HomeBloc>().add(LoadHomeEvent()),
            );
          },
        ),
      ),
    );
  }
}
