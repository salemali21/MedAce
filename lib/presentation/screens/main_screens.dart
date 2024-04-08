import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medace_app/core/constants/assets_path.dart';
import 'package:medace_app/core/utils/utils.dart';
import 'package:medace_app/main.dart';
import 'package:medace_app/presentation/bloc/languages/languages_bloc.dart';
import 'package:medace_app/presentation/screens/auth/auth_screen.dart';
import 'package:medace_app/presentation/screens/courses/courses_screen.dart';
import 'package:medace_app/presentation/screens/favorites/favorites_screen.dart';
import 'package:medace_app/presentation/screens/home/home_screen.dart';
import 'package:medace_app/presentation/screens/home_simple/home_simple_screen.dart';
import 'package:medace_app/presentation/screens/profile/profile_screen.dart';
import 'package:medace_app/presentation/screens/search/search_screen.dart';
import 'package:medace_app/theme/app_color.dart';

class MainScreenArgs {
  MainScreenArgs({this.selectedIndex});

  final int? selectedIndex;
}

class MainScreen extends StatelessWidget {
  static const String routeName = '/mainScreen';

  @override
  Widget build(BuildContext context) {
    final MainScreenArgs args = ModalRoute.of(context)?.settings.arguments as MainScreenArgs;

    return MainScreenWidget(selectedIndex: args.selectedIndex);
  }
}

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({this.selectedIndex}) : super();

  final int? selectedIndex;

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreenWidget> {
  int _selectedIndex = 0;
  final _selectedItemColor = ColorApp.mainColor;
  final _unselectedItemColor = ColorApp.unselectedColor;

  @override
  void initState() {
    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LanguagesBloc, LanguagesState>(
        listener: (context, state) {
          if (state is SuccessChangeLanguageState) {
            // Used this func for update bottom navigation bar variables
            // If removed this func, variables not apply for navigation bar text
            // When we changed language on auth screen
            setState(() {
              localizations.saveCustomLocalization(state.locale);
            });
          }
        },
        child: _getBody(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5.0,
        selectedFontSize: 10,
        backgroundColor: ColorApp.bgColor,
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) async {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navHome, 0),
            label: localizations.getLocalization('home_bottom_nav'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navCourses, 1),
            label: localizations.getLocalization('search_bottom_nav'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navPlay, 2),
            label: localizations.getLocalization('courses_bottom_nav'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navFavourites, 3),
            label: localizations.getLocalization('favorites_bottom_nav'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(IconPath.navProfile, 4),
            label: localizations.getLocalization('profile_bottom_nav'),
          ),
        ],
      ),
    );
  }

  Color? _getItemColor(int index) => _selectedIndex == index ? _selectedItemColor : _unselectedItemColor;

  Widget _buildIcon(String iconData, int index) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SvgPicture.asset(
          iconData,
          height: 22.0,
          color: _getItemColor(index),
        ),
      );

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return appView ? HomeSimpleScreen() : HomeScreen();
      case 1:
        return SearchScreen();
      case 2:
        return CoursesScreen();
      case 3:
        return FavoritesScreen();
      case 4:
        if (!isAuth()) {
          return AuthScreen();
        } else {
          return ProfileScreen();
        }
      default:
        return Center(
          child: Text(
            'Not implemented!',
            textScaleFactor: 1.0,
          ),
        );
    }
  }
}
