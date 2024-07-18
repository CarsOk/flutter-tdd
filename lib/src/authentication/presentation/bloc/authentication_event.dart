part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class CreateUserEvent extends AuthenticationEvent {
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserEvent({
    required this.avatar,
    required this.createdAt,
    required this.name,
  });

  @override
  List<Object> get props => [createdAt, name, avatar];
}

class GetUsersEvent extends AuthenticationEvent {
  const GetUsersEvent();
}
