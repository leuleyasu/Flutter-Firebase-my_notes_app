
import 'package:flutter_application_1/services/auth/auth_exception.dart';
import 'package:flutter_application_1/services/auth/auth_provider.dart';
import 'package:flutter_application_1/services/auth/auth_user.dart';
import 'package:test/test.dart';
import 'test_exception.dart';

void main(){

  group('Mock Authentication', () {
    final provider=MockAuthProvider();
    test('it shoudlnt be initialized to begin with', () {
   expect(provider._isinitialized, false);

    });
     test('cant logout if not initialized', () {
   expect(provider.logout(), throwsA(const TypeMatcher<NotInitializedException>()));

    });
    test('it shoud be initialized to begin with', () async {
  await provider.initializeApp();

      expect( provider._isinitialized, true);

    });
       test('user should be null after initialization', () async {
      expect( provider.currentUser, null);

    });
          test('should be able to initilized before 2 sec', () async {
      await provider.initializeApp();
      expect( provider._isinitialized, true);

    }, timeout: const Timeout(Duration(seconds: 2))

    );

    test('creating user should delegate to login function', () async {
    final bademail=  provider.createuser(email: "someone@gmail.com",
    password: "password",);
    expect(bademail, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

   final badpassword= provider.createuser(email: "email@gmail.com",
    password: "something",);

expect(badpassword, throwsA(const TypeMatcher<WrongPasswordAuthException>()));

   final user = await provider.createuser(email: "anything@gmail.com",
    password: "anypassword",);

    expect(provider.currentUser, user);
    expect(user.isEmailVerfied, false);

    });
    test('Logged in user should be able to get verified ', () async{
      provider.sendEmailVerfication();
      final user =provider.currentUser;
      expect(user, isNotNull);
       expect(user!.isEmailVerfied, true);

    });
    test('should be able to logout and log in again', () async{
      await provider.logout();
      await provider.login(email: "email", password: "password123");
final user =provider.currentUser;
    expect(user, isNotNull);

    });

  });
}



class MockAuthProvider implements AuthProvider{

  AuthUser? _user;

  var _isinitialized = false;
  bool get isInitialized=> _isinitialized;
  @override
  Future<void> initializeApp() async {
    await Future.delayed(const Duration(seconds: 1));
    _isinitialized=true;

  }
  @override
  Future<AuthUser> createuser({required String email,
   required String password}) async{
if (!isInitialized) throw NotInitializedException();

await Future.delayed(const Duration(seconds: 1));
return login(email: email, password: password);

}


  @override
  //
  AuthUser? get currentUser => _user;



  @override
  Future<AuthUser> login({required String email,
  required String password}) {
   if (!isInitialized) throw NotInitializedException();
   if (email=="someone@gmail.com") throw UserNotFoundAuthException();
   if (password=="something") throw WrongPasswordAuthException();
  const user= AuthUser(isEmailVerfied:false);
  _user=user;

return Future.value( user);
  }

  @override
  Future<void> logout() async{
     if (!isInitialized) throw NotInitializedException();
    if (_user==null) throw UserNotFoundAuthException();
     await Future.delayed(const Duration(seconds: 1));
     _user=null;


  }

  @override
  Future<void> sendEmailVerfication() async{
  if(!isInitialized) throw UserNotFoundAuthException();
  final user=_user;
  if(user==null) throw UserNotFoundAuthException();
  const newuser= AuthUser(isEmailVerfied: true);
   _user=newuser;

  }

}