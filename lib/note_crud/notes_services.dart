// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseAlreadyOpenException implements Exception {}
class UnableToGetDocumentDirectoryException implements Exception{}
class MissingPlatformDirectoryException implements Exception {}
class DatabaseIsNotOpenException implements Exception{}
class CouldNotDelteUserException implements Exception{}
class UserAlreadyExistException implements Exception{}
class CouldNotFindUserException implements Exception{}
class CouldDeleteNoteException implements Exception{}

class NotesService {
  Database? _db;



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
