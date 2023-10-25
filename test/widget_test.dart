import 'package:flutter_application_1/services/auth/auth_provider.dart';
import 'package:flutter_application_1/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main(){

}
class NotInitializedException implements Exception{}
class MockAuthProvider implements AuthProvider{
  var _isinitialized = false;
  bool get isInitialized=> _isinitialized;
  Future<void> initializeApp() async {

  }
  @override
  Future<AuthUser> createuser({required String email,
   required String password}) {
    // TODO: implement createuser
    throw UnimplementedError();
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => throw UnimplementedError();



  @override
  Future<AuthUser> login({required String email, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerfication() {
    // TODO: implement sendEmailVerfication
    throw UnimplementedError();
  }

}