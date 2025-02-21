import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/HomePage.dart';
import 'screens/home_screen.dart';
import 'screens/location_screen.dart';
import 'screens/login_page.dart';
import 'screens/profile_screen.dart';
import 'screens/page-inscription.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DZTrain',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue.shade200),
      ),
      home: AuthWrapper(), // 🔥 Vérification de l'utilisateur connecté
    );
  }
}

// 🔥 Vérifie si l'utilisateur est connecté et redirige
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator())); // Chargement
        }
        if (snapshot.hasData) {
          return HomePage(); // ✅ L'utilisateur est connecté, on l'envoie à HomePage
        }
        return SplashScreen(); // ❌ L'utilisateur doit se connecter
      },
    );
  }
}
