import 'localized_text.dart';

enum PlaceType { hotel, food }

class Place {
  final String id;
  final String? regionId;
  final PlaceType type;
  final LocalizedText name;
  final LocalizedText descr;
  final LocalizedText address;
  final String? mainPhoto;
  final String? phone;
  final String? website;
  final double? lat;
  final double? lng;

  const Place({
    required this.id,
    this.regionId,
    required this.type,
    required this.name,
    required this.descr,
    required this.address,
    this.mainPhoto,
    this.phone,
    this.website,
    this.lat,
    this.lng,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      regionId: json['region_id'] as String?,
      type: _parseType(json['type']),
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>?),
      descr: LocalizedText.fromJson(json['descr'] as Map<String, dynamic>?),
      address: LocalizedText.fromJson(json['address'] as Map<String, dynamic>?),
      mainPhoto: json['main_photo'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
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
      'address': address.toJson(),
      'main_photo': mainPhoto,
      'phone': phone,
      'website': website,
      'lat': lat,
      'lng': lng,
    };
  }

  Place copyWith({
    String? id,
    String? regionId,
    PlaceType? type,
    LocalizedText? name,
    LocalizedText? descr,
    LocalizedText? address,
    String? mainPhoto,
    String? phone,
    String? website,
    double? lat,
    double? lng,
  }) {
    return Place(
      id: id ?? this.id,
      regionId: regionId ?? this.regionId,
      type: type ?? this.type,
      name: name ?? this.name,
      descr: descr ?? this.descr,
      address: address ?? this.address,
      mainPhoto: mainPhoto ?? this.mainPhoto,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}

class PlaceInput {
  final String? regionId;
  final PlaceType type;
  final LocalizedText name;
  final LocalizedText descr;
  final LocalizedText address;
  final String? mainPhoto;
  final String? phone;
  final String? website;
  final double? lat;
  final double? lng;

  const PlaceInput({
    this.regionId,
    required this.type,
    required this.name,
    required this.descr,
    required this.address,
    this.mainPhoto,
    this.phone,
    this.website,
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toJson() {
    return {
      'region_id': regionId,
      'type': type == PlaceType.hotel ? 'hotel' : 'food',
      'name': name.toJson(),
      'descr': descr.toJson(),
      'address': address.toJson(),
      'main_photo': mainPhoto,
      'phone': phone,
      'website': website,
      'lat': lat,
      'lng': lng,
    };
  }
}
