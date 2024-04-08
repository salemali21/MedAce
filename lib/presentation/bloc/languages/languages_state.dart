part of 'languages_bloc.dart';

@immutable
abstract class LanguagesState {}

class InitialLanguagesState extends LanguagesState {}

class LoadingLanguagesState extends LanguagesState {}

class LoadedLanguagesState extends LanguagesState {
  LoadedLanguagesState({required this.languagesResponse});

  final List<LanguagesResponse> languagesResponse;
}

class ErrorLanguagesState extends LanguagesState {
  ErrorLanguagesState(this.message);

  final String? message;
}

class LoadingChangeLanguageState extends LanguagesState {}

class SuccessChangeLanguageState extends LanguagesState {
  SuccessChangeLanguageState(this.locale);

  final Map<String, dynamic> locale;
}
