import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ai_service.dart';

class JournalService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _aiService = AIService();

  Future<Map<String, dynamic>> submitJournalEntry(String entry) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');

    // 1. Save entry to Firestore immediately
    final docRef = await _firestore
        .collection('users')
        .doc(uid)
        .collection('journals')
        .add({
      'entry': entry,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'analyzing', // shows loading state
    });

    // 2. Call AI to analyze
    final aiResult = await _aiService.analyzeEntry(entry);

    // 3. Update Firestore with AI conclusion
    await docRef.update({
      'mood': aiResult['mood'],
      'score': aiResult['score'],
      'conclusion': aiResult['conclusion'],
      'tip': aiResult['tip'],
      'status': 'done',
    });

    return aiResult; // return to UI
  }

  // Fetch past journal entries
  Stream<QuerySnapshot> getJournalEntries() {
    final uid = _auth.currentUser?.uid;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('journals')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}