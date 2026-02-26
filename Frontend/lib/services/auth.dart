import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

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

  // give user a plant on first time login / every week
  Future<void> assignWeeklyPlant(String uid) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userDoc = await userRef.get();
    final data = userDoc.data();

    final plantsSnapshot = await FirebaseFirestore.instance.collection('plants').get();
    if (plantsSnapshot.docs.isEmpty) return;

    final now = DateTime.now();

    // First time — no plant assigned yet
    if (data == null || data['plantAssignedAt'] == null) {
      final random = Random();
      final randomPlant = plantsSnapshot.docs[random.nextInt(plantsSnapshot.docs.length)];

      // Add to userPlants subcollection
      await userRef.collection('userPlants').add({
        'plantId': randomPlant.id,
        'dateAdded': FieldValue.serverTimestamp(),
      });

      // Set as current plant
      await userRef.set({
        'currentPlantId': randomPlant.id,
        'plantAssignedAt': Timestamp.fromDate(now),
      }, SetOptions(merge: true));

      return;
    }

    // Check if 7 days have passed
    final plantAssignedAt = (data['plantAssignedAt'] as Timestamp).toDate();
    final difference = now.difference(plantAssignedAt).inDays;

    if (difference >= 7) {
      // Get already owned plant IDs to avoid duplicates
      final userPlants = await userRef.collection('userPlants').get();
      final ownedIds = userPlants.docs.map((d) => d['plantId'] as String).toList();

      // Filter out already owned plants
      final availablePlants = plantsSnapshot.docs
          .where((p) => !ownedIds.contains(p.id))
          .toList();

      if (availablePlants.isEmpty) return; // User has all plants

      final random = Random();
      final newPlant = availablePlants[random.nextInt(availablePlants.length)];

      // Add to userPlants subcollection
      await userRef.collection('userPlants').add({
        'plantId': newPlant.id,
        'dateAdded': FieldValue.serverTimestamp(),
      });

      // Update current plant
      await userRef.set({
        'currentPlantId': newPlant.id,
        'plantAssignedAt': Timestamp.fromDate(now),
      }, SetOptions(merge: true));
    }
  }
}