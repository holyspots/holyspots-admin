import 'localized_text.dart';

class OfflineMap {
  final String id;
  final LocalizedText name;
  final LocalizedText descr;
  final String fileUrl;
  final int sizeBytes;
  final String version;
  final String? regionId;

  const OfflineMap({
    required this.id,
    required this.name,
    required this.descr,
    required this.fileUrl,
    this.sizeBytes = 0,
    this.version = '1.0',
    this.regionId,
  });

  factory OfflineMap.fromJson(Map<String, dynamic> json) {
    return OfflineMap(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>?),
      descr: LocalizedText.fromJson(json['descr'] as Map<String, dynamic>?),
      fileUrl: json['file_url'] as String? ?? json['file'] as String? ?? '',
      sizeBytes: json['size_bytes'] as int? ?? json['file_size'] as int? ?? 0,
      version: json['version'] as String? ?? '1.0',
      regionId: json['region_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'descr': descr.toJson(),
      'file_url': fileUrl,
      'size_bytes': sizeBytes,
      'version': version,
      'region_id': regionId,
    };
  }

  OfflineMap copyWith({
    String? id,
    LocalizedText? name,
    LocalizedText? descr,
    String? fileUrl,
    int? sizeBytes,
    String? version,
    String? regionId,
  }) {
    return OfflineMap(
      id: id ?? this.id,
      name: name ?? this.name,
      descr: descr ?? this.descr,
      fileUrl: fileUrl ?? this.fileUrl,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      version: version ?? this.version,
      regionId: regionId ?? this.regionId,
    );
  }

  /// Format file size for display (e.g., "48 MB")
  String get formattedFileSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(0)} MB';
  }
}

class OfflineMapInput {
  final LocalizedText name;
  final LocalizedText descr;
  final String fileUrl;
  final int sizeBytes;
  final String version;
  final String? regionId;

  const OfflineMapInput({
    required this.name,
    required this.descr,
    required this.fileUrl,
    this.sizeBytes = 0,
    this.version = '1.0',
    this.regionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'descr': descr.toJson(),
      'file_url': fileUrl,
      'size_bytes': sizeBytes,
      'version': version,
      'region_id': regionId,
    };
  }
}
