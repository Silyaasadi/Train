import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Contrôleurs pour les champs
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emploiController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // 🔹 Fonction pour l'inscription Firebase
  Future<void> _registerUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "nom": nomController.text.trim(),
        "prenom": prenomController.text.trim(),
        "age": ageController.text.trim(),
        "emploi": emploiController.text.trim(),
        "email": emailController.text.trim(),
        "createdAt": DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Compte créé avec succès !")),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${e.toString()}")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    ageController.dispose();
    emploiController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un compte")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/image-background1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Bienvenue ! Remplissez vos informations.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),

                  // 🔹 Ligne pour Prénom et Nom
                  Row(
                    children: [
                      Expanded(child: _buildTextField(prenomController, "Prénom")),
                      SizedBox(width: 16),
                      Expanded(child: _buildTextField(nomController, "Nom")),
                    ],
                  ),

                  _buildTextField(emailController, "Adresse e-mail"),
                  _buildTextField(ageController, "Âge", isNumeric: true),
                  _buildTextField(emploiController, "Emploi"),
                  _buildPasswordField(passwordController, "Mot de passe"),
                  _buildPasswordField(confirmPasswordController, "Confirmer le mot de passe", isConfirmPassword: true),

                  SizedBox(height: 30),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () => _registerUser(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 120.0, vertical: 12.0),
                    ),
                    child: Text("Créer un compte"),
                  ),

                  SizedBox(height: 20),
                  Text("Ou inscrivez-vous avec", style: TextStyle(fontSize: 16, color: Colors.black87)),
                  SizedBox(height: 15),

                  // 🔹 Boutons Google et Facebook
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(FontAwesomeIcons.google, Colors.red, () {
                        // TODO: Ajouter la connexion avec Google
                      }),
                      SizedBox(width: 20),
                      _buildSocialButton(FontAwesomeIcons.facebook, Colors.blue, () {
                        // TODO: Ajouter la connexion avec Facebook
                      }),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Text("Ou connectez-vous avec", style: TextStyle(fontSize: 16, color: Colors.black87)),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(FontAwesomeIcons.google, Colors.red, () {
                            print("Connexion avec Google");
                          }),
                          SizedBox(width: 20),
                          _buildSocialButton(FontAwesomeIcons.facebook, Colors.blue, () {
                            print("Connexion avec Facebook");
                          }),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Retour à la page de connexion
                    },
                    child: Text(
                      "Vous avez déjà un compte ? Connectez-vous",
                      style: TextStyle(color: Colors.indigo, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Widget pour les champs de texte
  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Veuillez entrer votre $label";
          }
          return null;
        },
      ),
    );
  }

  // 🔹 Widget pour les champs de mot de passe avec visibilité
  Widget _buildPasswordField(TextEditingController controller, String label, {bool isConfirmPassword = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Veuillez entrer votre $label";
          }
          if (isConfirmPassword && value != passwordController.text) {
            return "Les mots de passe ne correspondent pas";
          }
          return null;
        },
      ),
    );
  }

  // 🔹 Widget pour les boutons de connexion Google & Facebook
  // 🔹 Widget pour les boutons de connexion Google & Facebook
  Widget _buildSocialButton(IconData icon, Color color, VoidCallback onTap) {
    return Container(
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
        icon: FaIcon(icon, color: color),
        iconSize: 30,
        onPressed: onTap,
      ),
    );
  }

}
