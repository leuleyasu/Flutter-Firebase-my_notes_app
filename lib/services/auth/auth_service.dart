import 'package:flutter_application_1/services/auth/auth_provider.dart';
import 'package:flutter_application_1/services/auth/firbase_auth_provider.dart';
import 'package:flutter_application_1/services/auth/auth_user.dart';
class AuthService implements AuthProvider {
  final AuthProvider provider;
    AuthService(this.provider);
  factory AuthService.firbase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initializeApp() => provider.initializeApp();


  @override
  Future<AuthUser> createuser(
          {required String email, required String password}) =>provider.createuser(
        email: email,
        password: password,
      );


  @override
  AuthUser? get currentUser => provider.currentUser;


  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) => provider.login(
        email: email,
        password: password,
      );
  @override
  Future<void> logout() => provider.logout();
  @override
  Future<void> sendEmailVerfication() => provider.sendEmailVerfication();
}