part of 'service_bloc.dart';

@immutable
sealed class ServiceEvent {}

final class ServiceGetByIdEvent extends ServiceEvent {
  final String serviceId;
  final String businessId;

  ServiceGetByIdEvent({required this.serviceId, required this.businessId});
}

final class ServiceCreateEvent extends ServiceEvent {
  final String businessId;
  final String name;
  final double price;
  final String? primaryImage;
  final List<String>? supportingImages;
  final String? description;
  final String? notes;
  final Map<String, dynamic>? businessHours;

  ServiceCreateEvent({
    required this.businessId,
    required this.name,
    required this.price,
    this.primaryImage,
    this.supportingImages,
    this.description,
    this.notes,
    this.businessHours,
  });
}

final class ServiceUpdateEvent extends ServiceEvent {
  final String serviceId;
  final String businessId;
  final String? name;
  final double? price;
  final String? primaryImage;
  final List<String>? supportingImages;
  final String? description;
  final String? notes;
  final Map<String, dynamic>? businessHours;

  ServiceUpdateEvent({
    required this.serviceId,
    required this.businessId,
    this.name,
    this.price,
    this.primaryImage,
    this.supportingImages,
    this.description,
    this.notes,
    this.businessHours,
  });
}

final class ServiceDeleteEvent extends ServiceEvent {
  final String serviceId;
  final String businessId;

  ServiceDeleteEvent({required this.serviceId, required this.businessId});
}
