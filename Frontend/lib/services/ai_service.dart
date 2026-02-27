import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';

class AIService {
  late final GenerativeModel _model;

  AIService() {
    final firebaseAI = FirebaseAI.googleAI(appCheck: null);
    _model = firebaseAI.generativeModel(
      model: 'gemini-2.5-flash',
    );
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
      print('AI error: $e');
      return {
        'mood': 'neutral',
        'score': 0.0,
        'conclusion': 'Thanks for sharing your day with me.',
        'tip': 'Take a moment to breathe and care for your plant.',
      };
    }
  }

  Future<String> generateWeeklySummary(
      List<Map<String, dynamic>> entries) async {
    if (entries.isEmpty) return 'No entries this week.';

    final entriesText = entries
        .map((e) =>
            'Date: ${e['date']}\nUser said: ${e['userMessage']}\nMood: ${e['mood']}')
        .join('\n\n');

    final prompt = '''
You are a warm and caring plant companion AI for a mental health therapy app.

Based on the user's journal entries this week, write a short encouraging weekly summary.

Rules:
- Start with "This week, you experienced..."
- Mention if the overall week was good, mixed, or difficult
- Be plant-themed and encouraging
- Be 2-3 sentences only
- End with a short motivational line for next week
- Do NOT use markdown, bullet points, or formatting
- Respond with plain text only

Here are the entries:
$entriesText
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text?.trim() ??
          'You had a meaningful week. Keep growing!';
    } catch (e) {
      print('AI weekly summary error: $e');
      return 'You had a meaningful week. Keep growing!';
    }
  }
}