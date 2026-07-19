import 'localized_text.dart';

class Guide {
  final String id;
  final LocalizedText name;
  final LocalizedText bio;
  final String? photo;
  final String? phone;
  final String? whatsapp;
  final String? telegram;
  final int order;
  final List<String> spotIds;
  final int spotsCount;

  const Guide({
    required this.id,
    required this.name,
    required this.bio,
    this.photo,
    this.phone,
    this.whatsapp,
    this.telegram,
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
      bio: LocalizedText.fromJson(json['bio'] as Map<String, dynamic>?),
      photo: json['photo'] as String?,
      phone: json['phone'] as String?,
      whatsapp: json['whatsapp'] as String?,
      telegram: json['telegram'] as String?,
      order: json['order'] as int? ?? 0,
      spotIds: spotIds,
      spotsCount: json['spots_count'] as int? ?? spotIds.length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'bio': bio.toJson(),
      'photo': photo,
      'phone': phone,
      'whatsapp': whatsapp,
      'telegram': telegram,
      'order': order,
      'spot_ids': spotIds,
    };
  }

  Guide copyWith({
    String? id,
    LocalizedText? name,
    LocalizedText? bio,
    String? photo,
    String? phone,
    String? whatsapp,
    String? telegram,
    int? order,
    List<String>? spotIds,
    int? spotsCount,
  }) {
    return Guide(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      photo: photo ?? this.photo,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      telegram: telegram ?? this.telegram,
      order: order ?? this.order,
      spotIds: spotIds ?? this.spotIds,
      spotsCount: spotsCount ?? this.spotsCount,
    );
  }
}

class GuideInput {
  final LocalizedText name;
  final LocalizedText bio;
  final String? photo;
  final String? phone;
  final String? whatsapp;
  final String? telegram;
  final int order;
  final List<String> spotIds;

  const GuideInput({
    required this.name,
    required this.bio,
    this.photo,
    this.phone,
    this.whatsapp,
    this.telegram,
    this.order = 0,
    this.spotIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'bio': bio.toJson(),
      'photo': photo,
      'phone': phone,
      'whatsapp': whatsapp,
      'telegram': telegram,
      'order': order,
      'spot_ids': spotIds,
    };
  }
}
