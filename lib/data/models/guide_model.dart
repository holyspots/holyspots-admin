import 'localized_text.dart';

class Guide {
  final String id;
  final LocalizedText name;
  final LocalizedText descr;
  final String? mainPhoto;
  final int order;
  final List<String> spotIds;
  final int spotsCount;

  const Guide({
    required this.id,
    required this.name,
    required this.descr,
    this.mainPhoto,
    this.order = 0,
    this.spotIds = const [],
    this.spotsCount = 0,
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    final spotIds = (json['spot_ids'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [];
    return Guide(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>?),
      descr: LocalizedText.fromJson(json['descr'] as Map<String, dynamic>?),
      mainPhoto: json['main_photo'] as String?,
      order: json['order'] as int? ?? 0,
      spotIds: spotIds,
      spotsCount: json['spots_count'] as int? ?? spotIds.length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'descr': descr.toJson(),
      'main_photo': mainPhoto,
      'order': order,
      'spot_ids': spotIds,
    };
  }

  Guide copyWith({
    String? id,
    LocalizedText? name,
    LocalizedText? descr,
    String? mainPhoto,
    int? order,
    List<String>? spotIds,
    int? spotsCount,
  }) {
    return Guide(
      id: id ?? this.id,
      name: name ?? this.name,
      descr: descr ?? this.descr,
      mainPhoto: mainPhoto ?? this.mainPhoto,
      order: order ?? this.order,
      spotIds: spotIds ?? this.spotIds,
      spotsCount: spotsCount ?? this.spotsCount,
    );
  }
}

class GuideInput {
  final LocalizedText name;
  final LocalizedText descr;
  final String? mainPhoto;
  final int order;
  final List<String> spotIds;

  const GuideInput({
    required this.name,
    required this.descr,
    this.mainPhoto,
    this.order = 0,
    this.spotIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'descr': descr.toJson(),
      'main_photo': mainPhoto,
      'order': order,
      'spot_ids': spotIds,
    };
  }
}
