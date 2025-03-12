import 'package:flutter/material.dart';
import 'package:dztrainfay/CreatePasswordScreen.dart';
import 'package:dztrainfay/ForgotPasswordScreen.dart';
import 'package:dztrainfay/PasswordChangedScreen.dart';
import 'package:dztrainfay/SignInScreen.dart';
import 'package:dztrainfay/SignUpScreen.dart';
import 'package:dztrainfay/VerifyEmailScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth App',
           theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SignInScreen(),
        '/signup': (context) => RegisterPage(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/verify-email': (context) => VerifyEmailScreen(verificationCode: 0, email: ''), // Valeurs par défaut, mais ce ne sera pas utilisé
        '/create-password': (context) => CreatePasswordScreen(),
        '/password-changed': (context) => PasswordChangedScreen(),
      },
    );

  }

}