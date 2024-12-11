// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CashCategoryModel {
  String id;
  String category;
  CashCategoryModel({
    required this.id,
    required this.category,
  });
  

  CashCategoryModel copyWith({
    String? id,
    String? category,
  }) {
    return CashCategoryModel(
      id: id ?? this.id,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
    };
  }

  factory CashCategoryModel.fromMap(Map<String, dynamic> map) {
    return CashCategoryModel(
      id: map['\$id'] as String,
      category: map['category'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CashCategoryModel.fromJson(String source) => CashCategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CashCategoryModel(id: $id, category: $category)';

  @override
  bool operator ==(covariant CashCategoryModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.category == category;
  }

  @override
  int get hashCode => id.hashCode ^ category.hashCode;
}
