class PrescriptionModel {
  final int? idPrescription;
  final int idConsultation;
  final String description;
  final DateTime dateCreation;
  final bool unavailable;

  PrescriptionModel({
    this.idPrescription,
    required this.idConsultation,
    required this.description,
    required this.dateCreation,
    this.unavailable = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_prescription': idPrescription,
      'id_consultation': idConsultation,
      'description': description,
      'date_creation': dateCreation.toIso8601String(),
      'unavailable': unavailable,
    };
  }

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      idPrescription: json['id_prescription'],
      idConsultation: json['id_consultation'] ?? 0,
      description: json['description'] ?? '',
      dateCreation: json['date_creation'] != null 
          ? DateTime.parse(json['date_creation'])
          : DateTime.now(),
      unavailable: json['unavailable'] ?? false,
    );
  }
}
