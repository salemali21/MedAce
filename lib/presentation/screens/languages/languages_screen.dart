import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medace_app/core/constants/preferences_name.dart';
import 'package:medace_app/core/env.dart';
import 'package:medace_app/main.dart';
import 'package:medace_app/presentation/bloc/languages/languages_bloc.dart';
import 'package:medace_app/presentation/widgets/error_widget.dart';
import 'package:medace_app/presentation/widgets/loader_widget.dart';
import 'package:medace_app/theme/app_color.dart';
import 'package:medace_app/theme/const_styles.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  static const String routeName = '/languagesScreen';

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  @override
  void initState() {
    BlocProvider.of<LanguagesBloc>(context).add(LoadLanguagesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorApp.mainColor,
        centerTitle: true,
        title: Text(
          // TODO: 19.07.2023 Add translations
          localizations.getLocalization('edit_profile_title'),
          style: kAppBarTextStyle,
        ),
      ),
      body: BlocListener<LanguagesBloc, LanguagesState>(
        listener: (context, state) {
          if (state is SuccessChangeLanguageState) {
            // Updated global variables for change translations
            setState(() {
              localizations.saveCustomLocalization(state.locale);
            });

            BlocProvider.of<LanguagesBloc>(context).add(LoadLanguagesEvent());
          }
        },
        child: BlocBuilder<LanguagesBloc, LanguagesState>(
          builder: (context, state) {
            if (state is LoadingLanguagesState) {
              return LoaderWidget(
                loaderColor: ColorApp.mainColor,
              );
            }
            if (state is LoadedLanguagesState) {
              return SafeArea(
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: state.languagesResponse.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = state.languagesResponse[index];
                        return InkWell(
                          onTap: () {
                            BlocProvider.of<LanguagesBloc>(context).add(SelectLanguageEvent(item.code));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item.nativeName,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Image.network(item.countryFlagUrl),
                                  ],
                                ),
                                if (preferences.getString(PreferencesName.selectedLangAbbr) == item.code)
                                  Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            if (state is LoadingChangeLanguageState) {
              return Center(
                child: LoaderWidget(
                  loaderColor: ColorApp.mainColor,
                ),
              );
            }

            if (state is ErrorLanguagesState) {
              return ErrorCustomWidget(onTap: () => BlocProvider.of<LanguagesBloc>(context).add(LoadLanguagesEvent()));
            }

            return ErrorCustomWidget(onTap: () => BlocProvider.of<LanguagesBloc>(context).add(LoadLanguagesEvent()));
          },
        ),
      ),
    );
  }
}
