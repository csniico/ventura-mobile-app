import 'package:ventura/core/domain/entities/business_entity.dart';

class BusinessModel extends Business {
  BusinessModel({
    required super.id,
    required super.shortId,
    required super.ownerId,
    required super.categories,
    required super.name,
    super.email,
    super.phone,
    super.description,
    super.tagLine,
    super.logo,
    super.city,
    super.state,
    super.country,
    super.address,
  });

  // from json
  factory BusinessModel.fromJson(
    Map<String, dynamic> json, {
    bool fromDatabase = false,
  }) {
    return BusinessModel(
      id: json['id'] as String,
      shortId: json['shortId'] as String,
      ownerId: json['ownerId'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      tagLine: json['tagLine'] as String,
      categories: fromDatabase
          ? (json['categories'] as String).split(',')
          : List<String>.from(json['categories'] as List),
      logo: json['logo'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      address: json['address'] as String,
    );
  }

  // from entity
  factory BusinessModel.fromEntity(Business business) {
    return BusinessModel(
      id: business.id,
      shortId: business.shortId,
      ownerId: business.ownerId,
      email: business.email,
      phone: business.phone,
      name: business.name,
      description: business.description,
      tagLine: business.tagLine,
      categories: business.categories,
      logo: business.logo,
      city: business.city,
      state: business.state,
      country: business.country,
      address: business.address,
    );
  }

  // from map
  factory BusinessModel.fromMap(
    Map<String, dynamic> map, {
    bool fromDatabase = false,
  }) {
    return BusinessModel(
      id: map['id'] as String,
      shortId: map['shortId'] as String,
      ownerId: map['ownerId'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      tagLine: map['tagLine'] as String,
      categories: fromDatabase
          ? (map['categories'] as String).split(',')
          : List<String>.from(map['categories'] as List),
      logo: map['logo'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      country: map['country'] as String,
      address: map['address'] as String,
    );
  }

  // to json
  Map<String, dynamic> toJson({bool forDatabase = false}) {
    return {
      'id': id,
      'shortId': shortId,
      'ownerId': ownerId,
      'email': email,
      'phone': phone,
      'name': name,
      'description': description,
      'tagLine': tagLine,
      'categories': forDatabase ? categories.join(',') : categories,
      'logo': logo,
      'city': city,
      'state': state,
      'country': country,
      'address': address,
    };
  }

  //   to entity
  Business toEntity() {
    return Business(
      id: id,
      shortId: shortId,
      ownerId: ownerId,
      email: email,
      phone: phone,
      name: name,
      description: description,
      tagLine: tagLine,
      categories: categories,
      logo: logo,
      city: city,
      state: state,
      country: country,
      address: address,
    );
  }

  //   to map
  Map<String, dynamic> toMap({bool forDatabase = false}) {
    return {
      'id': id,
      'shortId': shortId,
      'ownerId': ownerId,
      'email': email,
      'phone': phone,
      'name': name,
      'description': description,
      'tagLine': tagLine,
      'categories': forDatabase ? categories.join(',') : categories,
      'logo': logo,
      'city': city,
      'state': state,
      'country': country,
      'address': address,
    };
  }
}
