import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/features/sales/domain/entities/service_entity.dart';
import 'package:ventura/features/sales/domain/use_cases/create_service.dart';
import 'package:ventura/features/sales/domain/use_cases/delete_service.dart';
import 'package:ventura/features/sales/domain/use_cases/get_service_by_id.dart';
import 'package:ventura/features/sales/domain/use_cases/update_service.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final GetServiceById _getServiceById;
  final CreateService _createService;
  final UpdateService _updateService;
  final DeleteService _deleteService;

  ServiceBloc({
    required GetServiceById getServiceById,
    required CreateService createService,
    required UpdateService updateService,
    required DeleteService deleteService,
  }) : _getServiceById = getServiceById,
       _createService = createService,
       _updateService = updateService,
       _deleteService = deleteService,
       super(ServiceInitial()) {
    on<ServiceEvent>((event, emit) => emit(ServiceLoadingState()));
    on<ServiceGetByIdEvent>(_onServiceGetByIdEvent);
    on<ServiceCreateEvent>(_onServiceCreateEvent);
    on<ServiceUpdateEvent>(_onServiceUpdateEvent);
    on<ServiceDeleteEvent>(_onServiceDeleteEvent);
  }

  void _onServiceGetByIdEvent(
    ServiceGetByIdEvent event,
    Emitter<ServiceState> emit,
  ) async {
    final res = await _getServiceById(
      GetServiceByIdParams(
        serviceId: event.serviceId,
        businessId: event.businessId,
      ),
    );

    res.fold(
      (failure) => emit(ServiceErrorState(message: failure.message)),
      (service) => emit(ServiceLoadedState(service: service)),
    );
  }

  void _onServiceCreateEvent(
    ServiceCreateEvent event,
    Emitter<ServiceState> emit,
  ) async {
    final res = await _createService(
      CreateServiceParams(
        businessId: event.businessId,
        name: event.name,
        price: event.price,
        primaryImage: event.primaryImage,
        supportingImages: event.supportingImages,
        description: event.description,
        notes: event.notes,
        businessHours: event.businessHours,
      ),
    );

    res.fold(
      (failure) => emit(ServiceErrorState(message: failure.message)),
      (service) => emit(ServiceCreateSuccessState(service: service)),
    );
  }

  void _onServiceUpdateEvent(
    ServiceUpdateEvent event,
    Emitter<ServiceState> emit,
  ) async {
    final res = await _updateService(
      UpdateServiceParams(
        serviceId: event.serviceId,
        businessId: event.businessId,
        name: event.name,
        price: event.price,
        primaryImage: event.primaryImage,
        supportingImages: event.supportingImages,
        description: event.description,
        notes: event.notes,
        businessHours: event.businessHours,
      ),
    );

    res.fold(
      (failure) => emit(ServiceErrorState(message: failure.message)),
      (service) => emit(ServiceUpdateSuccessState(service: service)),
    );
  }

  void _onServiceDeleteEvent(
    ServiceDeleteEvent event,
    Emitter<ServiceState> emit,
  ) async {
    final res = await _deleteService(
      DeleteServiceParams(
        serviceId: event.serviceId,
        businessId: event.businessId,
      ),
    );

    res.fold(
      (failure) => emit(ServiceErrorState(message: failure.message)),
      (message) => emit(ServiceDeleteSuccessState(message: message)),
    );
  }
}
