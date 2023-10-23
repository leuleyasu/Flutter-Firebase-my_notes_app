// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart'  show User;
import 'package:flutter/material.dart';


@immutable
class AuthUser {

  final bool isEmailVerfied;
  const AuthUser(
     this.isEmailVerfied,
  );


  factory AuthUser.fromFirebase(User user)=>AuthUser(user.emailVerified);
}
