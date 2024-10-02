

import 'auth_providerr.dart';
import 'auth_user.dart';
import 'firebase_auth_provider.dart';

class AuthService implements AuthProviderr{
  final AuthProviderr authProviderr;

  AuthService(this.authProviderr);

  factory AuthService.firebase()=>AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({required email, required password}) {
    return authProviderr.createUser(email: email, password: password,);
  }

  @override

  AuthUser? get currentUser => authProviderr.currentUser;

  @override
  Future<AuthUser> logIn({required email, required password}) {
    return authProviderr.logIn(email: email, password: password);
  }

  @override
  Future<void> logOut() {
    return authProviderr.logOut();
  }

  @override
  Future<void> sendVerificationMail() {
    return authProviderr.sendVerificationMail();
  }

  @override
  Future<void> initialize()=>authProviderr.initialize();

}