
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Déclaration des contrôleurs
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emploiController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // 🔹 Fonction pour l'inscription
  Future<void> _registerUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // 🔥 Création de l'utilisateur avec Firebase Auth
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // 🔥 Sauvegarde des infos utilisateur dans Firestore
        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          "nom": nomController.text.trim(),
          "prenom": prenomController.text.trim(),
          "age": ageController.text.trim(),
          "emploi": emploiController.text.trim(),
          "email": emailController.text.trim(),
          "createdAt": DateTime.now(),
        });

        // 🔹 Message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Compte créé avec succès !")),
        );

        // 🔹 Redirection vers la page d'accueil après inscription
        Navigator.pushReplacementNamed(context, '/home');

      } catch (e) {
        // ❌ Gestion des erreurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un compte")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(nomController, "Nom"),
                _buildTextField(prenomController, "Prénom"),
                _buildTextField(ageController, "Âge", isNumeric: true),
                _buildTextField(emailController, "Email"),
                _buildTextField(passwordController, "Mot de passe", isPassword: true),
                _buildTextField(confirmPasswordController, "Confirmer le mot de passe", isPassword: true, isConfirmPassword: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _registerUser(context),
                  child: Text("Créer un compte"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Widget pour les champs de texte
  Widget _buildTextField(TextEditingController controller, String label, {bool isPassword = false, bool isConfirmPassword = false, bool isNumeric = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
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


}
