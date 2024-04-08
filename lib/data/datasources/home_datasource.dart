import 'package:dio/dio.dart';
import 'package:medace_app/core/services/http_service.dart';
import 'package:medace_app/data/models/app_settings/app_settings.dart';
import 'package:medace_app/data/models/category/category.dart';

abstract class HomeDataSource {
  Future<AppSettings> getAppSettings();

  Future<List<Category>> getCategories();
}

class HomeRemoteDataSource extends HomeDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<AppSettings> getAppSettings() async {
    try {
      Response response = await _httpService.dio.get('/app_settings');

      return AppSettings.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      Response response = await _httpService.dio.get('/categories');
      return (response.data as List).map((value) {
        return Category.fromJson(value);
      }).toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
