part of 'business_creation_cubit.dart';

@immutable
class BusinessCreationState {
  final BusinessProfileDraft draft;
  final bool? isLoading;

  const BusinessCreationState({required this.draft, this.isLoading});
}

class BusinessCreateStateUploadAssetFailed extends BusinessCreationState {
  final String message;

  const BusinessCreateStateUploadAssetFailed({
    required this.message,
    required super.draft,
    super.isLoading,
  });
}
