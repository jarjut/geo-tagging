import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo_tagging/repository/message_repository.dart';

import 'app/app.dart';
import 'app/bloc/app_bloc.dart';
import 'app/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await Firebase.initializeApp();
  runApp(
    RepositoryProvider(
      create: (context) => MessageRepository(),
      child: BlocProvider(
        create: (context) => AppBloc()..add(AppStart()),
        child: const App(),
      ),
    ),
  );
}
