// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ColorsModel {
  final String? id;
  final String colors;
  ColorsModel({
    this.id,
    required this.colors,
  });
  

  ColorsModel copyWith({
    String? id,
    String? colors,
  }) {
    return ColorsModel(
      id: id ?? this.id,
      colors: colors ?? this.colors,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'colors': colors,
    };
  }

  factory ColorsModel.fromMap(Map<String, dynamic> map) {
    return ColorsModel(
      id: map['\$id'] != null ? map['\$id'] as String : null,
      colors: map['colors'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ColorsModel.fromJson(String source) => ColorsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ColorsModel(id: $id, colors: $colors)';

  @override
  bool operator ==(covariant ColorsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.colors == colors;
  }

  @override
  int get hashCode => id.hashCode ^ colors.hashCode;
}
