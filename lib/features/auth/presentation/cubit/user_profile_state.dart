part of 'user_profile_cubit.dart';

sealed class UserProfileState {}

final class UserProfileInitial extends UserProfileState {}

final class UserProfileUploading extends UserProfileState {}

final class UserProfileAvatarUploaded extends UserProfileState {
  final String imageUrl;

  UserProfileAvatarUploaded(this.imageUrl);
}

final class UserProfileUpdating extends UserProfileState {}

final class UserProfileUpdated extends UserProfileState {
  final User user;

  UserProfileUpdated(this.user);
}

final class UserProfileError extends UserProfileState {
  final String message;

  UserProfileError(this.message);
}
