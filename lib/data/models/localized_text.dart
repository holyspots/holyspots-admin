class LocalizedText {
  final String en;
  final String ru;
  final String hi;

  const LocalizedText({
    this.en = '',
    this.ru = '',
    this.hi = '',
  });

  factory LocalizedText.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LocalizedText();
    return LocalizedText(
      en: json['en'] as String? ?? '',
      ru: json['ru'] as String? ?? '',
      hi: json['hi'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'en': en,
      'ru': ru,
      'hi': hi,
    };
  }

  bool get isEmpty => en.isEmpty && ru.isEmpty && hi.isEmpty;
  bool get isNotEmpty => !isEmpty;

  String getByLocale(String locale) {
    switch (locale) {
      case 'ru':
        return ru.isNotEmpty ? ru : en;
      case 'hi':
        return hi.isNotEmpty ? hi : en;
      default:
        return en;
    }
  }

  LocalizedText copyWith({
    String? en,
    String? ru,
    String? hi,
  }) {
    return LocalizedText(
      en: en ?? this.en,
      ru: ru ?? this.ru,
      hi: hi ?? this.hi,
    );
  }

  @override
  String toString() => 'LocalizedText(en: $en, ru: $ru, hi: $hi)';
}
