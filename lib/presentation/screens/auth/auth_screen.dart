import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medace_app/core/constants/assets_path.dart';
import 'package:medace_app/core/constants/preferences_name.dart';
import 'package:medace_app/core/env.dart';
import 'package:medace_app/main.dart';
import 'package:medace_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:medace_app/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:medace_app/presentation/bloc/languages/languages_bloc.dart';
import 'package:medace_app/presentation/screens/auth/widget/languages_widget.dart';
import 'package:medace_app/presentation/screens/auth/widget/sign_in.dart';
import 'package:medace_app/presentation/screens/auth/widget/sign_up.dart';
import 'package:medace_app/theme/app_color.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const String routeName = '/authScreen';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => EditProfileBloc(),
        ),
      ],
      child: AuthScreenWidget(key: key),
    );
  }
}

class AuthScreenWidget extends StatefulWidget {
  const AuthScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreenWidget> createState() => _AuthScreenWidgetState();
}

class _AuthScreenWidgetState extends State<AuthScreenWidget> {
  String? get appLogo => preferences.getString(PreferencesName.appLogo);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.0), // here th
          child: AppBar(
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.white,
            leading: Navigator.of(context).canPop()
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: ColorApp.mainColor,
                    ),
                  )
                : const SizedBox(),
            title: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: CachedNetworkImage(
                width: 50.0,
                imageUrl: appLogo ?? '',
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) {
                  return SizedBox(
                    width: 83.0,
                    child: Image.asset(ImagePath.logo),
                  );
                },
              ),
            ),
            bottom: TabBar(
              indicatorColor: ColorApp.mainColor,
              tabs: [
                Tab(
                  icon: Text(
                    localizations.getLocalization('auth_sign_up_tab'),
                    style: TextStyle(color: ColorApp.mainColor),
                  ),
                ),
                Tab(
                  icon: Text(
                    localizations.getLocalization('auth_sign_in_tab'),
                    style: TextStyle(color: ColorApp.mainColor),
                  ),
                ),
              ],
            ),
            actions: [
              BlocListener<LanguagesBloc, LanguagesState>(
                listener: (context, state) {
                  if (state is SuccessChangeLanguageState) {
                    // Updated global variables for change translations
                    setState(() {
                      localizations.saveCustomLocalization(state.locale);
                    });

                    BlocProvider.of<LanguagesBloc>(context).add(LoadLanguagesEvent());
                  }
                },
                child: LanguagesWidget(),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: <Widget>[
              SingleChildScrollView(
                child: SignUpPage(),
              ),
              SingleChildScrollView(
                child: SignInPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
