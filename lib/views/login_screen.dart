import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  // AJOUT : On déclare la variable role pour que le Navigator puisse lui envoyer l'info
  final String role;

  // AJOUT : On l'ajoute au constructeur (required)
  const LoginScreen({super.key, required this.role});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // On affiche dynamiquement le rôle dans le titre
        title: Text("Connexion Clinique (${widget.role})"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Mot de passe", border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;

                // IMPORTANT : Si tu es sur émulatateur Android, localhost ne marche pas, utilise 10.0.2.2
                final url = Uri.parse("http://localhost:8081/api/auth/login?email=$email&password=$password");

                try {
                  final response = await http.post(url);

                  if (response.statusCode == 200) {
                    var userData = json.decode(response.body);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen(user: userData)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Email ou mot de passe incorrect"), backgroundColor: Colors.red),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Erreur de connexion au serveur"), backgroundColor: Colors.orange),
                  );
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text("Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}