import 'package:flutter/material.dart';

import 'Homepage_screen.dart';

class HomeScreen extends StatelessWidget {
  // Cette variable va recevoir les données de l'utilisateur envoyées par le backend
  final Map<String, dynamic> user;

  // Le constructeur demande obligatoirement l'utilisateur
  HomeScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Espace Santé Vétérinaire"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Bienvenue !",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // On affiche l'email qui vient du JSON de ton Backend Java
            Text("Connecté en tant que : ${user['email']}"),
            SizedBox(height: 5),
            // On affiche le rôle (VETERINAIRE ou PROPRIETAIRE)
            Chip(
              label: Text(user['role'] ?? "Utilisateur"),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                ); // Retour à la page de connexion
              },
              child: Text("Se déconnecter"),
            ),
          ],
        ),
      ),
    );
  }
}