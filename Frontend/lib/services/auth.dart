import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'ai_service.dart';

class MyUser {
  final String uid;
  MyUser({required this.uid});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AIService _aiService = AIService();

  MyUser? _userFromFirebase(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  User? get currentUser => _auth.currentUser;

  Future<MyUser?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> deleteAccount(
      String uid, String email, String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await _auth.currentUser!.reauthenticateWithCredential(credential);
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      await _auth.currentUser!.delete();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> assignWeeklyPlant(String uid) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userDoc = await userRef.get();
    final data = userDoc.data();

    final plantsSnapshot =
        await FirebaseFirestore.instance.collection('plants').get();
    if (plantsSnapshot.docs.isEmpty) return;

    final now = DateTime.now();

    // First time
    if (data == null || data['plantAssignedAt'] == null) {
      final random = Random();
      final randomPlant =
          plantsSnapshot.docs[random.nextInt(plantsSnapshot.docs.length)];

      await userRef.collection('userPlants').add({
        'plantId': randomPlant.id,
        'dateAdded': FieldValue.serverTimestamp(),
      });

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
      // Generate weekly report before assigning new plant
      await _generateWeeklyReport(
          uid, data['currentPlantId'], plantAssignedAt, now);

      // Get already owned plant IDs
      final userPlants = await userRef.collection('userPlants').get();
      final ownedIds =
          userPlants.docs.map((d) => d['plantId'] as String).toList();

      final availablePlants = plantsSnapshot.docs
          .where((p) => !ownedIds.contains(p.id))
          .toList();

      if (availablePlants.isEmpty) return;

      final random = Random();
      final newPlant =
          availablePlants[random.nextInt(availablePlants.length)];

      await userRef.collection('userPlants').add({
        'plantId': newPlant.id,
        'dateAdded': FieldValue.serverTimestamp(),
      });

      await userRef.set({
        'currentPlantId': newPlant.id,
        'plantAssignedAt': Timestamp.fromDate(now),
        'currentMood': 'neutral', // reset mood for new week
      }, SetOptions(merge: true));
    }
  }

  Future<void> _generateWeeklyReport(
    String uid,
    String? currentPlantId,
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    // Fetch daily responses for the week
    final responsesSnapshot =
        await userRef.collection('dailyResponses').get();

    final weekResponses = responsesSnapshot.docs.where((doc) {
      final createdAt =
          (doc.data()['createdAt'] as Timestamp?)?.toDate();
      if (createdAt == null) return false;
      return createdAt.isAfter(weekStart) && createdAt.isBefore(weekEnd);
    }).toList();

    if (weekResponses.isEmpty) return;

    final List<Map<String, dynamic>> entries = weekResponses.map((doc) {
      return {
        'date': doc.id,
        'userMessage': doc.data()['userMessage'] ?? '',
        'aiResponse': doc.data()['aiResponse'] ?? '',
        'mood': doc.data()['mood'] ?? 'neutral',
      };
    }).toList();

    // Count moods
    final goodDays =
        entries.where((e) => e['mood'] == 'happy').length;
    final badDays =
        entries.where((e) => e['mood'] == 'sad').length;
    final totalDays = entries.length;

    // Determine overall mood
    String overallMood = 'mixed';
    if (goodDays > badDays) overallMood = 'good';
    if (badDays > goodDays) overallMood = 'bad';

    // Generate AI summary
    String aiSummary = '';
    try {
      aiSummary = await _aiService.generateWeeklySummary(entries);
    } catch (e) {
      print('AI summary error: $e');
      aiSummary =
          'You responded $totalDays days this week. Keep growing!';
    }

    final weekStr =
        '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')}';

    await userRef.collection('weeklyReports').doc(weekStr).set({
      'plantId': currentPlantId,
      'weekStart': Timestamp.fromDate(weekStart),
      'weekEnd': Timestamp.fromDate(weekEnd),
      'totalDaysResponded': totalDays,
      'goodDays': goodDays,
      'badDays': badDays,
      'overallMood': overallMood,
      'aiSummary': aiSummary,
      'entries': entries,
      'generatedAt': FieldValue.serverTimestamp(),
    });
  }
}