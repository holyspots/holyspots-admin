import 'localized_text.dart';

enum DirectionType { bus, train, plane, walk }

class Direction {
  final String id;
  final String? regionId;
  final LocalizedText title;
  final LocalizedText content;
  final DirectionType type;
  final int order;

  const Direction({
    required this.id,
    this.regionId,
    required this.title,
    required this.content,
    required this.type,
    this.order = 0,
  });

  factory Direction.fromJson(Map<String, dynamic> json) {
    return Direction(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      regionId: json['region_id'] as String?,
      title: LocalizedText.fromJson(json['title'] as Map<String, dynamic>?),
      content: LocalizedText.fromJson(json['content'] as Map<String, dynamic>?),
      type: _parseType(json['type'] as String?),
      order: json['order'] as int? ?? 0,
    );
  }

  static DirectionType _parseType(String? type) {
    return switch (type) {
      'bus' => DirectionType.bus,
      'train' => DirectionType.train,
      'plane' => DirectionType.plane,
      'walk' => DirectionType.walk,
      _ => DirectionType.bus,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'region_id': regionId,
      'title': title.toJson(),
      'content': content.toJson(),
      'type': type.name,
      'order': order,
    };
  }

  Direction copyWith({
    String? id,
    String? regionId,
    LocalizedText? title,
    LocalizedText? content,
    DirectionType? type,
    int? order,
  }) {
    return Direction(
      id: id ?? this.id,
      regionId: regionId ?? this.regionId,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      order: order ?? this.order,
    );
  }
}

class DirectionInput {
  final String? regionId;
  final LocalizedText title;
  final LocalizedText content;
  final DirectionType type;
  final int order;

  const DirectionInput({
    this.regionId,
    required this.title,
    required this.content,
    required this.type,
    this.order = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'region_id': regionId,
      'title': title.toJson(),
      'content': content.toJson(),
      'type': type.name,
      'order': order,
    };
  }
}
