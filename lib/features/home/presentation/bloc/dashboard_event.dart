part of 'dashboard_bloc.dart';

sealed class DashboardEvent {}

final class DashboardLoadEvent extends DashboardEvent {
  final String businessId;

  DashboardLoadEvent({required this.businessId});
}
