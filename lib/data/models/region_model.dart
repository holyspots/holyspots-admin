import 'localized_text.dart';

class Region {
  final String id;
  final LocalizedText name;
  final LocalizedText descr;
  final String? mainPhoto;
  final int order;
  final bool isDeleted;
  final int spotsCount;

  const Region({
    required this.id,
    required this.name,
    required this.descr,
    this.mainPhoto,
    this.order = 0,
    this.isDeleted = false,
    this.spotsCount = 0,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>?),
      descr: LocalizedText.fromJson(json['descr'] as Map<String, dynamic>?),
      mainPhoto: json['main_photo'] as String?,
      order: json['order'] as int? ?? 0,
      isDeleted: json['is_deleted'] as bool? ?? false,
      spotsCount: json['spots_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'descr': descr.toJson(),
      'main_photo': mainPhoto,
      'order': order,
    };
  }

  Region copyWith({
    String? id,
    LocalizedText? name,
    LocalizedText? descr,
    String? mainPhoto,
    int? order,
    bool? isDeleted,
    int? spotsCount,
  }) {
    return Region(
      id: id ?? this.id,
      name: name ?? this.name,
      descr: descr ?? this.descr,
      mainPhoto: mainPhoto ?? this.mainPhoto,
      order: order ?? this.order,
      isDeleted: isDeleted ?? this.isDeleted,
      spotsCount: spotsCount ?? this.spotsCount,
    );
  }
}

class RegionInput {
  final LocalizedText name;
  final LocalizedText descr;
  final String? mainPhoto;
  final int order;

  const RegionInput({
    required this.name,
    required this.descr,
    this.mainPhoto,
    this.order = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'descr': descr.toJson(),
      'main_photo': mainPhoto,
      'order': order,
    };
  }
}
