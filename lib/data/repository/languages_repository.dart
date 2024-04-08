import 'package:medace_app/data/datasources/languages_datasource.dart';
import 'package:medace_app/data/models/languages/languages_response.dart';

abstract class LanguagesRepository {
  Future<List<LanguagesResponse>> getLanguages();

  Future<Map<String, dynamic>> getTranslations({String? langAbbr});
}

class LanguagesRepositoryImpl extends LanguagesRepository {
  final LanguagesDataSource _languagesDataSource = LanguagesRemoteDataSource();

  @override
  Future<List<LanguagesResponse>> getLanguages() async => await _languagesDataSource.getLanguages();

  @override
  Future<Map<String, dynamic>> getTranslations({String? langAbbr}) async =>
      _languagesDataSource.getTranslations(langAbbr: langAbbr);
}
