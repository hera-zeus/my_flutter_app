class DossierMedicalModel {
  final int? idConsultation;
  final int idAnimal;
  final int idVeterinaire;
  final DateTime dateConsultation;
  final String diagnostic;
  final String? recommended;
  final DateTime? dateProchainRDV;

  DossierMedicalModel({
    this.idConsultation,
    required this.idAnimal,
    required this.idVeterinaire,
    required this.dateConsultation,
    required this.diagnostic,
    this.recommended,
    this.dateProchainRDV,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_consultation': idConsultation,
      'id_animal': idAnimal,
      'id_veterinaire': idVeterinaire,
      'date_consultation': dateConsultation.toIso8601String(),
      'diagnostic': diagnostic,
      'recommended': recommended,
      'date_prochain_rdv': dateProchainRDV?.toIso8601String(),
    };
  }

  factory DossierMedicalModel.fromJson(Map<String, dynamic> json) {
    return DossierMedicalModel(
      idConsultation: json['id_consultation'],
      idAnimal: json['id_animal'] ?? 0,
      idVeterinaire: json['id_veterinaire'] ?? 0,
      dateConsultation: json['date_consultation'] != null 
          ? DateTime.parse(json['date_consultation'])
          : DateTime.now(),
      diagnostic: json['diagnostic'] ?? '',
      recommended: json['recommended'],
      dateProchainRDV: json['date_prochain_rdv'] != null 
          ? DateTime.parse(json['date_prochain_rdv'])
          : null,
    );
  }
}
