part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState {}

class InitialEditProfileState extends EditProfileState {}

class LoadingEditProfileState extends EditProfileState {}

class UpdatedEditProfileState extends EditProfileState {}

class CloseEditProfileState extends EditProfileState {}

class ErrorEditProfileState extends EditProfileState {
  ErrorEditProfileState(this.message);

  final String? message;
}

//Delete Account State
class LoadingDeleteAccountState extends EditProfileState {}

class SuccessDeleteAccountState extends EditProfileState {}

class ErrorDeleteAccountState extends EditProfileState {}
