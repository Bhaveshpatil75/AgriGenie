
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import 'auth_exceptionss.dart';
import 'auth_providerr.dart';
import 'auth_user.dart';


class FirebaseAuthProvider implements AuthProviderr{
  @override
  Future<AuthUser> createUser({required email, required password}) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final user=currentUser;
      if (user != null){return user;}
      else{throw UserNotLoggedInAuthException();}
    }on FirebaseAuthException catch(e){
      if (e.code == "weak-password"){throw WeakPasswordAuthException();}
      else if (e.code == "email-already-in-use"){throw EmailAlreadyInUseAuthException();}
      else if (e.code == "invalid-email"){throw InvalidEmailAuthException();}
      else{
        throw GenericAuthException();
      }
    }catch (e){
      throw GenericAuthException();
    }

  }

  @override
  AuthUser? get currentUser{
    final user=FirebaseAuth.instance.currentUser;
    if (user != null){return AuthUser.fromFirebase(user);}
    else{return null;}
  }

  @override
  Future<AuthUser> logIn({required email, required password}) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user=currentUser;
      if (user != null){return user;}
      else{throw UserNotLoggedInAuthException();}
    }on FirebaseAuthException catch (e){
      if (e.code=="user-not-found"){throw UserNotFoundAuthException();}
      else if (e.code == "wrong-password"){throw WrongPasswordAuthException();}
      else {throw GenericAuthException();}

    }catch(e){
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async{
    final user=FirebaseAuth.instance.currentUser;
    if (user != null){
      await FirebaseAuth.instance.signOut();
    }
    else{
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendVerificationMail() async{
    final user=FirebaseAuth.instance.currentUser;
    if (user != null){
      await user.sendEmailVerification();
    }
    else{
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialize() async{
    await Firebase.initializeApp(  //initialising
        options: DefaultFirebaseOptions.currentPlatform
    );
  }
}