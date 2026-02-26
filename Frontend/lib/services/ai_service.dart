import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';

class AIService {
  late final GenerativeModel _model;

  AIService() {
    final firebaseAI = FirebaseAI.googleAI();
    _model = firebaseAI.generativeModel(model: 'gemini-2.0-flash');
  }

  Future<Map<String, dynamic>> analyzeEntry(String userEntry) async {
    final prompt = '''
You are a compassionate mental health companion AI for a plant care therapy app.

Analyze the following journal entry and respond ONLY in this exact JSON format:
{
  "mood": "happy" or "sad" or "neutral",
  "score": (number from -1.0 to 1.0),
  "conclusion": "Warm 1-2 sentence summary of user's day",
  "tip": "A gentle mental health encouragement"
}

User's entry: "$userEntry"

Respond with JSON only. No extra text.
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '{}';
      final cleaned = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (e) {
      return {
        'mood': 'neutral',
        'score': 0.0,
        'conclusion': 'Thanks for sharing your day with me.',
        'tip': 'Take a moment to breathe and care for your plant.',
      };
    }
  }
}