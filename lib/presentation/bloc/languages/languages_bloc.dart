import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:medace_app/core/constants/preferences_name.dart';
import 'package:medace_app/core/env.dart';
import 'package:medace_app/core/utils/logger.dart';
import 'package:medace_app/data/models/languages/languages_response.dart';
import 'package:medace_app/data/repository/home_repository.dart';
import 'package:medace_app/data/repository/languages_repository.dart';
import 'package:medace_app/main.dart';

part 'languages_event.dart';

part 'languages_state.dart';

class LanguagesBloc extends Bloc<LanguagesEvent, LanguagesState> {
  LanguagesBloc() : super(InitialLanguagesState()) {
    on<LoadLanguagesEvent>((event, emit) async {
      emit(LoadingLanguagesState());
      try {
        final List<LanguagesResponse> languagesResponse = await _languagesRepository.getLanguages();

        emit(LoadedLanguagesState(languagesResponse: languagesResponse));
      } catch (e, s) {
        logger.e('Error with method getLanguages() - Languages Bloc', e, s);
        emit(ErrorLanguagesState(e.toString()));
      }
    });

    on<SelectLanguageEvent>((event, emit) async {
      emit(LoadingChangeLanguageState());
      try {
        preferences.setString(PreferencesName.selectedLangAbbr, event.langAbbr);

        // Load translations
        Map<String, dynamic> locale = await _languagesRepository.getTranslations(langAbbr: event.langAbbr);

        _homeRepository.saveLocalizationLocal(locale);

        localizations.saveCustomLocalization(locale);

        emit(SuccessChangeLanguageState(locale));
      } catch (e, s) {
        logger.e('Error with set language method', e, s);
      }
    });
  }

  final LanguagesRepository _languagesRepository = LanguagesRepositoryImpl();
  final HomeRepository _homeRepository = HomeRepositoryImpl();
}
