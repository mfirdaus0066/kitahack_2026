import 'package:arnima/screens/garden_screen.dart';
import 'package:arnima/screens/info_screen.dart';
import 'package:arnima/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/edit_user_screen.dart';

void main() async {
  // TODO: 1. Flutter bindings and Firebase Initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arnima App',
      theme: ThemeData(
        fontFamily: 'JejuHallasan',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF20854F),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'JejuHallasan',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF20854F),
          brightness: Brightness.dark,
          surface: Color(0xFF1E1E1E),
          surfaceContainer: Color(0xFF2C2C2C),
        ),
      ),
      themeMode: _themeMode,
      // home: MyHomePage(title: "Idea Board"), //You Have to Remove this first
      // TODO: 2. Change this to Routes
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/garden': (context) => GardenScreen(),
        '/info': (context) => const InfoScreen(),
        '/user': (context) => const UserScreen(),
        '/edit_user': (context) => const EditUserScreen(),

        // not needed now
        // '/home2': (context) => MyHomePage(title: "Arnima"),
        // '/add': (context) => AddScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Wait 3 seconds then go to login screen
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF20854F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            const Text(
              'Arnima',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// not needed now
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// // TODO: 3. The Widget Structure
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//         centerTitle: true,
//       ),
//       body: const IdeaStream(), // replace the place holder with Idea Stream
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, '/add');
//         },
//         tooltip: 'Add Idea',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
