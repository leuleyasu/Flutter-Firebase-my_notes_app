// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class AuthUser {

  final bool isEmailVerfied;
  final String? email;
  const AuthUser({
    required  this.isEmailVerfied,
    this.email,
});

  factory AuthUser.fromFirebase(User user)=>AuthUser( email:user.email ,isEmailVerfied: user.emailVerified );
}
