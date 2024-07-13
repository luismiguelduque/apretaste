import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

import './utils/custom_colors.dart';
import './blocs/blocs.dart';
import './services/services.dart';
import './screens/screens.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService().initPrefs();
  DependenciesService().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  CrashMonitoringService().init();
  runApp(const ApretasteApp());
}

class ApretasteApp extends StatelessWidget {
  const ApretasteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ((context) => AuthBloc())),
        BlocProvider(create: ((context) => MirrorsBloc())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Apretaste',
        home: const HomeScreen(),
        theme: ThemeData(
          primaryColor: const Color(0xff4caf52),
          primarySwatch: CustomColor.customGreenMaterial
        ),
      ),
    );
  }
}