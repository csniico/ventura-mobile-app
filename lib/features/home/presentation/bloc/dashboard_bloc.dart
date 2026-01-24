import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/features/home/domain/entities/dashboard_entity.dart';
import 'package:ventura/features/home/domain/use_cases/get_dashboard_data.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardData _getDashboardData;

  DashboardBloc({required GetDashboardData getDashboardData})
    : _getDashboardData = getDashboardData,
      super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) => emit(DashboardLoading()));
    on<DashboardLoadEvent>(_onDashboardLoadEvent);
  }

  void _onDashboardLoadEvent(
    DashboardLoadEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final res = await _getDashboardData(
      GetDashboardDataParams(businessId: event.businessId),
    );

    res.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (dashboard) => emit(DashboardLoaded(dashboard: dashboard)),
    );
  }
}
