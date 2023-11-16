import 'package:flutter/material.dart';
import 'dart:developer' as developertool show log;
import 'package:flutter_application_1/constants/Routes.dart';
import 'package:flutter_application_1/note_crud/notes_services.dart';
import 'package:flutter_application_1/notes/notes_list.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/enum/menu_action.dart';

import '../utilities/ShowErrorDialog.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final NotesService _notesService;
  String get useremail => AuthService.firbase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
          actions: [
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldlogout = await showLogOutDialog(context);
                  developertool.log(shouldlogout.toString());
                  if (shouldlogout) {
                    await AuthService.firbase().logout();

                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, loginRoute, (route) => false);
                    }
                  }
                  developertool.log(MenuAction.logout.toString());
                  break;
                default:
              }
            }, itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("logout"),
                )
              ];
            }),
          ],
        ),
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: useremail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                return StreamBuilder(
                    stream: _notesService.allNote,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final allnote = snapshot.data as List<DatabaseNote>;
                        return NotesList(note: allnote, onDeleteNote: (note) async{

                                  await _notesService.deleteNote(id: note.id);


                        });
                      } else {
                        return const CircularProgressIndicator();
                      }
                    });

              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
