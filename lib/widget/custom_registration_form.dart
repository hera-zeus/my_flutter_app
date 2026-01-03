import 'package:flutter/material.dart';

class CustomRegistrationForm extends StatelessWidget {
  final String title;
  final List<Widget> extraFields;
  final VoidCallback onRegister;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const CustomRegistrationForm({
    super.key,
    required this.title,
    required this.onRegister,
    required this.emailController,
    required this.passwordController,
    required this.firstNameController,
    required this.lastNameController,
    this.extraFields = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.pinkAccent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.person_add, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            _buildTextField(firstNameController, "Prénom", Icons.person),
            _buildTextField(lastNameController, "Nom", Icons.family_restroom),
            _buildTextField(emailController, "Email", Icons.email),
            _buildTextField(passwordController, "Mot de passe", Icons.lock, isObscure: true),

            // Insertion des champs spécifiques (ex: Adresse pour proprio, Spécialité pour véto)
            ...extraFields,

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: onRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("S'inscrire", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isObscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}