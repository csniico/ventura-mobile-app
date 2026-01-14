part of 'customer_bloc.dart';

@immutable
sealed class CustomerEvent {}

final class CustomerGetEvent extends CustomerEvent {
  final String businessId;
  final int? page;
  final int? limit;

  CustomerGetEvent({required this.businessId, this.page, this.limit});
}

final class CustomerGetByIdEvent extends CustomerEvent {
  final String customerId;
  final String businessId;

  CustomerGetByIdEvent({required this.customerId, required this.businessId});
}

final class CustomerCreateEvent extends CustomerEvent {
  final String businessId;
  final String name;
  final String? email;
  final String? phone;
  final String? notes;

  CustomerCreateEvent({
    required this.businessId,
    required this.name,
    this.email,
    this.phone,
    this.notes,
  });
}

final class CustomerUpdateEvent extends CustomerEvent {
  final String customerId;
  final String businessId;
  final String? name;
  final String? email;
  final String? phone;
  final String? notes;

  CustomerUpdateEvent({
    required this.customerId,
    required this.businessId,
    this.name,
    this.email,
    this.phone,
    this.notes,
  });
}

final class CustomerDeleteEvent extends CustomerEvent {
  final String customerId;
  final String businessId;

  CustomerDeleteEvent({required this.customerId, required this.businessId});
}
