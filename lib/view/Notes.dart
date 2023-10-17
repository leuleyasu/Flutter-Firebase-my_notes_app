import 'package:flutter/material.dart';
import 'dart:developer' as developertool show log;

import 'package:flutter_application_1/main.dart';
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}
enum MenuAction {logout}
class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
actions:  [
  PopupMenuButton<MenuAction>(
onSelected: (value)async{
  switch (value) {
    case MenuAction.logout:
final shouldlogout= await showLogOutDialog(context);
developertool.log(shouldlogout.toString());
      break;
    default:
  }
},
    itemBuilder: (context)
{
  return const[
      PopupMenuItem<MenuAction>(value: MenuAction.logout,child: Text("logout"),)
  ];
}

  )
],
      ),

    );
  }

}