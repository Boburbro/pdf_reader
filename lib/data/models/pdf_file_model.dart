import 'package:equatable/equatable.dart';

class PdfFileModel extends Equatable {
  final int id;
  final String path;
  final String name;
  final DateTime? lastOpenedAt;

  const PdfFileModel({
    required this.id,
    required this.path,
    required this.name,
    this.lastOpenedAt,
  });

  PdfFileModel copyWith({
    int? id,
    String? path,
    String? name,
    DateTime? lastOpenedAt,
  }) =>
      PdfFileModel(
        id: id ?? this.id,
        path: path ?? this.path,
        name: name ?? this.name,
        lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      );

  factory PdfFileModel.fromJson(Map<String, dynamic> json) => PdfFileModel(
        id: json['id'] as int,
        path: json['path'] as String,
        name: json['name'] as String,
        lastOpenedAt: json['last_opened_at'] != null
            ? DateTime.parse(json['last_opened_at'] as String)
            : null,
      );

  static List<PdfFileModel> fromList(List<dynamic> list) => list
      .map((e) => PdfFileModel.fromJson(e as Map<String, dynamic>))
      .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'path': path,
        'name': name,
        'last_opened_at': lastOpenedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, path, name, lastOpenedAt];
}
