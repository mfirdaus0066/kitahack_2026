import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  final String uid;
  MyUser({required this.uid});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser? _userFromFirebase(User? user) {
  return user != null ? MyUser(uid: user.uid) : null;
  }

  // Sign up logic
  Future <MyUser?> registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password);

      User? user = result.user;

      return _userFromFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // Sign in logic
  Future <MyUser?> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password);

      User? user = result.user;

      return _userFromFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  
  // Sign out logic
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}