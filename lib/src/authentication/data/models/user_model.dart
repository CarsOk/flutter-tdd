import 'dart:convert';

import '../../../../core/utils/typedef.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.avatar,
    required super.createdAt,
    required super.id,
    required super.name,
  });

  const UserModel.empty()
      : this(
          id: '1',
          createdAt: '_empty.createdAt',
          avatar: '_empty.avatar',
          name: '_empty.name',
        );

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map)
      : this(
          avatar: map['avatar'] as String,
          createdAt: map['createdAt'] as String,
          id: map['id'] as String,
          name: map['name'] as String,
        );

  UserModel copyWith({
    String? avatar,
    String? id,
    String? createdAt,
    String? name,
  }) {
    return UserModel(
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  DataMap toMap() => {
        'id': id,
        'avatar': avatar,
        'createdAt': createdAt,
        'name': name,
      };

  String toJson() => jsonEncode(toMap());
}
