import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/features/appointment/domain/entities/appointment_entity.dart';
import 'package:ventura/features/appointment/domain/use_cases/create_appointment.dart';
import 'package:ventura/features/appointment/domain/use_cases/delete_appointment.dart';
import 'package:ventura/features/appointment/domain/use_cases/get_user_appointment.dart';
import 'package:ventura/features/appointment/domain/use_cases/update_appointment.dart';
import 'package:ventura/features/appointment/domain/use_cases/update_google_event_id.dart';

part 'appointment_event.dart';

part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final CreateAppointment _createAppointment;
  final UpdateAppointment _updateAppointment;
  final UpdateGoogleEventId _updateGoogleEventId;
  final GetUserAppointment _getUserAppointment;
  final DeleteAppointment _deleteAppointment;

  AppointmentBloc({
    required CreateAppointment createAppointment,
    required UpdateAppointment updateAppointment,
    required UpdateGoogleEventId updateGoogleEventId,
    required GetUserAppointment getUserAppointment,
    required DeleteAppointment deleteAppointment,
  }) : _createAppointment = createAppointment,
       _updateAppointment = updateAppointment,
       _updateGoogleEventId = updateGoogleEventId,
       _getUserAppointment = getUserAppointment,
       _deleteAppointment = deleteAppointment,
       super(AppointmentInitial()) {
    on<AppointmentEvent>((event, emit) => emit(AppointmentLoadingState()));
    on<AppointmentCreateEvent>(_onAppointmentCreateEvent);
    on<AppointmentUpdateEvent>(_onAppointmentUpdateEvent);
    on<AppointmentGetEvent>(_onAppointmentGetEvent);
    on<AppointmentDeleteEvent>(_onAppointmentDeleteEvent);
    on<AppointmentUpdateGoogleIdEvent>(_onAppointmentUpdateGoogleIdEvent);
  }

  void _onAppointmentCreateEvent(
    AppointmentCreateEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    final res = await _createAppointment(
      CreateAppointmentParams(
        title: event.title,
        startTime: event.startTime,
        endTime: event.endTime,
        isRecurring: event.isRecurring,
        userId: event.userId,
        businessId: event.businessId,
        description: event.description,
        notes: event.notes,
        recurringUntil: event.recurringUntil,
        recurringFrequency: event.recurringFrequency,
      ),
    );
    res.fold(
      (failure) => emit(AppointmentErrorState(message: failure.message)),
      (appointment) =>
          emit(AppointmentCreateSuccessState(appointment: appointment)),
    );
  }

  void _onAppointmentUpdateEvent(
    AppointmentUpdateEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    final res = await _updateAppointment(
      UpdateAppointmentParams(
        appointmentId: event.appointmentId,
        title: event.title,
        startTime: event.startTime,
        endTime: event.endTime,
        isRecurring: event.isRecurring,
        userId: event.userId,
        businessId: event.businessId,
        description: event.description,
        notes: event.notes,
        recurringUntil: event.recurringUntil,
        recurringFrequency: event.recurringFrequency,
      ),
    );

    res.fold(
      (failure) => emit(AppointmentErrorState(message: failure.message)),
      (appointment) =>
          emit(AppointmentUpdateSuccessState(appointment: appointment)),
    );
  }

  void _onAppointmentGetEvent(
    AppointmentGetEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    if (event.userId != null) {
      final res = await _getUserAppointment(
        GetUserAppointmentsParams(userId: event.userId!),
      );
      res.fold(
        (failure) => emit(AppointmentErrorState(message: failure.message)),
        (appointments) =>
            emit(AppointmentGetSuccessState(appointments: appointments)),
      );
    } else if (event.businessId != null) {
      final res = await _getUserAppointment(
        GetUserAppointmentsParams(userId: event.businessId!),
      );
      res.fold(
        (failure) => emit(AppointmentErrorState(message: failure.message)),
        (appointments) =>
            emit(AppointmentGetSuccessState(appointments: appointments)),
      );
    } else {
      emit(AppointmentErrorState(message: 'No user or business id provided'));
    }
  }

  void _onAppointmentUpdateGoogleIdEvent(
    AppointmentUpdateGoogleIdEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    final res = await _updateGoogleEventId(
      UpdateGoogleEventIdParams(
        appointmentId: event.appointmentId,
        googleEventId: event.googleEventId,
        userId: event.userId,
        businessId: event.businessId,
      ),
    );
    res.fold(
      (failure) => emit(AppointmentErrorState(message: failure.message)),
      (appointment) =>
          emit(AppointmentUpdateSuccessState(appointment: appointment)),
    );
  }

  void _onAppointmentDeleteEvent(
    AppointmentDeleteEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    // Store current appointments before deletion
    List<Appointment>? currentAppointments;
    if (state is AppointmentGetSuccessState) {
      currentAppointments = (state as AppointmentGetSuccessState).appointments;
    }

    final res = await _deleteAppointment(
      DeleteAppointmentParams(
        appointmentId: event.appointmentId,
        businessId: event.businessId,
        userId: event.userId,
      ),
    );
    res.fold(
      (failure) => emit(AppointmentErrorState(message: failure.message)),
      (message) {
        // First emit delete success
        emit(AppointmentDeleteSuccessState(message: message));

        // Then update the appointments list by removing the deleted one
        if (currentAppointments != null) {
          final updatedAppointments = currentAppointments
              .where((apt) => apt.id != event.appointmentId)
              .toList();
          emit(AppointmentGetSuccessState(appointments: updatedAppointments));
        }
      },
    );
  }
}
