import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Create document for first time user
Future<void> createUserDoc() async {
  try {
    final user = FirebaseAuth.instance.currentUser; // get Firebase User directly
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final docSnap = await docRef.get();

    if (!docSnap.exists) {
      await docRef.set({
        'email': user.email,
        'displayName': user.displayName ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('User doc created for: ${user.uid}');
    } else {
      print('User doc already exists for: ${user.uid}');
    }
  } catch (e) {
    print('Error creating user doc: $e');
  }
}