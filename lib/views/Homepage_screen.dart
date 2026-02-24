import 'package:flutter/material.dart';
import 'package:veto_app/views/login_screen.dart';
import 'package:veto_app/views/registration_screen.dart'; // Vérifie bien que le nom du fichier est correct

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterOwnerPage(role: 'proprietaire'),
              ),
            ),
            child: const Text(
              "Je m'inscris",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section Bannière
            Stack(
              children: [
                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://votre-url-vache.com/image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.withOpacity(0.8), Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bienvenue sur le site de l'Ordre national\ndes vétérinaires",
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFC2185B),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        onPressed: () {},
                        child: const Text("J'accède à mes données ordinales..."),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                "L'Ordre est le garant de la qualité du service rendu au public par les vétérinaires en exercice",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ),

            // Section des cartes corrigée
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildOptionCard(
                    context,
                    Icons.people_outline,
                    "Je suis\nvétérinaire/élu",
                    false,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen(role: 'veterinaire')),
                    ),
                  ),
                  _buildOptionCard(
                    context,
                    Icons.pets,
                    "Je suis\npropriétaire d'animaux",
                    true,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterOwnerPage(role: 'proprietaire')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Widget réutilisable corrigé avec les nouveaux paramètres
  Widget _buildOptionCard(
      BuildContext context,
      IconData icon,
      String title,
      bool isSelected,
      VoidCallback onTap, // Ajout du callback de clic
      ) {
    return GestureDetector(
      onTap: onTap, // Déclenche le Navigator
      child: Container(
        width: 200,
        height: 180,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF009688) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
          ],
          border: isSelected ? null : Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: isSelected ? Colors.white : const Color(0xFF009688)),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}