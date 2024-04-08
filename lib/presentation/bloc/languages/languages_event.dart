part of 'languages_bloc.dart';

abstract class LanguagesEvent {}

class LoadLanguagesEvent extends LanguagesEvent {}

class SelectLanguageEvent extends LanguagesEvent {
  SelectLanguageEvent(this.langAbbr);

  final String langAbbr;
}
