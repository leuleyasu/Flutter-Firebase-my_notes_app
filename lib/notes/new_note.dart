import 'package:flutter/material.dart';
import 'package:flutter_application_1/note_crud/notes_services.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
      DatabaseNote? _note;
  late final   NotesService _noteService;
 late final TextEditingController _textEditingController;

@override
void initState() {
  _noteService =NotesService();
  _textEditingController=TextEditingController();
  super.initState();

}
Future<DatabaseNote>createNewNote() async{
final existingnote =_note;
if (existingnote!=null) {
  return  existingnote;
}

  final email=AuthService.firbase().currentUser!.email!;
  final owner= await _noteService.getUser(email: email);
  final note = await _noteService.createNote(owner: owner);
return note;

}

void _deleteNoteIfTextIsEmpty(){
final  note=_note;
  final text =_textEditingController.text;
if (text.isEmpty && note!=null) {

 _noteService.deleteNote(id: note.id);

}
}
void _textControllerListener() async{
  final note=_note;
  final text=_textEditingController.text;
  if (note==null) {
    return;

  }
  await _noteService.updateNote(note: note, text: text);
}
void _saveNoteText() async{
final note =_note;
final text=_textEditingController.text;
if (text.isNotEmpty && note!=null) {
await _noteService.updateNote(note: note, text: text);

}}
void _ListenTextEditingController(){
  _textEditingController.removeListener(_textControllerListener);
  _textEditingController.addListener(_textControllerListener);
}


@override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteText();
    _textEditingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
future: createNewNote(),
      builder:  (context, snapshot) {
       switch (snapshot.connectionState) {
         case ConnectionState.done:
        _note=snapshot.data as DatabaseNote;
        _ListenTextEditingController();
        return TextField(
          controller: _textEditingController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: "Type your note here"
          ),

        );
         default: return const CircularProgressIndicator();
       }
      },

    );
}}