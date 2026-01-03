import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion Clinique Vétérinaire")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Mot de passe", border: OutlineInputBorder()),
              obscureText: true, // Cache le mot de passe
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                print("POINT 1: Bouton cliqué");
                // 1. Récupérer le texte saisi par l'utilisateur
                String email = _emailController.text;
                String password = _passwordController.text;

                // 2. Préparer l'URL (10.0.2.2 est l'adresse pour pointer vers ton PC depuis l'émulateur)
                // On utilise les paramètres tels que définis dans ton UtilisateurController Java
                final url = Uri.parse("http://localhost:8081/api/auth/login?email=$email&password=$password");
                try {
                  print("POINT 2: Envoi de la requête à $url");
                  // 3. Envoyer la requête POST
                  final response = await http.post(url);
                  print("POINT 3: Réponse reçue avec code ${response.statusCode}");

                  if (response.statusCode == 200) {
                    // Succès ! On décode l'utilisateur
                    var userData = json.decode(response.body);

                    // 4. Aller vers l'écran d'accueil
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen(user: userData)),
                    );
                  } else {
                    // Erreur (401 ou 404) : on affiche un message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Email ou mot de passe incorrect"), backgroundColor: Colors.red),
                    );
                  }
                } catch (e) {
                  print("ERREUR CAPTURÉE: $e");
                  // Erreur réseau (serveur éteint, mauvaise IP, etc.)
                  print("Erreur : $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erreur de connexion au serveur"), backgroundColor: Colors.orange),
                  );
                }
                },
              child: Text("Se connecter"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}