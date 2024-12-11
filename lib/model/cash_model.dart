// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CashModel {
  String? id;
  String? title;
  String? tanggal;
  int? debet;
  int? kredit;
  String? image;
  String? bucket;
  String? kategori;
  CashModel({
    this.id,
    this.title,
    this.tanggal,
    this.debet,
    this.kredit,
    this.image,
    this.bucket,
    this.kategori,
  });

  CashModel copyWith({
    String? id,
    String? title,
    String? tanggal,
    int? debet,
    int? kredit,
    String? image,
    String? bucket,
    String? kategori,
  }) {
    return CashModel(
      id: id ?? this.id,
      title: title ?? this.title,
      tanggal: tanggal ?? this.tanggal,
      debet: debet ?? this.debet,
      kredit: kredit ?? this.kredit,
      image: image ?? this.image,
      bucket: bucket ?? this.bucket,
      kategori: kategori ?? this.kategori,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'tanggal': tanggal,
      'debet': debet,
      'kredit': kredit,
      'image': image,
      'bucket': bucket,
      'kategori': kategori,
    };
  }

  factory CashModel.fromMap(Map<String, dynamic> map) {
    return CashModel(
      id: map['\$id'] != null ? map['\$id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      tanggal: map['tanggal'] != null ? map['tanggal'] as String : null,
      debet: map['debet'] != null ? map['debet'] as int : null,
      kredit: map['kredit'] != null ? map['kredit'] as int : null,
      image: map['image'] != null ? map['image'] as String : null,
      bucket: map['bucket'] != null ? map['bucket'] as String : null,
      kategori: map['kategori'] != null ? map['kategori'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CashModel.fromJson(String source) =>
      CashModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CashModel(id: $id, title: $title, tanggal: $tanggal, debet: $debet, kredit: $kredit, image: $image, bucket: $bucket, kategori: $kategori)';
  }

  @override
  bool operator ==(covariant CashModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.tanggal == tanggal &&
      other.debet == debet &&
      other.kredit == kredit &&
      other.image == image &&
      other.bucket == bucket &&
      other.kategori == kategori;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      tanggal.hashCode ^
      debet.hashCode ^
      kredit.hashCode ^
      image.hashCode ^
      bucket.hashCode ^
      kategori.hashCode;
  }
}
