// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AboutModel {
  String? id;
  String? title;
  String? telepon;
  String? email;
  String? website;
  String? alamat;
  String? desc;
  String? koordinat;
  String? colors;
  AboutModel({
    this.id,
    this.title,
    this.telepon,
    this.email,
    this.website,
    this.alamat,
    this.desc,
    this.koordinat,
    this.colors,
  });

  AboutModel copyWith({
    String? id,
    String? title,
    String? telepon,
    String? email,
    String? website,
    String? alamat,
    String? desc,
    String? koordinat,
    String? colors,
  }) {
    return AboutModel(
      id: id ?? this.id,
      title: title ?? this.title,
      telepon: telepon ?? this.telepon,
      email: email ?? this.email,
      website: website ?? this.website,
      alamat: alamat ?? this.alamat,
      desc: desc ?? this.desc,
      koordinat: koordinat ?? this.koordinat,
      colors: colors ?? this.colors,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'telepon': telepon,
      'email': email,
      'website': website,
      'alamat': alamat,
      'desc': desc,
      'koordinat': koordinat,
      'colors': colors,
    };
  }

  factory AboutModel.fromMap(Map<String, dynamic> map) {
    return AboutModel(
      id: map['\$id'] != null ? map['\$id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      telepon: map['telepon'] != null ? map['telepon'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      website: map['website'] != null ? map['website'] as String : null,
      alamat: map['alamat'] != null ? map['alamat'] as String : null,
      desc: map['desc'] != null ? map['desc'] as String : null,
      koordinat: map['koordinat'] != null ? map['koordinat'] as String : null,
      colors: map['colors'] != null ? map['colors'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AboutModel.fromJson(String source) =>
      AboutModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AboutModel(id: $id, title: $title, telepon: $telepon, email: $email, website: $website, alamat: $alamat, desc: $desc, koordinat: $koordinat, colors: $colors)';
  }

  @override
  bool operator ==(covariant AboutModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.telepon == telepon &&
        other.email == email &&
        other.website == website &&
        other.alamat == alamat &&
        other.desc == desc &&
        other.koordinat == koordinat &&
        other.colors == colors;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        telepon.hashCode ^
        email.hashCode ^
        website.hashCode ^
        alamat.hashCode ^
        desc.hashCode ^
        koordinat.hashCode ^
        colors.hashCode;
  }
}
