import 'package:dio/dio.dart';
import 'package:medace_app/core/services/http_service.dart';
import 'package:medace_app/data/models/final_response/final_response.dart';

abstract class FinalDataSource {
  Future<FinalResponse> getCourseResults(int courseId);
}

class FinalRemoteDataSource extends FinalDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<FinalResponse> getCourseResults(int courseId) async {
    try {
      Response response = await _httpService.dio.post(
        '/course/results',
        data: {'course_id': courseId},
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );
      return FinalResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
