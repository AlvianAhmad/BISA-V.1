import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'pages/welcome_page.dart';
import 'pages/login_page.dart';

void
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MyApp(),
  );
}

class MyApp
    extends
        StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<
    MyApp
  >
  createState() => _MyAppState();
}

class _MyAppState
    extends
        State<
          MyApp
        > {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(
      () {
        isDarkMode = !isDarkMode;
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

      home: const WelcomePage(),

      routes: {
        '/login':
            (
              context,
            ) => const LoginPage(),
        '/welcome':
            (
              context,
            ) => const WelcomePage(),
      },
    );
  }
}
