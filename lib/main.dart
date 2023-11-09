import 'package:flutter/material.dart';
import 'package:flutter_application_1/notes/Notes.dart';
import 'package:flutter_application_1/notes/new_note.dart';
import 'package:flutter_application_1/view/Register.dart';
import 'package:flutter_application_1/constants/Routes.dart';
import 'package:flutter_application_1/view/login.dart';
import 'package:flutter_application_1/view/verifyemail.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const NotesPage(),
        routes: {
          loginRoute: (context) => const Login(),
          notesroute: (context) => const NotesPage(),
          registerroute: (context) => const Register(),
          verifyemail: (context) => const VerifyEmail(),
          newnote:(context) => const NewNote(),
        });
  }
}
