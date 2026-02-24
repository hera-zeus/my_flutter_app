import 'package:flutter/material.dart';
import 'Homepage_screen.dart';

class HomeScreen extends StatelessWidget {
  // Cette variable va recevoir les données de l'utilisateur envoyées par le backend
  final Map<String, dynamic>? user;

  // Le constructeur peut prendre les données de l'utilisateur
  const HomeScreen({this.user, super.key});

  @override
  Widget build(BuildContext context) {
    // Récupérer les données depuis les arguments si elles ne sont pas passées directement
    final userData = user ?? (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?);

    if (userData == null) {
      // Si pas de données, retour à l'accueil
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Espace Santé Vétérinaire"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              "Bienvenue !",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Connecté en tant que : ${userData['email'] ?? 'Utilisateur'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Chip(
              label: Text(userData['role'] ?? "Utilisateur"),
              backgroundColor: Colors.blue[100],
              labelStyle: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Se déconnecter"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}