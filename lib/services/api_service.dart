import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // ⚠️ IMPORTANT : Adapter l'URL selon votre environnement
  // Android Emulator: 10.0.2.2:8081
  // iOS Simulator: localhost:8081
  // Device réel: IP_SERVER:8081
  static const String baseUrl = 'http://localhost:8081/api';

  /// Connexion utilisateur
  /// Retourne un Map contenant les données utilisateur si succès
  /// Lance une exception si erreur
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login?email=$email&password=$password');
      
      final response = await http.post(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Délai d\'attente dépassé'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Email ou mot de passe incorrect');
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Inscription nouvel utilisateur
  /// Retourne un Map contenant les données utilisateur créé
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role, // 'PROPRIETAIRE' ou 'VETERINAIRE'
  }) async {
    try {
      final url = Uri.parse('$baseUrl/auth/register');

      final body = json.encode({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Délai d\'attente dépassé'),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 409) {
        throw Exception('Cet email est déjà utilisé');
      } else {
        throw Exception('Erreur lors de l\'inscription: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Validation basique d'un email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validation d'un mot de passe
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Le mot de passe ne peut pas être vide';
    }
    if (password.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  /// Validation d'un nom/prénom
  static String? validateName(String name) {
    if (name.isEmpty) {
      return 'Ce champ ne peut pas être vide';
    }
    if (name.length < 2) {
      return 'Doit contenir au moins 2 caractères';
    }
    return null;
  }

  /// Requête POST générique
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Délai d\'attente dépassé'),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 409) {
        throw Exception('Ressource déjà existante');
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Requête GET générique
  static Future<dynamic> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Délai d\'attente dépassé'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
