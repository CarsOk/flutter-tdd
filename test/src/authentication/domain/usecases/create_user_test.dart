// What does the class depend on
// Answer -- AuthenticatorRepository
// What does the class depend on
// How can we create a fake version of the repository
// Answer -- Use Mocktail
// How do we control what our dependencies do
// Answer -- Using the Mocktail

import 'package:buenas_practicas_app/core/errors/failure.dart';
import 'package:buenas_practicas_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:buenas_practicas_app/src/authentication/domain/usecases/create_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'authentication_repository.dart';

void main() {
  late CreateUser usecase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthRepo();
    usecase = CreateUser(repository);
  });

  test(
    'Should call the [Repository.createUser]',
    () async {
      // Arrange

      //STUB

      final params = CreateUserParams.empty();

      when(
        () => repository.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenAnswer((_) async => const Right(null));

      //Act
      final result = await usecase(params);

      //Assert
      expect(result, equals(const Right<Failure, void>(null)));
      verify(
        () => repository.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar,
        ),
      ).called(1);

      verifyNoMoreInteractions(repository);
    },
  );
}
