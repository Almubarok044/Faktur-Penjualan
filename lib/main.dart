// ignore_for_file: unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/modules/pages/log_in_page.dart';
import 'app/modules/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LogInPage(),
            ),
      },
    );
  }
}
