import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser{
  final bool isEmailVerified;
  final String uid;

  AuthUser({required this.isEmailVerified,required this.uid});

  factory AuthUser.fromFirebase(User user) => AuthUser(isEmailVerified:user.emailVerified,uid: user.uid);

}