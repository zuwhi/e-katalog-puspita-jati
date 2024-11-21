// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ColorsModel {
  final String? id;
  final String? color;
  final String? name;
  ColorsModel({
    this.id,
    this.color,
    this.name,
  });
  

  ColorsModel copyWith({
    String? id,
    String? color,
    String? name,
  }) {
    return ColorsModel(
      id: id ?? this.id,
      color: color ?? this.color,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'color': color,
      'name': name,
    };
  }

  factory ColorsModel.fromMap(Map<String, dynamic> map) {
    return ColorsModel(
      id: map['\$id'] != null ? map['\$id'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ColorsModel.fromJson(String source) => ColorsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ColorsModel(id: $id, color: $color, name: $name)';

  @override
  bool operator ==(covariant ColorsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.color == color &&
      other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ color.hashCode ^ name.hashCode;
}
