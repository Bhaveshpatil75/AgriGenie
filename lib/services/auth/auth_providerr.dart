

import 'auth_user.dart';

abstract class AuthProviderr {
  AuthUser? get currentUser;

  Future<AuthUser> logIn({required email, required password});

  Future<AuthUser> createUser({required email, required password});

  Future<void> logOut();

  Future<void> sendVerificationMail();

  Future<void> initialize();

}