class UtilisateurModel {
  final int id;
  final String email;
  final String role; // PROPRIETAIRE ou VETERINAIRE

  UtilisateurModel({required this.id, required this.email, required this.role});

  // Transforme le JSON du Backend en objet Dart
  factory UtilisateurModel.fromJson(Map<String, dynamic> json) {
    return UtilisateurModel(
      id: json['id'],
      email: json['email'],
      role: json['role'] ?? 'USER',
    );
  }
}