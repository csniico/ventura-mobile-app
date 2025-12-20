part of 'business_creation_cubit.dart';

@immutable
class BusinessCreationState {
  final BusinessProfileDraft draft;
  final bool? isLoading;
  final User user;

  const BusinessCreationState({
    required this.draft,
    required this.user,
    this.isLoading,
  });
}

class BusinessCreateFailed extends BusinessCreationState {
  final String message;

  const BusinessCreateFailed({
    required this.message,
    required super.draft,
    super.isLoading,
    required super.user,
  });
}

class BusinessCreateSuccess extends BusinessCreationState {
  final Business business;

  const BusinessCreateSuccess({
    required this.business,
    required super.draft,
    super.isLoading,
    required super.user,
  });
}

class BusinessCreateStateUploadAssetFailed extends BusinessCreationState {
  final String message;

  const BusinessCreateStateUploadAssetFailed({
    required this.message,
    required super.draft,
    super.isLoading,
    required super.user,
  });
}
