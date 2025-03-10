import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emploiController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un compte")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/image-backround1.png"),
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
                  const SizedBox(height: 70),
                  const Text(
                    "Bienvenue ! Remplissez vos informations.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _buildTextField(prenomController, "Prénom")),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField(nomController, "Nom")),
                    ],
                  ),
                  _buildTextField(emailController, "Adresse e-mail"),
                  _buildTextField(ageController, "Âge", isNumeric: true),
                  _buildTextField(emploiController, "Emploi"),
                  _buildTextField(usernameController, "Nom d'utilisateur"),
                  _buildTextField(passwordController, "Mot de passe", isPassword: true),
                  _buildTextField(
                      confirmPasswordController,
                      "Confirmer le mot de passe",
                      isPassword: true,
                      isConfirmPassword: true),
                  const SizedBox(height: 50),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .add({
                              'prenom': prenomController.text,
                              'nom': nomController.text,
                              'email': emailController.text,
                              'age': ageController.text,
                              'emploi': emploiController.text,
                              'username': usernameController.text,
                              'password': passwordController.text,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Compte créé avec succès!")),
                            );
                            // Optionnel : Effacer les champs après création ou naviguer vers une autre page
                          } catch (e) {
                            // Afficher l'erreur dans la console et via un SnackBar
                            print("Erreur lors de l'ajout dans Firestore : $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Erreur lors de la création du compte: $e")),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 120.0, vertical: 12.0),
                      ),
                      child: const Text("Créer un compte"),
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

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false,
        bool isConfirmPassword = false,
        bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType:
        isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
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
