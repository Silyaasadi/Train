import 'package:flutter/material.dart';
import 'login_page.dart';
import ' ForgotPasswordScreen.dart';
import 'package:githubapp/screens/login_page.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background-.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/localisation.jpg", width: 200),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.lightBlue,
              ),
              child: Text("Suivant"),
            ),
          ),
        ],
      ),
    );
  }
}

