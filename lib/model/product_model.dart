// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductModel {
  final String id;
  final String title;
  final String desc;
  final int price;
  final String? date;
  final String category;
  final String estimate;
  final String? color;
  final String? image1;
  final String? image2;
  final String? image3;
  final String? bucket1;
  final String? bucket2;
  final String? bucket3;
  ProductModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.price,
    this.date,
    required this.category,
    required this.estimate,
    this.color,
    this.image1,
    this.image2,
    this.image3,
    this.bucket1,
    this.bucket2,
    this.bucket3,
  });

  ProductModel copyWith({
    String? id,
    String? title,
    String? desc,
    int? price,
    String? date,
    String? category,
    String? estimate,
    String? color,
    String? image1,
    String? image2,
    String? image3,
    String? bucket1,
    String? bucket2,
    String? bucket3,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      price: price ?? this.price,
      date: date ?? this.date,
      category: category ?? this.category,
      estimate: estimate ?? this.estimate,
      color: color ?? this.color,
      image1: image1 ?? this.image1,
      image2: image2 ?? this.image2,
      image3: image3 ?? this.image3,
      bucket1: bucket1 ?? this.bucket1,
      bucket2: bucket2 ?? this.bucket2,
      bucket3: bucket3 ?? this.bucket3,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'desc': desc,
      'price': price,
      'date': date,
      'category': category,
      'estimate': estimate,
      'color': color,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'bucket1': bucket1,
      'bucket2': bucket2,
      'bucket3': bucket3,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['\$id'] as String,
      title: map['title'] as String,
      desc: map['desc'] as String,
      price: map['price'] as int,
      date: map['date'] != null ? map['date'] as String : null,
      category: map['category'] as String,
      estimate: map['estimate'] as String,
      color: map['color'] != null ? map['color'] as String : null,
      image1: map['image1'] != null ? map['image1'] as String : null,
      image2: map['image2'] != null ? map['image2'] as String : null,
      image3: map['image3'] != null ? map['image3'] as String : null,
      bucket1: map['bucket1'] != null ? map['bucket1'] as String : null,
      bucket2: map['bucket2'] != null ? map['bucket2'] as String : null,
      bucket3: map['bucket3'] != null ? map['bucket3'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, desc: $desc, price: $price, date: $date, category: $category, estimate: $estimate, color: $color, image1: $image1, image2: $image2, image3: $image3, bucket1: $bucket1, bucket2: $bucket2, bucket3: $bucket3)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.desc == desc &&
      other.price == price &&
      other.date == date &&
      other.category == category &&
      other.estimate == estimate &&
      other.color == color &&
      other.image1 == image1 &&
      other.image2 == image2 &&
      other.image3 == image3 &&
      other.bucket1 == bucket1 &&
      other.bucket2 == bucket2 &&
      other.bucket3 == bucket3;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      desc.hashCode ^
      price.hashCode ^
      date.hashCode ^
      category.hashCode ^
      estimate.hashCode ^
      color.hashCode ^
      image1.hashCode ^
      image2.hashCode ^
      image3.hashCode ^
      bucket1.hashCode ^
      bucket2.hashCode ^
      bucket3.hashCode;
  }
}
