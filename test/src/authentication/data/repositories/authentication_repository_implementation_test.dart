import 'package:buenas_practicas_app/core/errors/exceptions.dart';
import 'package:buenas_practicas_app/core/errors/failure.dart';
import 'package:buenas_practicas_app/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:buenas_practicas_app/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:buenas_practicas_app/src/authentication/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSrc extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;

  late AuthenticationRepositoryImplementation repositoryImplementation;
  setUp(() {
    remoteDataSource = MockAuthRemoteDataSrc();

    repositoryImplementation =
        AuthenticationRepositoryImplementation(remoteDataSource);
  });

  const tException =
      APIException(message: 'Unknown error occured', statusCode: 500);

  group(
    'createUser',
    () {
      const createdAt = 'whatever.createdAt';
      const name = 'whatever.name';
      const avatar = 'whatever.avatar';
      test(
        'should call the [RemoteDataSource.createUser] and complete succesfully  when the call to the remote source is successful',
        () async {
          //arrange
          when(
            () => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(
                named: 'avatar',
              ),
            ),
          ).thenAnswer((_) async => Future.value());

          //act
          final result = await repositoryImplementation.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          );

          // assert
          expect(result, equals(const Right(null)));

          verify(() => remoteDataSource.createUser(
                createdAt: createdAt,
                name: name,
                avatar: avatar,
              ));

          verifyNoMoreInteractions(remoteDataSource);
        },
      );

      test(
        'Should return a [ServerFailure] when the call to the remote source is unsuccessful',
        () async {
          // Arrange
          when(
            () => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(
                named: 'avatar',
              ),
            ),
          ).thenThrow(tException);

          final result = await repositoryImplementation.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          );

          expect(
            result,
            equals(
              Left(
                APIException(
                    message: tException.message,
                    statusCode: tException.statusCode),
              ),
            ),
          );

          verify(() => remoteDataSource.createUser(
              createdAt: createdAt, name: name, avatar: avatar)).called(1);

          verifyNoMoreInteractions(remoteDataSource);
        },
      );
    },
  );

  group(
    'getUsers',
    () {
      test(
        'Should call [RemoteDataSource.getUsers] and return [List<User>], succesfully when the call to the remote source is succesful',
        () async {
          when(
            () => remoteDataSource.getUsers(),
          ).thenAnswer(
            (_) async => [],
          );

          final result = await repositoryImplementation.getUsers();

          expect(result, isA<Right<dynamic, List<User>>>());

          verify(() => remoteDataSource.getUsers()).called(1);

          verifyNoMoreInteractions(remoteDataSource);
        },
      );

      test(
        'Should return [APIFailure]',
        () async {
          when(() => remoteDataSource.getUsers()).thenThrow(tException);

          final result = await repositoryImplementation.getUsers();

          expect(result, equals(Left(APIFailure.fromException(tException))));

          verify(() => remoteDataSource.getUsers()).called(1);

          verifyNoMoreInteractions(remoteDataSource);
        },
      );
    },
  );
}
