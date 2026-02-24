import 'package:flutter/material.dart';
import 'package:veto_app/services/api_service.dart';
import 'package:veto_app/models/dossier_medical_model.dart';

class DossierMedicalScreen extends StatefulWidget {
  final int idAnimal;
  final int idVeterinaire;
  final String nomAnimal;
  
  const DossierMedicalScreen({
    super.key,
    required this.idAnimal,
    required this.idVeterinaire,
    required this.nomAnimal,
  });

  @override
  State<DossierMedicalScreen> createState() => _DossierMedicalScreenState();
}

class _DossierMedicalScreenState extends State<DossierMedicalScreen> {
  final _diagnosticController = TextEditingController();
  final _recommendedController = TextEditingController();
  
  DateTime _dateConsultation = DateTime.now();
  DateTime? _dateProchainRDV;
  bool _isLoading = false;
  
  String? _diagnosticError;
  String? _dateError;

  @override
  void dispose() {
    _diagnosticController.dispose();
    _recommendedController.dispose();
    super.dispose();
  }

  Future<void> _selectDateConsultation(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateConsultation,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dateConsultation = picked);
    }
  }

  Future<void> _selectDateProchainRDV(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateProchainRDV ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _dateProchainRDV = picked);
    }
  }

  void _validateAndSaveDossier() async {
    setState(() {
      _diagnosticError = null;
      _dateError = null;
    });

    bool hasError = false;

    if (_diagnosticController.text.isEmpty) {
      setState(() => _diagnosticError = 'Le diagnostic est requis');
      hasError = true;
    }

    if (hasError) return;

    setState(() => _isLoading = true);

    try {
      final dossier = DossierMedicalModel(
        idAnimal: widget.idAnimal,
        idVeterinaire: widget.idVeterinaire,
        dateConsultation: _dateConsultation,
        diagnostic: _diagnosticController.text.trim(),
        recommended: _recommendedController.text.trim().isEmpty 
            ? null 
            : _recommendedController.text.trim(),
        dateProchainRDV: _dateProchainRDV,
      );

      // Appel API - adapter l'endpoint selon votre backend
      var response = await ApiService.post(
        '/consultation/create',
        dossier.toJson(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dossier médical créé avec succès !'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, dossier);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une Consultation'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.medical_services, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            
            // Animal info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Animal concerné', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(
                      widget.nomAnimal,
                      style: const TextStyle(fontSize: 16, color: Colors.teal),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Date consultation
            const Text('Date de la consultation', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _isLoading ? null : () => _selectDateConsultation(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.teal),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${_dateConsultation.day}/${_dateConsultation.month}/${_dateConsultation.year}',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Diagnostic
            const Text('Diagnostic', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _diagnosticController,
              enabled: !_isLoading,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Décrivez le diagnostic',
                prefixIcon: const Icon(Icons.description),
                border: const OutlineInputBorder(),
                errorText: _diagnosticError,
              ),
            ),
            const SizedBox(height: 20),

            // Recommandations
            const Text('Recommandations (optionnel)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _recommendedController,
              enabled: !_isLoading,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Médicaments, soins recommandés, etc.',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Date prochain RDV
            const Text('Prochain rendez-vous (optionnel)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _isLoading ? null : () => _selectDateProchainRDV(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event, color: Colors.teal),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _dateProchainRDV != null
                            ? '${_dateProchainRDV!.day}/${_dateProchainRDV!.month}/${_dateProchainRDV!.year}'
                            : 'Pas de RDV planifié',
                        style: TextStyle(
                          color: _dateProchainRDV == null ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                    if (_dateProchainRDV != null)
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () => setState(() => _dateProchainRDV = null),
                        child: const Icon(Icons.clear, color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Bouton de sauvegarde
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _validateAndSaveDossier,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Créer la consultation',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
