import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medace_app/core/constants/preferences_name.dart';
import 'package:medace_app/core/env.dart';
import 'package:medace_app/presentation/bloc/languages/languages_bloc.dart';
import 'package:medace_app/presentation/widgets/loader_widget.dart';
import 'package:medace_app/theme/app_color.dart';

class LanguagesWidget extends StatelessWidget {
  const LanguagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguagesBloc, LanguagesState>(
      builder: (context, state) {
        if (state is LoadingChangeLanguageState || state is LoadingLanguagesState) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: LoaderWidget(
              loaderColor: ColorApp.mainColor,
            ),
          );
        }

        if (state is LoadedLanguagesState) {
          return PopupMenuButton(
            // TODO: 02.08.2023: Add translation
            tooltip: 'Change language',
            itemBuilder: (BuildContext context) {
              return state.languagesResponse.map((e) {
                return PopupMenuItem(
                  value: e.code,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.nativeName,
                        style: TextStyle(color: Colors.black),
                      ),
                      if (preferences.getString(PreferencesName.selectedLangAbbr) == e.code)
                        Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                    ],
                  ),
                );
              }).toList();
            },
            onSelected: (String selectedLanguage) {
              BlocProvider.of<LanguagesBloc>(context).add(SelectLanguageEvent(selectedLanguage));
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.language_outlined,
                  color: ColorApp.mainColor,
                ),
              ),
            ),
          );
        }

        if (state is ErrorLanguagesState) {
          return IconButton(
            onPressed: () => BlocProvider.of<LanguagesBloc>(context).add(LoadLanguagesEvent()),
            icon: Icon(Icons.error_outline_outlined),
          );
        }

        return const SizedBox();
      },
    );
  }
}
