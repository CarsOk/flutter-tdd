import 'package:bloc_test/bloc_test.dart';
import 'package:buenas_practicas_app/core/errors/failure.dart';
import 'package:buenas_practicas_app/src/authentication/domain/usecases/create_user.dart';
import 'package:buenas_practicas_app/src/authentication/domain/usecases/get_users.dart';
import 'package:buenas_practicas_app/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tAPIFailure = APIFailure(message: 'message de error', statusCode: 400);

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(CreateUserParams.empty());
  });

  tearDown(() => cubit.close());

  test('Initial state should be [AuthenticationInital]', () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group(
    'createUser',
    () {
      blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [CreatingUser, UserCreate] when successful',
        build: () {
          when(() => createUser(any())).thenAnswer((_) async => Right(null));
          return cubit;
        },
        act: (cubit) => cubit.createUser(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
        ),
        expect: () => [
          CreatingUser(),
          UserCreated(),
        ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        },
      );

      blocTest<AuthenticationCubit, AuthenticationState>(
        'Should emit [CreatingUser, Authentication[Error] when unsuccessful]',
        build: () {
          when(() => createUser(any()))
              .thenAnswer((_) async => Left(tAPIFailure));
          return cubit;
        },
        act: (cubit) => cubit.createUser(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
        ),
        expect: () => [
          CreatingUser(),
          AuthenticationError('message de error'),
        ],
      );
    },
  );

  group('getusers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'Should emit [GettingUsers, UsersLoaded when successful] successfull result',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => const [
        GettingUsers(),
        UserLoaded([]),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
        'Should return [GettingUsers, AuthenticationError] when unsuccessful',
        build: () {
          when(() => getUsers())
              .thenAnswer((_) async => const Left(tAPIFailure));
          return cubit;
        },
        act: (cubit) => cubit.getUsers(),
        expect: () =>
            const [GettingUsers(), AuthenticationError('message de error')]);
  });
}
