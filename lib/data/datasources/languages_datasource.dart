import 'package:dio/dio.dart';
import 'package:medace_app/core/services/http_service.dart';
import 'package:medace_app/data/models/languages/languages_response.dart';

abstract class LanguagesDataSource {
  Future<List<LanguagesResponse>> getLanguages();

  Future<Map<String, dynamic>> getTranslations({String? langAbbr});
}

class LanguagesRemoteDataSource extends LanguagesDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<List<LanguagesResponse>> getLanguages() async {
    try {
      Response response = await _httpService.dio.get(
        '/languages',
      );

      var responseList = response.data as List;

      return responseList.map((e) => LanguagesResponse.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getTranslations({String? langAbbr}) async {
    try {
      Response response = await _httpService.dio.get(
        '/translations',
        queryParameters: {'lang': langAbbr},
      );

      return Future.value(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
