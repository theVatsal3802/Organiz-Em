import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/screens/auth_screen.dart';

import './screens/add_task_screen.dart';
import './screens/description_screen.dart';
import './screens/verify_email_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MaterialApp(
      title: "Organiz'Em",
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.green.shade700,
          onPrimary: Colors.white,
          secondary: Colors.green.shade700,
          onSecondary: Colors.black54,
          error: Colors.red.shade900,
          onError: Colors.white,
          background: Colors.grey.shade800,
          onBackground: Colors.white,
          surface: Colors.green,
          onSurface: Colors.white,
        ),
        appBarTheme: AppBarTheme(color: Colors.green.shade800),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const VerifyEmailScreen();
          }
          return const AuthScreen();
        },
      ),
      routes: {
        AddTaskScreen.routeName: (context) => const AddTaskScreen(),
        DescriptionScreen.routeName: (context) => const DescriptionScreen(),
      },
    );
  }
}
