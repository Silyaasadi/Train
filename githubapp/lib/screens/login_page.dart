
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:githubapp/screens/page-inscription.dart';

import 'package:githubapp/screens/ForgotPasswordScreen.dart';

import 'HomePage.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false; // État pour la visibilité du mot de passe

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/image-backround.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 70.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Nom d'utilisateur",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    icon: Icon(Icons.person, color: Colors.indigo),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Mot de passe",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    icon: Icon(Icons.lock, color: Colors.indigo),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.indigo,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Naviguer vers la page de réinitialisation du mot de passe
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()), // Naviguer vers ForgotPasswordScreen
                      );
                    },
                    child: Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 120.0, vertical: 12.0),
                ),
                child: Text(
                  'Se connecter',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 9.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Se connecter avec'),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Bouton Facebook en cercle
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.facebook, color: Colors.indigo),
                      iconSize: 30, // Ajustez la taille de l'icône
                      onPressed: () {
                        // Action pour Facebook
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  // Bouton Google en cercle
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: FaIcon(FontAwesomeIcons.google, color: Colors.indigo),
                      iconSize: 30, // Ajustez la taille ici aussi
                      onPressed: () {
                        // Action pour Google
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  "Vous n'avez pas de compte ? Inscrivez-vous  ",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}