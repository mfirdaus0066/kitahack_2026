import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String uid;
  MyUser({required this.uid});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser? _userFromFirebase(User? user) {
  return user != null ? MyUser(uid: user.uid) : null;
  }

  User? get currentUser => _auth.currentUser;
  
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

  // delete account logic
  Future<void> deleteAccount(String uid, String email, String password) async {
    try {
      // Re-authenticate first
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await _auth.currentUser!.reauthenticateWithCredential(credential);

      // Delete Firestore document
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      // Delete auth account
      await _auth.currentUser!.delete();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}