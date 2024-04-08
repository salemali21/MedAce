import 'package:medace_app/data/models/auth/auth_error.dart';

class AuthError implements Exception {
  AuthError(this.authErrorResponse);

  final AuthErrorResponse authErrorResponse;
}
