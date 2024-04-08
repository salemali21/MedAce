import 'dart:io';

import 'package:dio/dio.dart';
import 'package:medace_app/core/services/http_service.dart';
import 'package:medace_app/data/models/assignment/assignment_response.dart';

abstract class AssignmentDataSource {
  Future<AssignmentResponse> getAssignmentInfo(int courseId, int assignmentId);

  Future startAssignment(int courseId, int assignmentId);

  Future addAssignment(int courseId, int userAssignmentId, String content);

  Future<String> uploadAssignmentFile(int courseId, int userAssignmentId, File file);
}

class AssignmentRemoteDataSource extends AssignmentDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<AssignmentResponse> getAssignmentInfo(int courseId, int assignmentId) async {
    try {
      Map<String, int> data = {
        'course_id': courseId,
        'assignment_id': assignmentId,
      };

      Response response = await _httpService.dio.post(
        '/assignment',
        data: data,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return AssignmentResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future startAssignment(int courseId, int assignmentId) async {
    try {
      Map<String, int> data = {
        'course_id': courseId,
        'assignment_id': assignmentId,
      };

      Response response = await _httpService.dio.put(
        '/assignment/start',
        data: data,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future addAssignment(int courseId, int userAssignmentId, String content) async {
    try {
      Map<String, dynamic> map = {
        'course_id': courseId,
        'user_assignment_id': userAssignmentId,
        'content': content,
      };

      Response response = await _httpService.dio.post(
        '/assignment/add',
        data: map,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<String> uploadAssignmentFile(int courseId, int userAssignmentId, File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'course_id': courseId,
        'user_assignment_id': userAssignmentId,
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      Response response = await _httpService.dio.post(
        '/assignment/add/file',
        data: formData,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );
      return response.toString();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
