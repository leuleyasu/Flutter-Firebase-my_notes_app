import 'package:flutter_application_1/services/Auth/auth_provider.dart';
import 'package:flutter_application_1/services/Auth/firbase_auth_provider.dart';
import 'package:flutter_application_1/services/auth_user.dart';

class AuthService implements AuthProvider{
    @override
  Future<void> initializeApp() =>provider.initializeApp();
  final AuthProvider provider;
  AuthService(this.provider);
factory AuthService.firbase()=>AuthService(FirebaseAuthProvider());
  @override
  Future<AuthUser> createuser({required String email,
  required String password}) => provider.createuser(email: email,
   password: password,);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({required String email,
  required String password,}) =>provider.login(email: email,
   password: password,);
  @override
  Future<void> logout() =>provider.logout();

  @override
  Future<void> sendEmailVerfication() =>provider.sendEmailVerfication();


}