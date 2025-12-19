import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/domain/use_cases/asset_upload_image.dart';
import 'package:ventura/features/auth/domain/entities/business_profile_draft.dart';

part 'business_creation_state.dart';

class BusinessCreationCubit extends Cubit<BusinessCreationState> {
  final AssetUploadImage _assetUploadImage;

  BusinessCreationCubit(AssetUploadImage assetUploadImage)
    : _assetUploadImage = assetUploadImage,
      super(BusinessCreationState(draft: BusinessProfileDraft()));

  void businessNameChanged(String name) {
    final updatedDraft = state.draft.copyWith(name: name);
    emit(BusinessCreationState(draft: updatedDraft));
  }

  void businessCategoryChanged(String category) {
    final updatedDraft = state.draft.copyWith(categories: [category]);
    emit(BusinessCreationState(draft: updatedDraft));
  }

  void businessDescriptionChanged(String description) {
    final updatedDraft = state.draft.copyWith(description: description);
    emit(BusinessCreationState(draft: updatedDraft));
  }

  void businessEmailChanged(String email) {
    final updatedDraft = state.draft.copyWith(email: email);
    emit(BusinessCreationState(draft: updatedDraft));
  }

  void businessPhoneChanged(String phone) {
    final updatedDraft = state.draft.copyWith(phone: phone);
    emit(BusinessCreationState(draft: updatedDraft));
  }

  void businessAddressChanged(String address) {
    final updatedDraft = state.draft.copyWith(address: address);
    emit(BusinessCreationState(draft: updatedDraft));
  }

  void businessCityChanged(String city) {
    final updatedDraft = state.draft.copyWith(city: city);
    emit(BusinessCreationState(draft: updatedDraft));
  }

  void businessStateChanged(String stateName) {
    final updatedDraft = state.draft.copyWith(state: stateName);
    emit(BusinessCreationState(draft: updatedDraft));
  }

  void businessCountryChanged(String country) {
    final updatedDraft = state.draft.copyWith(country: country);
    emit(BusinessCreationState(draft: updatedDraft));
  }

  void businessTagLineChanged(String tagLine) {
    final updatedDraft = state.draft.copyWith(tagLine: tagLine);
    emit(BusinessCreationState(draft: updatedDraft));
  }

  void businessLogoChanged(File? logo) async {
    if (logo == null) {
      final updatedDraft = state.draft.copyWith(
        logo: Optional(null),
      ); // ✅ Wrap null
      emit(BusinessCreationState(draft: updatedDraft));
      return;
    }
    emit(BusinessCreationState(draft: state.draft, isLoading: true));
    final res = await _assetUploadImage(AssetUploadImageParams(file: logo));
    res.fold(
      (failure) => emit(
        BusinessCreateStateUploadAssetFailed(
          message: failure.message,
          draft: state.draft,
          isLoading: false,
        ),
      ),
      (logoUrl) {
        final updatedDraft = state.draft.copyWith(logo: Optional(logoUrl));
        emit(BusinessCreationState(draft: updatedDraft, isLoading: false));
      },
    );
  }
}
