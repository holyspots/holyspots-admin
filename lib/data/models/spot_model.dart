import 'localized_text.dart';
import 'geo_point.dart';
import 'opening_time.dart';

class SpotAudio {
  final String file;
  final String lang;

  const SpotAudio({
    required this.file,
    required this.lang,
  });

  factory SpotAudio.fromJson(Map<String, dynamic> json) {
    return SpotAudio(
      file: json['file'] as String? ?? '',
      lang: json['lang'] as String? ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'lang': lang,
    };
  }
}

class Spot {
  final String id;
  final List<String> regionIds; // Changed from single cityId to multiple regions
  final LocalizedText name;
  final LocalizedText descr;
  final String? mainPhoto;
  final GeoPoint? location;
  final String? address;
  final int order;
  final List<String> photos;
  final List<SpotAudio> audios;
  final List<OpeningTime> openingTimes; // NEW
  final String? beaconId; // NEW

  const Spot({
    required this.id,
    required this.regionIds,
    required this.name,
    required this.descr,
    this.mainPhoto,
    this.location,
    this.address,
    this.order = 0,
    this.photos = const [],
    this.audios = const [],
    this.openingTimes = const [],
    this.beaconId,
  });

  /// Legacy getter for backward compatibility during migration
  String get cityId => regionIds.isNotEmpty ? regionIds.first : '';

  factory Spot.fromJson(Map<String, dynamic> json) {
    // Handle both old city_id format and new region_ids format
    List<String> regionIds = [];
    if (json['region_ids'] != null) {
      regionIds = (json['region_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList();
    } else if (json['city_id'] != null) {
      regionIds = [json['city_id'] as String];
    }

    return Spot(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      regionIds: regionIds,
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>?),
      descr: LocalizedText.fromJson(json['descr'] as Map<String, dynamic>?),
      mainPhoto: json['main_photo'] as String?,
      location: json['location'] != null
          ? GeoPoint.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      address: json['address'] as String?,
      order: json['order'] as int? ?? 0,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      audios: (json['audios'] as List<dynamic>?)
              ?.map((e) => SpotAudio.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      openingTimes: (json['opening_times'] as List<dynamic>?)
              ?.map((e) => OpeningTime.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      beaconId: json['beacon_id'] as String?,
    );
  }

  factory Spot.fromListJson(Map<String, dynamic> json) {
    return Spot.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'region_ids': regionIds,
      'name': name.toJson(),
      'descr': descr.toJson(),
      'main_photo': mainPhoto,
      'location': location?.toJson(),
      'address': address,
      'order': order,
      'photos': photos,
      'audios': audios.map((a) => a.toJson()).toList(),
      'opening_times': openingTimes.map((o) => o.toJson()).toList(),
      'beacon_id': beaconId,
    };
  }

  Spot copyWith({
    String? id,
    List<String>? regionIds,
    LocalizedText? name,
    LocalizedText? descr,
    String? mainPhoto,
    GeoPoint? location,
    String? address,
    int? order,
    List<String>? photos,
    List<SpotAudio>? audios,
    List<OpeningTime>? openingTimes,
    String? beaconId,
  }) {
    return Spot(
      id: id ?? this.id,
      regionIds: regionIds ?? this.regionIds,
      name: name ?? this.name,
      descr: descr ?? this.descr,
      mainPhoto: mainPhoto ?? this.mainPhoto,
      location: location ?? this.location,
      address: address ?? this.address,
      order: order ?? this.order,
      photos: photos ?? this.photos,
      audios: audios ?? this.audios,
      openingTimes: openingTimes ?? this.openingTimes,
      beaconId: beaconId ?? this.beaconId,
    );
  }

  /// Format opening times for display in list
  String formatOpeningDays({String locale = 'ru'}) {
    if (openingTimes.isEmpty) return '';
    // Show first opening time's days
    return openingTimes.first.formatDays(locale: locale);
  }

  /// Format opening hours for display in list
  String formatOpeningHours() {
    if (openingTimes.isEmpty) return '';
    return openingTimes.map((o) => o.formatTimeRange()).join(', ');
  }
}

class SpotInput {
  final List<String> regionIds;
  final LocalizedText name;
  final LocalizedText descr;
  final String? mainPhoto;
  final GeoPoint? location;
  final String? address;
  final int order;
  final List<String> photos;
  final List<SpotAudio> audios;
  final List<OpeningTime> openingTimes;
  final String? beaconId;

  const SpotInput({
    required this.regionIds,
    required this.name,
    required this.descr,
    this.mainPhoto,
    this.location,
    this.address,
    this.order = 0,
    this.photos = const [],
    this.audios = const [],
    this.openingTimes = const [],
    this.beaconId,
  });

  Map<String, dynamic> toJson() {
    return {
      'region_ids': regionIds,
      'name': name.toJson(),
      'descr': descr.toJson(),
      'main_photo': mainPhoto,
      'location': location?.toJson(),
      'address': address,
      'order': order,
      'photos': photos,
      'audios': audios.map((a) => a.toJson()).toList(),
      'opening_times': openingTimes.map((o) => o.toJson()).toList(),
      'beacon_id': beaconId,
    };
  }
}

class SpotQuery {
  final String? regionId; // Changed from cityId
  final int page;
  final int limit;

  const SpotQuery({
    this.regionId,
    this.page = 1,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SpotQuery &&
        other.regionId == regionId &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode => Object.hash(regionId, page, limit);
}
