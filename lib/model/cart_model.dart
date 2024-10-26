// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:e_katalog/model/product_model.dart';

class CartModel {
  final String? id;
  final String? userId;
  final String? color;
  final ProductModel? product;
  CartModel({
    this.id,
    this.userId,
    this.color,
    this.product,
  });

  CartModel copyWith({
    String? id,
    String? userId,
    String? color,
    ProductModel? product,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      color: color ?? this.color,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'color': color,
      'product': product?.toMap(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['\$id'] != null ? map['\$id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      product: map['product'] != null ? ProductModel.fromMap(map['product'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) => CartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartModel(id: $id, userId: $userId, color: $color, product: $product)';
  }

  @override
  bool operator ==(covariant CartModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.color == color &&
      other.product == product;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      color.hashCode ^
      product.hashCode;
  }
}
