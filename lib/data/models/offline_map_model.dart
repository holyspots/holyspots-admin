import 'localized_text.dart';

class OfflineMap {
  final String id;
  final LocalizedText name;
  final String file;
  final int fileSize; // bytes
  final String? regionId;

  const OfflineMap({
    required this.id,
    required this.name,
    required this.file,
    this.fileSize = 0,
    this.regionId,
  });

  factory OfflineMap.fromJson(Map<String, dynamic> json) {
    return OfflineMap(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>?),
      file: json['file'] as String? ?? '',
      fileSize: json['file_size'] as int? ?? 0,
      regionId: json['region_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'file': file,
      'file_size': fileSize,
      'region_id': regionId,
    };
  }

  OfflineMap copyWith({
    String? id,
    LocalizedText? name,
    String? file,
    int? fileSize,
    String? regionId,
  }) {
    return OfflineMap(
      id: id ?? this.id,
      name: name ?? this.name,
      file: file ?? this.file,
      fileSize: fileSize ?? this.fileSize,
      regionId: regionId ?? this.regionId,
    );
  }

  /// Format file size for display (e.g., "48 MB")
  String get formattedFileSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(0)} KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(0)} MB';
  }
}

class OfflineMapInput {
  final LocalizedText name;
  final String file;
  final String? regionId;

  const OfflineMapInput({
    required this.name,
    required this.file,
    this.regionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'file': file,
      'region_id': regionId,
    };
  }
}
