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

    // 1. Get currentPlantId from user doc
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final currentPlantId = userDoc.data()?['currentPlantId'];
    if (currentPlantId == null) throw Exception('No plant assigned this week');

    // 2. Find the matching userPlant document
    final userPlantsQuery = await _firestore
        .collection('users')
        .doc(uid)
        .collection('userPlants')
        .where('plantId', isEqualTo: currentPlantId)
        .limit(1)
        .get();

    if (userPlantsQuery.docs.isEmpty) throw Exception('User plant not found');
    final userPlantDocId = userPlantsQuery.docs.first.id;

    // 3. Use today's date as document ID (one entry per day)
    final today = DateTime.now();
    final dateKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // 4. Save entry immediately with 'analyzing' status
    final dailyRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('userPlants')
        .doc(userPlantDocId)
        .collection('dailyStates')
        .doc(dateKey);

    await dailyRef.set({
      'entry': entry,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'analyzing',
    });

    // 5. Call AI to analyze
    final aiResult = await _aiService.analyzeEntry(entry);

    // 6. Update with AI result
    await dailyRef.update({
      'mood': aiResult['mood'],
      'score': aiResult['score'],
      'conclusion': aiResult['conclusion'],
      'tip': aiResult['tip'],
      'status': 'done',
    });

    // 7. Also update the user's currentMood for plant appearance
    await _firestore.collection('users').doc(uid).update({
      'currentMood': aiResult['mood'],
    });

    return aiResult;
  }

  // Fetch all daily states for current week's plant
  Future<List<Map<String, dynamic>>> getWeeklyEntries() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final userDoc = await _firestore.collection('users').doc(uid).get();
    final currentPlantId = userDoc.data()?['currentPlantId'];
    if (currentPlantId == null) return [];

    final userPlantsQuery = await _firestore
        .collection('users')
        .doc(uid)
        .collection('userPlants')
        .where('plantId', isEqualTo: currentPlantId)
        .limit(1)
        .get();

    if (userPlantsQuery.docs.isEmpty) return [];
    final userPlantDocId = userPlantsQuery.docs.first.id;

    final dailyStates = await _firestore
        .collection('users')
        .doc(uid)
        .collection('userPlants')
        .doc(userPlantDocId)
        .collection('dailyStates')
        .orderBy('timestamp')
        .get();

    return dailyStates.docs.map((doc) => doc.data()).toList();
  }
}