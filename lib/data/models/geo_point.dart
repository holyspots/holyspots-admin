class GeoPoint {
  final double latitude;
  final double longitude;

  const GeoPoint({
    required this.latitude,
    required this.longitude,
  });

  factory GeoPoint.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GeoPoint(latitude: 0, longitude: 0);
    }

    // API format: {"type": "Point", "coordinates": [longitude, latitude]}
    final coordinates = json['coordinates'] as List<dynamic>?;
    if (coordinates != null && coordinates.length >= 2) {
      return GeoPoint(
        longitude: (coordinates[0] as num).toDouble(),
        latitude: (coordinates[1] as num).toDouble(),
      );
    }

    // Fallback for direct lat/lng format
    return GeoPoint(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': 'Point',
      'coordinates': [longitude, latitude],
    };
  }

  bool get isValid => latitude != 0 || longitude != 0;

  GeoPoint copyWith({
    double? latitude,
    double? longitude,
  }) {
    return GeoPoint(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() => 'GeoPoint($latitude, $longitude)';
}
