import 'localized_text.dart';

class Direction {
  final String id;
  final String regionId;
  final LocalizedText name;
  final LocalizedText descr;

  const Direction({
    required this.id,
    required this.regionId,
    required this.name,
    required this.descr,
  });

  factory Direction.fromJson(Map<String, dynamic> json) {
    return Direction(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      regionId: json['region_id'] as String? ?? '',
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>?),
      descr: LocalizedText.fromJson(json['descr'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'region_id': regionId,
      'name': name.toJson(),
      'descr': descr.toJson(),
    };
  }

  Direction copyWith({
    String? id,
    String? regionId,
    LocalizedText? name,
    LocalizedText? descr,
  }) {
    return Direction(
      id: id ?? this.id,
      regionId: regionId ?? this.regionId,
      name: name ?? this.name,
      descr: descr ?? this.descr,
    );
  }
}

class DirectionInput {
  final String regionId;
  final LocalizedText name;
  final LocalizedText descr;

  const DirectionInput({
    required this.regionId,
    required this.name,
    required this.descr,
  });

  Map<String, dynamic> toJson() {
    return {
      'region_id': regionId,
      'name': name.toJson(),
      'descr': descr.toJson(),
    };
  }
}
