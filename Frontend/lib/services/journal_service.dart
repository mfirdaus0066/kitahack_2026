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

    final userDoc = await _firestore.collection('users').doc(uid).get();
    final currentPlantId = userDoc.data()?['currentPlantId'];
    if (currentPlantId == null) throw Exception('No plant assigned this week');

    final userPlantsQuery = await _firestore
        .collection('users')
        .doc(uid)
        .collection('userPlants')
        .where('plantId', isEqualTo: currentPlantId)
        .limit(1)
        .get();

    if (userPlantsQuery.docs.isEmpty) throw Exception('User plant not found');
    final userPlantDocId = userPlantsQuery.docs.first.id;

    final today = DateTime.now();
    final dateKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // Save to dailyStates under userPlants
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

    // Call AI
    final aiResult = await _aiService.analyzeEntry(entry);

    // Update dailyStates
    await dailyRef.update({
      'mood': aiResult['mood'],
      'score': aiResult['score'],
      'conclusion': aiResult['conclusion'],
      'tip': aiResult['tip'],
      'status': 'done',
    });

    // Also save to dailyResponses for weekly report
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('dailyResponses')
        .doc(dateKey)
        .set({
      'userMessage': entry,
      'aiResponse': aiResult['conclusion'] ?? '',
      'mood': aiResult['mood'] ?? 'neutral',
      'plantId': currentPlantId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update currentMood for plant appearance
    await _firestore.collection('users').doc(uid).update({
      'currentMood': aiResult['mood'],
    });

    return aiResult;
  }

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

  Future<List<Map<String, dynamic>>> getDailyResponsesForWeek(
      DateTime weekStart, DateTime weekEnd) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('dailyResponses')
        .get();

    return snapshot.docs
        .where((doc) {
          final createdAt =
              (doc.data()['createdAt'] as Timestamp?)?.toDate();
          if (createdAt == null) return false;
          return createdAt.isAfter(weekStart) && createdAt.isBefore(weekEnd);
        })
        .map((doc) => {
              'date': doc.id,
              'userMessage': doc.data()['userMessage'] ?? '',
              'aiResponse': doc.data()['aiResponse'] ?? '',
              'mood': doc.data()['mood'] ?? 'neutral',
            })
        .toList();
  }
}