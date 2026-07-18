class OpeningTime {
  final List<int> days; // 0=Mon, 1=Tue, ..., 6=Sun
  final String startTime; // "04:30"
  final String endTime; // "13:00"

  const OpeningTime({
    required this.days,
    required this.startTime,
    required this.endTime,
  });

  factory OpeningTime.fromJson(Map<String, dynamic> json) {
    return OpeningTime(
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  OpeningTime copyWith({
    List<int>? days,
    String? startTime,
    String? endTime,
  }) {
    return OpeningTime(
      days: days ?? this.days,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  /// Format days as string like "Пн–Вс" or "Пн–Пт"
  String formatDays({String locale = 'ru'}) {
    if (days.isEmpty) return '';

    final dayNames = locale == 'ru'
        ? ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
        : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final sortedDays = [...days]..sort();

    // Check if consecutive
    bool isConsecutive = true;
    for (int i = 1; i < sortedDays.length; i++) {
      if (sortedDays[i] != sortedDays[i - 1] + 1) {
        isConsecutive = false;
        break;
      }
    }

    if (sortedDays.length == 7) {
      return locale == 'ru' ? 'Пн–Вс' : 'Mon–Sun';
    }

    if (isConsecutive && sortedDays.length > 2) {
      return '${dayNames[sortedDays.first]}–${dayNames[sortedDays.last]}';
    }

    return sortedDays.map((d) => dayNames[d]).join(', ');
  }

  /// Format time range as string like "4:30–13:00"
  String formatTimeRange() {
    return '$startTime–$endTime';
  }
}
