// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:e_katalog/model/product_model.dart';
import 'package:flutter/foundation.dart';

class CartModel {
  final String? id;
  final String? userId;
  final List<dynamic>? colors;
  final ProductModel? product;
  CartModel({
    this.id,
    this.userId,
    this.colors,
    this.product,
  });

  CartModel copyWith({
    String? id,
    String? userId,
    List<dynamic>? colors,
    ProductModel? product,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      colors: colors ?? this.colors,
      product: product ?? this.product,
    );
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['\$id'] != null ? map['\$id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      colors: map['colors'] != null
          ? List<dynamic>.from((map['colors'] as List<dynamic>))
          : null,
      product: map['product'] != null
          ? ProductModel.fromMap(map['product'] as Map<String, dynamic>)
          : null,
    );
  }

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartModel(id: $id, userId: $userId, colors: $colors, product: $product)';
  }

  @override
  bool operator ==(covariant CartModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        listEquals(other.colors, colors) &&
        other.product == product;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ colors.hashCode ^ product.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'colors': colors,
      'product': product?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}
