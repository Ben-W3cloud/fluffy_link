import 'package:fluffy_link/core/constants.dart';

class LinkModel {
  const LinkModel({
    required this.id,
    required this.shortCode,
    required this.blobId,
    this.fileName,
    this.fileSize,
    required this.clickCount,
    required this.createdAt,
  });

  final String id;
  final String shortCode;
  final String blobId;
  final String? fileName;
  final int? fileSize;
  final int clickCount;
  final DateTime createdAt;

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(
      id: json['id'] as String,
      shortCode: json['short_code'] as String,
      blobId: json['blob_id'] as String,
      fileName: json['file_name'] as String?,
      fileSize: _readNullableInt(json['file_size']),
      clickCount: _readInt(json['click_count']) ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  String get _baseUrl {
    final domain = AppConstants.appDomain;
    return domain.endsWith('/')
        ? domain.substring(0, domain.length - 1)
        : domain;
  }

  String get shortUrl => '$_baseUrl/$shortCode';

  String get statsUrl => '$_baseUrl/s/$shortCode';

  String get walrusUrl => '${AppConstants.walrusAggregator}/v1/blobs/$blobId';

  static int? _readNullableInt(Object? value) => _readInt(value);

  static int? _readInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    throw FormatException('Expected an integer-compatible value, got $value.');
  }
}
