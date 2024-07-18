import 'package:buenas_practicas_app/core/utils/typedef.dart';
import 'package:buenas_practicas_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';

class CreateUser extends UsecaseWithParams<void, CreateUserParams> {
  const CreateUser(this._repository);

  final AuthenticationRepository _repository;

  // ResultVoid createUser({
  //   required String createdAt,
  //   required String name,
  //   required String avatar,
  // }) async =>
  //     _repository.createUser(
  //       createdAt: createdAt,
  //       name: name,
  //       avatar: avatar,
  //     );

  @override
  ResultVoid call(CreateUserParams params) async => _repository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar,
      );
}

class CreateUserParams extends Equatable {
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserParams({
    required this.avatar,
    required this.createdAt,
    required this.name,
  });

  const CreateUserParams.empty()
      : this(
          createdAt: '_empty.string',
          name: '_empty.string',
          avatar: '_empt.string',
        );

  @override
  // TODO: implement props
  List<Object?> get props => [createdAt, name, avatar];
}
