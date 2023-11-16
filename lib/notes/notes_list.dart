import 'package:flutter/material.dart';
import 'package:flutter_application_1/note_crud/notes_services.dart';
import 'package:flutter_application_1/utilities/ShowErrorDialog.dart';

typedef DeleteNoteCallback = void Function(DatabaseNote note);

class NotesList extends StatelessWidget {
  final List<DatabaseNote> note;
  final DeleteNoteCallback onDeleteNote;
  const NotesList({super.key, required this.note, required this.onDeleteNote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: note.length,
        itemBuilder: (context, index) {
          final allnote = note[index];
          return ListTile(
            title: Text(
              allnote.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(onPressed:() async{
 final shouldelte= await showDelteDialog(context);
 if (shouldelte) {
  onDeleteNote(allnote);

 }
            },
             icon: const Icon(Icons.delete) ,

            )
          );

        });
  }
}
