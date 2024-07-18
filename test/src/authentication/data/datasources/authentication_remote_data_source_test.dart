import 'dart:convert';

import 'package:buenas_practicas_app/core/errors/exceptions.dart';
import 'package:buenas_practicas_app/core/utils/constants.dart';
import 'package:buenas_practicas_app/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:buenas_practicas_app/src/authentication/data/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthenticationRemoteDataSourceImplementation(client);
    registerFallbackValue(Uri());
  });

  group(
    'createUser',
    () {
      test(
        'should complete successfully when the status code is 200 or 201',
        () async {
          when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
            (_) async => http.Response('', 201),
          );

          final methodCall = remoteDataSource.createUser;

          expect(
              methodCall(
                createdAt: 'createdAt',
                avatar: 'avatar',
                name: 'name',
              ),
              completes);

          verify(
            () => client.post(
              Uri.https(kBaseUrl, kCreateUserEndpoint),
              body: jsonEncode(
                {
                  'createdAt': 'createdAt',
                  'name': 'name',
                  'avatar': 'avatar',
                },
              ),
            ),
          ).called(1);

          verifyNoMoreInteractions(client);
        },
      );

      test(
        'Should throw [ApiException] when the status code is not 200 or 201',
        () async {
          when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
            (_) async => http.Response('Invalid email', 400),
          );

          final methodCall = remoteDataSource.createUser;

          expect(
            () => methodCall(
              avatar: 'avatar',
              createdAt: 'createdAt',
              name: 'name',
            ),
            throwsA(
              const APIException(message: 'Invalid email', statusCode: 400),
            ),
          );
        },
      );
    },
  );

  group('getUsers', () {
    const users = [UserModel.empty()];
    test('should return [List<User>] when the response the status code is 200',
        () async {
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode([users.first.toMap()]), 200),
      );

      final result = await remoteDataSource.getUsers();

      expect(result, equals(users));

      verify(() => client.get(Uri.https(
            kBaseUrl,
            kGetUsersEndpoint,
          ))).called(1);

      verifyNoMoreInteractions(client);
    });

    test('Should return [APIException] when failure', () async {
      const tMessage = 'Server down, AIUDA';

      when(() => client.get(any()))
          .thenAnswer((_) async => http.Response(jsonEncode(tMessage), 500));

      final result = remoteDataSource.getUsers;

      // print('result ${result}');

      try {
        await remoteDataSource.getUsers();

        // Si getUsers no lanza una excepción, la prueba falla
        fail('Expected APIException was not thrown');
      } catch (e) {
        expect(e, isA<APIException>());
        e as APIException;
        expect(jsonDecode(e.message), tMessage);
        expect(e.statusCode, 500);

        verify(
          () => client.get(
            Uri.https(kBaseUrl, kGetUsersEndpoint),
          ),
        ).called(1);
        verifyNoMoreInteractions(client);
      }
    });
  });
}
