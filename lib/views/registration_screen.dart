import 'package:flutter/material.dart';
import '../widget/custom_registration_form.dart';

class RegisterOwnerPage extends StatefulWidget {// 1. Déclare la variable role
  final String role;

  // 2. Ajoute-la au constructeur (obligatoire pour enlever l'erreur rouge)
  const RegisterOwnerPage({super.key, required this.role});

  @override
  State<RegisterOwnerPage> createState() => _RegisterOwnerPageState();
}

class _RegisterOwnerPageState extends State<RegisterOwnerPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();

  void handleRegistration() {
    // Ici, widget.role contiendra 'proprietaire'
    print("Inscription en cours pour le rôle : ${widget.role}");
  }

  @override
  Widget build(BuildContext context) {
    return CustomRegistrationForm(title: "Inscription ${widget.role}",
      emailController: email,
      passwordController: password,
      firstNameController: firstName,
      lastNameController: lastName,
      onRegister: handleRegistration,
    );
  }
}