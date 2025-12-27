import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/domain/entities/business_entity.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/domain/use_cases/asset_upload_image.dart';
import 'package:ventura/core/domain/use_cases/local_save_business.dart';
import 'package:ventura/core/domain/use_cases/local_save_user.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/auth/domain/entities/business_profile_draft.dart';
import 'package:ventura/features/auth/domain/use_cases/create_business_profile.dart';

part 'business_creation_state.dart';

class BusinessCreationCubit extends Cubit<BusinessCreationState> {
  final AssetUploadImage _assetUploadImage;
  final CreateBusinessProfile _createBusinessProfile;
  final LocalSaveBusiness _localSaveBusiness;
  final LocalSaveUser _localSaveUser;

  BusinessCreationCubit({
    required AssetUploadImage assetUploadImage,
    required CreateBusinessProfile createBusinessProfile,
    required LocalSaveBusiness localSaveBusiness,
    required LocalSaveUser localSaveUser,
  }) : _createBusinessProfile = createBusinessProfile,
       _localSaveBusiness = localSaveBusiness,
       _localSaveUser = localSaveUser,
       _assetUploadImage = assetUploadImage,
       super(
         BusinessCreationState(
           draft: BusinessProfileDraft(),
           user: User(
             id: '',
             email: '',
             googleId: '',
             shortId: '',
             firstName: '',
             isSystem: false,
             isActive: false,
             isEmailVerified: false,
             businessId: '',
           ),
         ),
       );

  void initialize(User user) {
    emit(BusinessCreationState(draft: state.draft, user: user));
  }

  void createBusinessProfile() async {
    emit(
      BusinessCreationState(
        draft: state.draft,
        isLoading: true,
        user: state.user,
      ),
    );
    Business businessProfile = Business(
      name: state.draft.name!,
      categories: state.draft.categories ?? [],
      description: state.draft.description,
      email: state.draft.email,
      phone: state.draft.phone,
      address: state.draft.address,
      city: state.draft.city,
      state: state.draft.state,
      country: state.draft.country,
      tagLine: state.draft.tagLine,
      logo: state.draft.logo,
      id: '',
      shortId: '',
      ownerId: state.user.id,
    );
    final res = await _createBusinessProfile(
      CreateBusinessProfileParams(business: businessProfile),
    );
    res.fold(
      (failure) => emit(
        BusinessCreateFailed(
          message: failure.message,
          draft: state.draft,
          user: state.user,
        ),
      ),
      (business) async {
        final businessSaveResult = await _localSaveBusiness(
          BusinessParams(business: business),
        );

        businessSaveResult.fold(
          (failure) {
            emit(
              BusinessCreateFailed(
                message: 'Failed to save business locally: ${failure.message}',
                draft: state.draft,
                user: state.user,
              ),
            );
            return;
          },
          (_) {}, // Business saved successfully, continue,
        );
        final updatedUser = state.user.copyWith(businessId: business.id);
        final userSaveResult = await _localSaveUser(
          UserParams(user: updatedUser),
        );
        userSaveResult.fold(
          (failure) {
            emit(
              BusinessCreateFailed(
                message: 'Failed to save user locally: ${failure.message}',
                draft: state.draft,
                user: state.user,
              ),
            );
          },
          (_) {
            // Both saves successful
            emit(
              BusinessCreateSuccess(
                draft: state.draft,
                business: business,
                user: updatedUser,
              ),
            );
          },
        );
      },
    );
  }

  void businessNameChanged(String name) {
    final updatedDraft = state.draft.copyWith(name: name);
    emit(BusinessCreationState(draft: updatedDraft, user: state.user));
  }

  void businessCategoryChanged(String category) {
    final updatedDraft = state.draft.copyWith(categories: [category]);
    emit(BusinessCreationState(draft: updatedDraft, user: state.user));
  }

  void businessDescriptionChanged(String description) {
    final updatedDraft = state.draft.copyWith(description: description);
    emit(BusinessCreationState(draft: updatedDraft, user: state.user));
  }

  void businessEmailChanged(String email) {
    final updatedDraft = state.draft.copyWith(email: email);
    emit(BusinessCreationState(draft: updatedDraft, user: state.user));
  }

  void businessPhoneChanged(String phone) {
    final updatedDraft = state.draft.copyWith(phone: phone);
    emit(BusinessCreationState(draft: updatedDraft, user: state.user));
  }

  void businessAddressChanged(String address) {
    final updatedDraft = state.draft.copyWith(address: address);
    emit(BusinessCreationState(draft: updatedDraft, user: state.user));
  }

  void businessCityChanged(String city) {
    final updatedDraft = state.draft.copyWith(city: city);
    emit(BusinessCreationState(draft: updatedDraft, user: state.user));
  }

  void businessStateChanged(String stateName) {
    final updatedDraft = state.draft.copyWith(state: stateName);
    emit(BusinessCreationState(draft: updatedDraft, user: state.user));
  }

  void businessCountryChanged(String country) {
    final updatedDraft = state.draft.copyWith(country: country);
    emit(BusinessCreationState(draft: updatedDraft, user: state.user));
  }

  void businessTagLineChanged(String tagLine) {
    final updatedDraft = state.draft.copyWith(tagLine: tagLine);
    emit(BusinessCreationState(draft: updatedDraft, user: state.user));
  }

  void businessLogoChanged(File? logo) async {
    if (logo == null) {
      final updatedDraft = state.draft.copyWith(
        logo: Optional(null),
      );
      emit(BusinessCreationState(draft: updatedDraft, user: state.user));
      return;
    }
    emit(
      BusinessCreationState(
        draft: state.draft,
        isLoading: true,
        user: state.user,
      ),
    );
    final res = await _assetUploadImage(AssetUploadImageParams(file: logo));
    res.fold(
      (failure) => emit(
        BusinessCreateStateUploadAssetFailed(
          message: failure.message,
          draft: state.draft,
          isLoading: false,
          user: state.user,
        ),
      ),
      (logoUrl) {
        final updatedDraft = state.draft.copyWith(logo: Optional(logoUrl));
        emit(
          BusinessCreationState(
            draft: updatedDraft,
            isLoading: false,
            user: state.user,
          ),
        );
      },
    );
  }
}
