import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/domain/use_cases/asset_upload_image.dart';
import 'package:ventura/core/domain/use_cases/remote_update_user_profile.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final logger = AppLogger('UserProfileCubit');
  final RemoteUpdateUserProfile _remoteUpdateUserProfile;
  final AssetUploadImage _assetUploadImage;

  UserProfileCubit({
    required RemoteUpdateUserProfile remoteUpdateUserProfile,
    required AssetUploadImage assetUploadImage,
  }) : _remoteUpdateUserProfile = remoteUpdateUserProfile,
       _assetUploadImage = assetUploadImage,
       super(UserProfileInitial());

  Future<void> uploadAvatar({required File imageFile}) async {
    emit(UserProfileUploading());

    final result = await _assetUploadImage(
      AssetUploadImageParams(file: imageFile),
    );

    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (imageUrl) => emit(UserProfileAvatarUploaded(imageUrl)),
    );
  }

  Future<void> updateProfile({
    required String userId,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  }) async {
    emit(UserProfileUpdating());

    final result = await _remoteUpdateUserProfile(
      RemoteUpdateUserProfileParams(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: avatarUrl,
      ),
    );

    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (user) => emit(UserProfileUpdated(user)),
    );
  }

  void reset() {
    emit(UserProfileInitial());
  }
}
