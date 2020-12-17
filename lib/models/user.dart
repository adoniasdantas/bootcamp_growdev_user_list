import 'dart:io';

class User {
  int id;
  String name;
  int age;
  String email;
  String document;
  bool active;
  File image;

  User({
    this.name,
    this.age,
    this.email,
    this.document,
    this.active = false,
    this.id,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        age = json['age'],
        email = json['email'],
        document = json['document'],
        image = json['image'] != null ? File(json['image']) : null,
        active = (json['active'] as int) == 1;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'email': email,
      'document': document,
      'image': image?.path,
      'active': active ? 1 : 0,
    };
  }

  @override
  String toString() {
    return 'nome = $name, age = $age, email=$email';
  }
}
