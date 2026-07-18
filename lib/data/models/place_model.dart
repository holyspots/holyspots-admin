import 'localized_text.dart';
import 'geo_point.dart';

enum PlaceType { hotel, food }

class Place {
  final String id;
  final String regionId;
  final PlaceType type;
  final LocalizedText name;
  final LocalizedText descr;
  final String? mainPhoto;
  final String? address;
  final GeoPoint? location;

  const Place({
    required this.id,
    required this.regionId,
    required this.type,
    required this.name,
    required this.descr,
    this.mainPhoto,
    this.address,
    this.location,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      regionId: json['region_id'] as String? ?? '',
      type: _parseType(json['type']),
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>?),
      descr: LocalizedText.fromJson(json['descr'] as Map<String, dynamic>?),
      mainPhoto: json['main_photo'] as String?,
      address: json['address'] as String?,
      location: json['location'] != null
          ? GeoPoint.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }

  static PlaceType _parseType(dynamic value) {
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'hotel':
          return PlaceType.hotel;
        case 'food':
          return PlaceType.food;
      }
    }
    return PlaceType.hotel;
  }

  String get typeValue {
    switch (type) {
      case PlaceType.hotel:
        return 'hotel';
      case PlaceType.food:
        return 'food';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'region_id': regionId,
      'type': typeValue,
      'name': name.toJson(),
      'descr': descr.toJson(),
      'main_photo': mainPhoto,
      'address': address,
      'location': location?.toJson(),
    };
  }

  Place copyWith({
    String? id,
    String? regionId,
    PlaceType? type,
    LocalizedText? name,
    LocalizedText? descr,
    String? mainPhoto,
    String? address,
    GeoPoint? location,
  }) {
    return Place(
      id: id ?? this.id,
      regionId: regionId ?? this.regionId,
      type: type ?? this.type,
      name: name ?? this.name,
      descr: descr ?? this.descr,
      mainPhoto: mainPhoto ?? this.mainPhoto,
      address: address ?? this.address,
      location: location ?? this.location,
    );
  }
}

class PlaceInput {
  final String regionId;
  final PlaceType type;
  final LocalizedText name;
  final LocalizedText descr;
  final String? mainPhoto;
  final String? address;
  final GeoPoint? location;

  const PlaceInput({
    required this.regionId,
    required this.type,
    required this.name,
    required this.descr,
    this.mainPhoto,
    this.address,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'region_id': regionId,
      'type': type == PlaceType.hotel ? 'hotel' : 'food',
      'name': name.toJson(),
      'descr': descr.toJson(),
      'main_photo': mainPhoto,
      'address': address,
      'location': location?.toJson(),
    };
  }
}
