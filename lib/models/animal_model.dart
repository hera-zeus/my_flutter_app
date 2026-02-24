class AnimalModel {
  final int? idAnimal;
  final int idProprietaire;
  final String nom;
  final String espece;
  final String race;
  final DateTime dateNaissance;
  final double poids;
  final String sexe;
  final String couleur;
  final DateTime? dateCreation;

  AnimalModel({
    this.idAnimal,
    required this.idProprietaire,
    required this.nom,
    required this.espece,
    required this.race,
    required this.dateNaissance,
    required this.poids,
    required this.sexe,
    required this.couleur,
    this.dateCreation,
  });

  // Convertir en JSON pour l'API
  Map<String, dynamic> toJson() {
    return {
      'id_animal': idAnimal,
      'id_proprietaire': idProprietaire,
      'ghimat_name': nom,
      'ghimat_especie': espece,
      'animal_race': race,
      'animal_birthday': dateNaissance.toIso8601String(),
      'weight_stat': poids,
      'sex': sexe,
      'color': couleur,
    };
  }

  // Créer depuis JSON
  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      idAnimal: json['id_animal'],
      idProprietaire: json['id_proprietaire'] ?? 0,
      nom: json['ghimat_name'] ?? '',
      espece: json['ghimat_especie'] ?? '',
      race: json['animal_race'] ?? '',
      dateNaissance: json['animal_birthday'] != null 
          ? DateTime.parse(json['animal_birthday'])
          : DateTime.now(),
      poids: (json['weight_stat'] ?? 0).toDouble(),
      sexe: json['sex'] ?? '',
      couleur: json['color'] ?? '',
      dateCreation: json['date_creation'] != null 
          ? DateTime.parse(json['date_creation'])
          : null,
    );
  }
}
