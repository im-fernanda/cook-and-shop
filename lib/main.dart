import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_and_shop/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:cook_and_shop/services/auth_checker.dart';
import 'package:provider/provider.dart';
import 'core/di/configure_providers.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  final data = await ConfigureProviders.createDependencyTree();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(data: data));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.data});

  final ConfigureProviders data;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: data.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cook & Shop',
        theme: const MaterialTheme(TextTheme()).light(),
        darkTheme: const MaterialTheme(TextTheme()).dark(),
        themeMode: ThemeMode.system,
        home: const AuthChecker(),
      ),
    );
  }
}
