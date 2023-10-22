
//login exception
class UserNotFoundAuthException implements Exception{}
class WrongPasswordAuthException implements Exception{}
// register exception
class WeakPasswordAuthException implements Exception{}
class EmailAlreadyInUseExistAuthException implements Exception{}
class InvalidEmailException implements Exception{}
//generic exception
class GenericAuthException implements Exception{}
class UserNotLoggedInException implements Exception{ }