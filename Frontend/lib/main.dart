import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:arnima/screens/add_screen.dart';
import 'firebase_options.dart';
import 'screens/idea_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  // TODO: 1. Flutter bindings and Firebase Initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arnima App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF20854F),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF20854F),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      // home: MyHomePage(title: "Idea Board"), //You Have to Remove this first
      // TODO: 2. Change this to Routes
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => MyHomePage(title: "Arnima"),
        '/home2': (context) => HomeScreen(),
        '/add': (context) => AddScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// TODO: 3. The Widget Structure
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: const IdeaStream(), // replace the place holder with Idea Stream
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        tooltip: 'Add Idea',
        child: const Icon(Icons.add),
      ),
    );
  }
}
