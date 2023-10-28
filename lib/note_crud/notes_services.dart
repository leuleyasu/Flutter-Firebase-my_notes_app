
import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'crud_exception.dart';
class NotesService {
  Database? _db;
  Future<DatabaseNote>updateNote({required DatabaseNote note,required String text})
async{
  final db =_getDatabaseOrThrow();
  await getNote(id:note.id);
 final updateCount= await db.update(noteTable,{textColumn:text,isSyncedWithCloudColumn:0,});
if (updateCount==0) {
throw CouldUpdateNoteException();
}else{
  return await getNote(id: note.id);
}

}
  Future<Iterable <DatabaseNote>>getAllNote()async{
    final db =_getDatabaseOrThrow();
    final notes= await db.query(noteTable);

     if (notes.isEmpty) {
throw CouldFindNoteException();
     }
     return notes.map((notesRow) => DatabaseNote.fromROw(notesRow));
  }
   Future<DatabaseNote>getNote({required int id})async{
    final db =_getDatabaseOrThrow();
    final notes= await db.query(noteTable,limit: 1,where: 'id =?',whereArgs: [id]);

     if (notes.isEmpty) {
throw CouldFindNoteException();
     }
     return DatabaseNote.fromROw(notes.first);
  }
  Future<int>deleteAllNote({required int userId})async {
    final db=_getDatabaseOrThrow();
    final deleteAllNote= await db.delete(noteTable);
  if (deleteAllNote==0) {
  throw CouldDeleteNoteException();

}
return deleteAllNote;
  }
Future<void>deleteNote({required int id})async{
final db=_getDatabaseOrThrow();
final deletecount =db.delete(noteTable,
where: 'id=?',whereArgs: [id]);
if (deletecount.isNull) {
  throw CouldDeleteNoteException();
}
}
Future<DatabaseNote>createNote({required DatabaseUser owner})async{
final db=_getDatabaseOrThrow();

final dbuser=await getUser(email: owner.email);
if (dbuser!=owner) {
  throw CouldNotFindUserException();
}
const text='';
// create the note
final noteid=await db.insert(userTable, {userIdColumn:owner.id,textColumn:text,isSyncedWithCloudColumn:1});
final note =DatabaseNote(id: noteid, userId: owner.id, text: text, isSyncedWithCloud: true);
return note;
}

Future<DatabaseUser>getUser({required String email})async{
    final db =_getDatabaseOrThrow();
    final result=await db.query(userTable,limit: 1,
    where: 'email=?',whereArgs: [email.toLowerCase()]);
    if (result.isEmpty) {
      CouldNotFindUserException();

    }
    return DatabaseUser.fromROw(result.first);
  }
Future<DatabaseUser>createUser({required String email})async{
  final db =_getDatabaseOrThrow();
  final results=await db.query(userTable,limit: 1,
  where: "email=?",whereArgs: [email.toLowerCase()]);
  if (results.isNotEmpty) {
throw UserAlreadyExistException();
  }
// create the user
final userId= await db.insert(userTable, { emailColumn:email.toLowerCase() });
return DatabaseUser(id: userId, email: email);

}
Future<void> deleteUser({required String email})async{
  final db =_getDatabaseOrThrow();
  // delete the user
final deleteCount= await db.delete(userTable,where: 'email=?',whereArgs: [email.toLowerCase()]);

if (deleteCount!=1) {
  throw CouldNotDelteUserException();
}

}


  Database _getDatabaseOrThrow(){
      final db=_db;
      if(db==null){
throw DatabaseIsNotOpenException();

      }else{
        return db;
      }
    }

  Future<void>close() async{
final db=_db;
if (db==null) {
  throw DatabaseIsNotOpenException();
}else{
  await db.close();
  _db=null;
}
  }
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException(


      );
    } else {
      try {
            final docspath = await getApplicationDocumentsDirectory();
     final dbpath=join(docspath.path,dbName);
       final db= await openDatabase(dbpath);
_db=db;


const createUserTable= '''  CREATE TABLE IF NOT EXIST "user" (
	"id"	INTEGER NOT NULL,
	"email"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
); ''';
await db.execute(createUserTable);
const  createNoteTable =  ''' CREATE TABLE "user" (
	"id"	INTEGER NOT NULL,
	"email"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);   ''';
await db.execute(createNoteTable);


      }on MissingPlatformDirectoryException{
    throw UnableToGetDocumentDirectoryException();
      }


       catch (e) {
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
