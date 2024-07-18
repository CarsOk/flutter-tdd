import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.avatar,
    required this.createdAt,
    required this.id,
    required this.name,
  });

  const User.empty()
      : this(
          id: '1',
          createdAt: '_empty.createdAt',
          avatar: '_empty.avatar',
          name: '_empty.name',
        );

  final String id;
  final String createdAt;
  final String name;
  final String avatar;

  @override
  List<Object?> get props => [id];
}

// void main() {
//   final user =
//       User(avatar: 'avatar', createdAt: 'createdAt', id: 1, name: 'John');

//   final user2 =
//       User(avatar: 'avatar', createdAt: 'createdAt', id: 2, name: 'Mo');
// }
