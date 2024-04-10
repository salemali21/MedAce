import 'dart:io';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';
import 'package:medace_app/presentation/screens/lesson_types/video_lesson/widgets/vdoplayback_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:medace_app/core/constants/preferences_name.dart';
import 'package:medace_app/core/env.dart';
import 'package:medace_app/core/routes/app_routes.dart';
import 'package:medace_app/data/repository/localization_repository.dart';
import 'package:medace_app/firebase_options.dart';
import 'package:medace_app/presentation/bloc/course/course_bloc.dart';
import 'package:medace_app/presentation/bloc/courses/user_courses_bloc.dart';
import 'package:medace_app/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:medace_app/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:medace_app/presentation/bloc/home_simple/home_simple_bloc.dart';
import 'package:medace_app/presentation/bloc/languages/languages_bloc.dart';
import 'package:medace_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:medace_app/presentation/bloc/search/search_screen_bloc.dart';
import 'package:medace_app/presentation/screens/auth/components/google_signin.dart';
import 'package:medace_app/presentation/screens/splash/splash_screen.dart';
import 'package:medace_app/theme/app_theme.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

LocalizationRepository localizations = LocalizationRepository();

bool dripContentEnabled = false;
bool? demoEnabled = false;
bool? googleOauth = false;
bool? facebookOauth = false;
bool appView = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.grey.withOpacity(0.4), // top bar color
      statusBarIconBrightness: Brightness.light, // top bar icons color
    ),
  );

  preferences = await SharedPreferences.getInstance();

  // Function for detect user have selected lang or not
  if (preferences.getString(PreferencesName.selectedLangAbbr) == null ||
      preferences.getString(PreferencesName.selectedLangAbbr) == '') {
    preferences.remove(PreferencesName.selectedLangAbbr);
  } else {
    preferences.setString(PreferencesName.selectedLangAbbr, preferences.getString(PreferencesName.selectedLangAbbr)!);
  }

  GoogleSignInProvider().initializeGoogleSignIn();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  appView = preferences.getBool(PreferencesName.appView) ?? false;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp() : super();

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeSimpleBloc>(
          create: (BuildContext context) => HomeSimpleBloc()..add(LoadHomeSimpleEvent()),
        ),
        BlocProvider<FavoritesBloc>(
          create: (BuildContext context) => FavoritesBloc(),
        ),
        BlocProvider<SearchScreenBloc>(
          create: (BuildContext context) => SearchScreenBloc(),
        ),
        BlocProvider<UserCoursesBloc>(
          create: (BuildContext context) => UserCoursesBloc(),
        ),
        BlocProvider<EditProfileBloc>(
          create: (BuildContext context) => EditProfileBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => ProfileBloc(),
        ),
        BlocProvider<CourseBloc>(
          create: (BuildContext context) => CourseBloc(),
        ),
        BlocProvider<LanguagesBloc>(
          create: (BuildContext context) => LanguagesBloc()..add(LoadLanguagesEvent()),
        ),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          title: 'MedAce',
          navigatorObservers: [VdoPlayerController.navigatorObserver('/player/(.*)')],
          theme: AppTheme().themeLight,
          initialRoute: SplashScreen.routeName,
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          onGenerateRoute: (RouteSettings settings) => AppRoutes().generateRoute(settings, context),
          onUnknownRoute: (RouteSettings settings) => AppRoutes().onUnknownRoute(settings, context),
        ),
      ),
    );
  }
}


// Vdo

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String? _nativePlatformLibraryVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    getNativeLibraryVersion();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getNativeLibraryVersion() async {
    String? version;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      version = await (Platform.isIOS ? VdocipherMethodChannel.nativeIOSAndroidLibraryVersion : VdocipherMethodChannel.nativeAndroidLibraryVersion);
    } on PlatformException {
      version = 'Failed to get native platform library version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _nativePlatformLibraryVersion = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('VdoCipher Sample Application'),
        ),
        body: Center(child: Column(
          children: <Widget>[
            Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _goToVideoPlayback,
                    child: const Text('Online Playback',
                        style: TextStyle(fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: null,
                    child: const Text('Todo: video selection',
                        style: TextStyle(fontSize: 20)),
                  )
                ])),
            Padding(padding: EdgeInsets.all(16.0),
                child: Text('Native ${Platform.isIOS ? 'iOS' : 'Android'} library version: $_nativePlatformLibraryVersion',
                    style: TextStyle(color: Colors.grey, fontSize: 16.0)))
          ],
        ))
    );
  }

  void _goToVideoPlayback() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: RouteSettings(name: '/player/sample/video'),
        builder: (BuildContext context) {
          return VdoPlaybackView();
        },
      ),
    );
  }
}
