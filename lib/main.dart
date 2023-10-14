import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/Register.dart';
   import 'firebase_options.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Register(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder(
       future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
        builder: (context, snapshot) {
switch(snapshot.connectionState){
  case ConnectionState.done:
  const Column(
    children: [
      Text("done")
    ],

  );
  default:return const Text("waiting for connection");

}return const Text("something went wrong");
        },

      ),
    );
  }
}