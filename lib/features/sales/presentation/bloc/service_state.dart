part of 'service_bloc.dart';

@immutable
sealed class ServiceState {}

final class ServiceInitial extends ServiceState {}

final class ServiceLoadingState extends ServiceState {}

final class ServiceLoadedState extends ServiceState {
  final Service service;

  ServiceLoadedState({required this.service});
}

final class ServiceCreateSuccessState extends ServiceState {
  final Service service;

  ServiceCreateSuccessState({required this.service});
}

final class ServiceUpdateSuccessState extends ServiceState {
  final Service service;

  ServiceUpdateSuccessState({required this.service});
}

final class ServiceDeleteSuccessState extends ServiceState {
  final String message;

  ServiceDeleteSuccessState({required this.message});
}

final class ServiceErrorState extends ServiceState {
  final String message;

  ServiceErrorState({required this.message});
}
