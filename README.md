# 🌱 ARNIMA — AI-Powered Mental Health Companion

> *"Where conversations heal and gardens grow."*

Presented by **Team Shutdown**

---

## 👥 Team Introduction

**Team Shutdown** is a group of passionate developers committed to leveraging technology for social good. ARNIMA was built as part of our initiative to address mental health challenges through accessible, engaging, and AI-driven solutions.

| Team Members | 
|---|
| Muhammad Firdaus bin Mohd Nasri |
| Muhammad Ariff Izham bin Md Sanusi |
| Muhammad Arif Naufal bin Nazri |
| Muhammad Haikal bin Rosmadi |

---

## 📌 Project Overview

### 🌍 Target SDG
**SDG Goal 3 — Good Health and Well-being**
> *"Ensure healthy lives and promote well-being for all at all ages."*

### ❗ Problem Statement
According to the **World Health Organization (WHO)**, mental disorders are one of the most significant public health challenges in the WHO European Region — ranking as the **third leading cause of overall disease burden** and a major contributor to disability worldwide. Access to mental health support remains limited, stigmatized, and often too expensive for the average person.

### 💡 Our Solution
**ARNIMA** is an AI-powered therapy application that allows users to:
- Express their feelings freely through natural conversation with an AI therapist
- Nurture a **virtual plant** that dynamically reflects their current mental health state — a living, visual metaphor for emotional well-being

The more a user engages in healthy conversations and self-care, the more their plant grows and flourishes. Neglect or emotional distress causes the plant to wilt — creating a gentle, non-judgmental reminder to check in with oneself.

---

## ✨ Key Features

### 🤖 AI Therapy Chat
ARNIMA uses a conversational AI to provide empathetic, supportive dialogue. Users can open up about their feelings at any time of day without fear of judgment. The AI responds thoughtfully, validates emotions, and gently guides users toward healthier thinking patterns — all in a private, safe space.

### 🪴 Personalized Mental Health Garden
Each user has a unique virtual garden where their plant's health mirrors their emotional well-being over time. This gamified, visual metaphor makes mental health progress tangible and rewarding:
- Consistent engagement → thriving, blooming plant 🌸
- Periods of distress or inactivity → wilting plant that needs care 🌿
- Acts as a daily nudge to maintain mental health routines

---

## 🛠️ Tech Stack

### Google Technologies
| Technology | Role |
|---|---|
| **Flutter** | Cross-platform mobile UI framework for building the iOS & Android app |
| **Firebase** | Backend-as-a-service for authentication, hosting, and real-time data |
| **Cloud Firestore** | NoSQL cloud database for storing user sessions, mood history, and garden state |
| **Gemini 2.5 Flash** | Core AI model powering the therapy conversation engine |

### Supporting Tools
| Tool | Role |
|---|---|
| **Dart** | Primary programming language for Flutter |
| **Firebase Auth** | Secure user authentication (email/Google sign-in) |
| **Firebase Analytics** | Usage tracking and user behavior insights |

---

## 🏗️ Implementation Details & Innovation

### System Architecture

```
User (Flutter App)
      │
      ▼
Firebase Auth ──── Verify Identity
      │
      ▼
Gemini 2.5 Flash API ──── Process user message → Generate empathetic response
      │
      ▼
Cloud Firestore ──── Store conversation history + sentiment score + garden state
      │
      ▼
Flutter UI ──── Render response + Update plant visualization
```

### Workflow
1. **User opens app** → Authenticated via Firebase Auth
2. **User sends a message** → Sent to Gemini 2.5 Flash with a therapeutic system prompt
3. **Gemini generates response** → Empathetic reply streamed back to the user
4. **Sentiment analysis** → Message sentiment is scored and stored in Cloud Firestore
5. **Garden update** → Plant health is recalculated based on cumulative sentiment score and engagement frequency
6. **State persisted** → All session data stored in Firestore for cross-device continuity

### Innovation
- **Emotional plant metaphor**: Instead of abstract mood scores or graphs, ARNIMA uses a living plant as an intuitive, emotionally resonant mental health indicator
- **Persistent memory**: Firestore enables the AI to reference past conversations, making each session feel continuous and personal
- **Low-barrier entry**: No appointment needed, no stigma — just open the app and talk

---

## ⚠️ Challenges Faced

1. **Prompt engineering for therapeutic tone** — Getting Gemini to consistently respond with empathy, appropriate boundaries, and non-clinical language required significant iteration on the system prompt
2. **Plant state logic** — Designing a fair and meaningful algorithm to map conversation sentiment to plant health stages without making it feel punishing or frustrating to users
3. **Real-time Firestore sync** — Ensuring the plant's visual state updated smoothly and in real time after each conversation session without latency issues
4. **Mental health safety guardrails** — Implementing safeguards so the AI appropriately escalates or redirects conversations involving crisis situations (e.g., self-harm mentions) to professional resources
5. **Cross-platform UI consistency** — Maintaining a visually consistent and smooth experience across both Android and iOS using Flutter

---

## ⚙️ Installation & Setup

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- A Firebase project with Firestore and Auth enabled
- A Gemini API key from [Google AI Studio](https://aistudio.google.com/)

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/arnima.git
cd arnima
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup
1. Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project
2. Enable **Authentication** (Email/Password and/or Google Sign-In)
3. Enable **Cloud Firestore** in test mode
4. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
5. Place them in the appropriate directories:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`

### 4. Configure Environment Variables
Create a `.env` file in the project root:
```env
GEMINI_API_KEY=your_gemini_api_key_here
```

> ⚠️ **Never commit your `.env` file or API keys to version control.**

### 5. Run the App
```bash
# For debug mode
flutter run

# For a specific device
flutter run -d android
flutter run -d ios
```

### 6. Build for Production
```bash
# Android APK
flutter build apk --release

# iOS (requires macOS + Xcode)
flutter build ios --release
```

---

## 🔭 Future Roadmap

Given more time and resources, here's what we'd love to add to ARNIMA:

| Feature | Description |
|---|---|
| 🎙️ **Voice Input** | Allow users to speak their feelings instead of typing, lowering the barrier further |
| 📊 **Mood Analytics Dashboard** | Weekly/monthly mood trend charts to help users track their emotional journey over time |
| 🧘 **Guided Exercises** | In-app breathing exercises, meditations, and CBT-style journaling prompts |
| 🌐 **Multilingual Support** | Extend AI conversations to Bahasa Malaysia, Mandarin, and other languages for broader accessibility |
| 👨‍⚕️ **Professional Referral System** | Intelligent detection of users who may need professional help, with seamless links to licensed therapists |
| 🔔 **Smart Reminders** | Personalized push notifications to remind users to check in when their plant needs care |
| 🌳 **Garden Expansion** | Multiple plant species, seasonal themes, and decorations to keep the garden experience fresh and motivating |
| 🤝 **Community Garden** | An opt-in shared garden space where users can support each other anonymously |

---

## 📊 Impact & User Feedback

We deployed a prototype and conducted initial user experience testing. Results showed positive reception across all measured categories, with users finding the plant metaphor particularly engaging and the AI responses genuinely supportive.

---

## 📄 License

This project was developed for educational and hackathon purposes. All rights reserved by Team Shutdown.

---

<p align="center">Made with 💚 by Team Shutdown</p>