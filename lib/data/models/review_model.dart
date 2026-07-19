class Review {
  final String id;
  final String spotId;
  final String spotName;
  final String authorName;
  final DateTime createdAt;
  final int rating; // 1-5
  final String text;
  final List<String> photos;
  final bool isApproved;
  final String? userId;

  const Review({
    required this.id,
    required this.spotId,
    required this.spotName,
    required this.authorName,
    required this.createdAt,
    required this.rating,
    required this.text,
    this.photos = const [],
    this.isApproved = false,
    this.userId,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      spotId: json['spot_id'] as String? ?? '',
      spotName: json['spot_name'] as String? ?? '',
      authorName: json['author_name'] as String? ?? json['user_name'] as String? ?? 'Anonymous',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      rating: json['rating'] as int? ?? 3,
      text: json['text'] as String? ?? '',
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isApproved: json['is_approved'] as bool? ?? false,
      userId: json['user_id'] as String?,
    );
  }

  Review copyWith({
    String? id,
    String? spotId,
    String? spotName,
    String? authorName,
    DateTime? createdAt,
    int? rating,
    String? text,
    List<String>? photos,
    bool? isApproved,
    String? userId,
  }) {
    return Review(
      id: id ?? this.id,
      spotId: spotId ?? this.spotId,
      spotName: spotName ?? this.spotName,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
      text: text ?? this.text,
      photos: photos ?? this.photos,
      isApproved: isApproved ?? this.isApproved,
      userId: userId ?? this.userId,
    );
  }
}

class ReviewQuery {
  final bool? isApproved;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int page;
  final int limit;

  const ReviewQuery({
    this.isApproved,
    this.fromDate,
    this.toDate,
    this.page = 1,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReviewQuery &&
        other.isApproved == isApproved &&
        other.fromDate == fromDate &&
        other.toDate == toDate &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode => Object.hash(isApproved, fromDate, toDate, page, limit);

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (isApproved != null) params['is_approved'] = isApproved;
    if (fromDate != null) params['from_date'] = fromDate!.toIso8601String();
    if (toDate != null) params['to_date'] = toDate!.toIso8601String();
    return params;
  }
}
