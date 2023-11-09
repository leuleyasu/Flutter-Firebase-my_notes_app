import 'dart:async';
import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'crud_exception.dart';

class NotesService {
  Database? _db;
List<DatabaseNote> _notes=[] ;

final _noteStreamController=StreamController <List<DatabaseNote>>.broadcast();
Stream<List<DatabaseNote>> get allNote=>_noteStreamController.stream;

Future<DatabaseUser>getOrCreateUser({required String email})async{
try {
    final user= await getUser(email: email);
    return user;


} on CouldNotFindUserException{
return await createUser(email: email);
}

 catch (e) {
 rethrow;
}


}

Future<void>_cachenote()async{

  final allnote= await getAllNote();
   _notes=allnote.toList();
  _noteStreamController.add(_notes);
}


  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    final db = _getDatabaseOrThrow();
    //first get the old data
  final getnotes= await getNote(id: note.id);
  //update here
   final updateCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });
    if (updateCount == 0) {
      throw CouldUpdateNoteException();
    } else {
      //remove the old data that has featched first
_notes.removeWhere((note) => note.id==getnotes.id);
// update the data here interally
_notes.add(getnotes);
// update the data to ui if
_noteStreamController.add(_notes);
return getnotes;
    }

  }

  Future<Iterable<DatabaseNote>> getAllNote() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);

    if (notes.isEmpty) {
      throw CouldFindNoteException();
    }else{
 final getallnotes=notes.map((notesRow) => DatabaseNote.fromROw(notesRow));
return getallnotes;
    }

  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes =
        await db.query(noteTable, limit: 1,
        where: 'id =?', whereArgs: [id]);

    if (notes.isEmpty) {
      throw CouldFindNoteException();
    }

    else{
      final note =DatabaseNote.fromROw(notes.first);
      // it removes from _notes list and the getAllNote Function will featch the updated  data from the databse
  _notes.removeWhere((note) => note.id==id);
   _notes.add(note);
   _noteStreamController.add(_notes);
return note;
    }


  }

  Future<int> deleteAllNote({required int userId}) async {
    final db = _getDatabaseOrThrow();
    final deleteAllNote = await db.delete(noteTable);
    _notes=[];
_noteStreamController.add(_notes);
    if (deleteAllNote == 0) {
      throw CouldDeleteNoteException();
    }
    return deleteAllNote;
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedcount = db.delete(noteTable, where: 'id=?', whereArgs: [id]);

    if (deletedcount.isNull) {
      throw CouldDeleteNoteException();
    }
    else{
      _notes.removeWhere((note) => note.id==id);
      _noteStreamController.add(_notes);

    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    final dbuser = await getUser(email: owner.email);
    if (dbuser != owner) {
      throw CouldNotFindUserException();
    }
    const text = '';
// create the note
    final noteid = await db.insert(noteTable,
        {userIdColumn: owner.id, textColumn: text,
        isSyncedWithCloudColumn: 1});
    final note = DatabaseNote(
        id: noteid, userId: owner.id,
        text: text, isSyncedWithCloud: true);


     _notes.add(note);
     _noteStreamController.add(_notes);

    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(userTable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);
    if (result.isEmpty) {
      CouldNotFindUserException();
    }
    return DatabaseUser.fromROw(result.first);
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(userTable,
        limit: 1, where: "email=?", whereArgs: [email.toLowerCase()]);

    if (results.isNotEmpty) {
      throw UserAlreadyExistException();
    }
// create the user
    final userId =
        await db.insert(userTable, {emailColumn: email.toLowerCase()});
    return DatabaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    // delete the user
    final deleteCount = await db
        .delete(userTable, where: 'email=?', whereArgs: [email.toLowerCase()]);

    if (deleteCount != 1) {
      throw CouldNotDelteUserException();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    } else {
      try {
        final docspath = await getApplicationDocumentsDirectory();
        final dbpath = join(docspath.path, dbName);
        final db = await openDatabase(dbpath);
        _db = db;
      //lets featch all database user notes and flow in the stream controller.
        await _cachenote();
        const createUserTable = '''  CREATE TABLE IF NOT EXIST "user" (
	"id"	INTEGER NOT NULL,
	"email"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
); ''';
        await db.execute(createUserTable);
        const createNoteTable = ''' CREATE TABLE IF NOT EXIST "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT NOT NULL,
	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id","user_id"),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);   ''';
        await db.execute(createNoteTable);
      } on MissingPlatformDirectoryException {
        throw UnableToGetDocumentDirectoryException();
      } catch (e) {
        print(e);
      }
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromROw(Map<String, Object?> map)
      : id = map[idCoulumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'person, ID =$id,email=$email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;
  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromROw(Map<String, Object?> map)
      : id = map[idCoulumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            map[isSyncedWithCloudColumn] as int == 1 ? true : false;
}

const dbName = 'my_note.db';
const userTable = "user";
const noteTable = "note";
const textColumn = 'text';
const idCoulumn = 'id';
const userIdColumn = 'userId';
const isSyncedWithCloudColumn = 'isSyncedWithCloud';
const emailColumn = "email";
