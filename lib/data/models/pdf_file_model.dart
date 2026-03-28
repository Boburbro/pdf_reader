import 'package:equatable/equatable.dart';

class PdfFileModel extends Equatable {
  final int id;
  final String path;
  final String name;

  const PdfFileModel({
    required this.id,
    required this.path,
    required this.name,
  });

  PdfFileModel copyWith({int? id, String? path, String? name}) => PdfFileModel(
    id: id ?? this.id,
    path: path ?? this.path,
    name: name ?? this.name,
  );

  factory PdfFileModel.fromJson(Map<String, dynamic> json) => PdfFileModel(
    id: json['id'] as int,
    path: json['path'] as String,
    name: json['name'] as String,
  );

  static List<PdfFileModel> fromList(List<dynamic> list) => list
      .map((e) => PdfFileModel.fromJson(e as Map<String, dynamic>))
      .toList();

  Map<String, dynamic> toJson() => {'id': id, 'path': path, 'name': name};

  @override
  List<Object?> get props => [id, path, name];
}
