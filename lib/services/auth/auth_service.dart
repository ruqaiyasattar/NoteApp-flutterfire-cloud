import 'auth_provider.dart';
import 'auth_user.dart';
import 'firebase_auth_provider.dart';

class AuthService implements AuthProvider{

  final AuthProvider provider;

  const AuthService(this.provider);

  //factory constructor to that provides firebase
  factory AuthService.firebase() =>  AuthService(FireBaseAuthProvider());

  //create user
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) => provider.createUser(
    email: email,
    password: password,
  );

  //getting current user
  @override
  AuthUser? get currentUser => provider.currentUser;

  //login
  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,}) => provider.logIn(
    email: email,
    password: password,
  );

  //logout
  @override
  Future<void> logOut() => provider.logOut();

  //send email verification
  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> sendPasswordRest({required String toEmail}) =>
      provider.sendPasswordRest(toEmail: toEmail);



}