// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? role;
  final String? telepon;
  final String? image;
  final String? alamat;
  final String? bucketId;
  UserModel({
    required this.id,
    this.name,
    this.email,
    this.password,
    this.role,
    this.telepon,
    this.image,
    this.alamat,
    this.bucketId,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? role,
    String? telepon,
    String? image,
    String? alamat,
    String? bucketId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      telepon: telepon ?? this.telepon,
      image: image ?? this.image,
      alamat: alamat ?? this.alamat,
      bucketId: bucketId ?? this.bucketId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'telepon': telepon,
      'image': image,
      'alamat': alamat,
      'bucketId': bucketId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['\$id'] != null ? map['\$id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
      telepon: map['telepon'] != null ? map['telepon'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      alamat: map['alamat'] != null ? map['alamat'] as String : null,
      bucketId: map['bucketId'] != null ? map['bucketId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, password: $password, role: $role, telepon: $telepon, image: $image, alamat: $alamat, bucketId: $bucketId)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.password == password &&
      other.role == role &&
      other.telepon == telepon &&
      other.image == image &&
      other.alamat == alamat &&
      other.bucketId == bucketId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      role.hashCode ^
      telepon.hashCode ^
      image.hashCode ^
      alamat.hashCode ^
      bucketId.hashCode;
  }
}
