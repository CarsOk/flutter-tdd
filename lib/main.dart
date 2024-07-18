import 'package:buenas_practicas_app/src/authentication/domain/usecases/get_users.dart';
import 'package:buenas_practicas_app/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:buenas_practicas_app/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:buenas_practicas_app/src/authentication/presentation/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthenticationCubit>(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
