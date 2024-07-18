import 'package:buenas_practicas_app/core/errors/exceptions.dart';
import 'package:buenas_practicas_app/core/utils/typedef.dart';
import 'package:buenas_practicas_app/src/authentication/data/datasources/authentication_remote_data_source.dart';

import 'package:buenas_practicas_app/src/authentication/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  const AuthenticationRepositoryImplementation(this._remoteDataSource);

  final AuthenticationRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    // Test-Driven Development
    // Call the remote data source
    // Check if the method returns the proper data
    // Check if when the remoteDataSoruce  throws an exception, we return a
    // failure and if it doesn't throw and exception, we return the actual
    // expected data

    try {
      await _remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      return Right(null);
    } on APIException catch (e) {
      return Left(APIException(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final result = await _remoteDataSource.getUsers();
      return Right(result);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}
