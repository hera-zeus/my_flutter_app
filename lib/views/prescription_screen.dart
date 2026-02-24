import 'package:flutter/material.dart';
import 'package:veto_app/services/api_service.dart';
import 'package:veto_app/models/prescription_model.dart';

class PrescriptionScreen extends StatefulWidget {
  final int idConsultation;
  final String nomAnimal;
  
  const PrescriptionScreen({
    super.key,
    required this.idConsultation,
    required this.nomAnimal,
  });

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  String? _descriptionError;
  List<String> _prescriptions = [];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _addPrescription() {
    setState(() {
      _descriptionError = null;
    });

    if (_descriptionController.text.isEmpty) {
      setState(() => _descriptionError = 'Veuillez entrer une prescription');
      return;
    }

    setState(() {
      _prescriptions.add(_descriptionController.text.trim());
      _descriptionController.clear();
    });
  }

  void _removePrescription(int index) {
    setState(() {
      _prescriptions.removeAt(index);
    });
  }

  void _validateAndSavePrescriptions() async {
    if (_prescriptions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez ajouter au moins une prescription'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Créer les prescriptions une par une
      for (String description in _prescriptions) {
        final prescription = PrescriptionModel(
          idConsultation: widget.idConsultation,
          description: description,
          dateCreation: DateTime.now(),
        );

        await ApiService.post(
          '/prescription/create',
          prescription.toJson(),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prescriptions créées avec succès !'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, _prescriptions);
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
        title: const Text('Ajouter des Prescriptions'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.medication, size: 80, color: Colors.orangeAccent),
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
                      style: const TextStyle(fontSize: 16, color: Colors.orangeAccent),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Formulaire ajout prescription
            const Text('Ajouter une prescription', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            
            TextField(
              controller: _descriptionController,
              enabled: !_isLoading,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ex: Amoxicilline 500mg, 3 fois par jour pendant 7 jours',
                prefixIcon: const Icon(Icons.medication),
                border: const OutlineInputBorder(),
                errorText: _descriptionError,
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _addPrescription,
                icon: const Icon(Icons.add),
                label: const Text('Ajouter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  disabledBackgroundColor: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Liste des prescriptions
            if (_prescriptions.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prescriptions (${_prescriptions.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _prescriptions.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.check_circle, color: Colors.green),
                          title: Text(_prescriptions[index]),
                          trailing: GestureDetector(
                            onTap: _isLoading ? null : () => _removePrescription(index),
                            child: Icon(
                              Icons.delete,
                              color: _isLoading ? Colors.grey : Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'Aucune prescription ajoutée',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),

            // Bouton sauvegarde
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _validateAndSavePrescriptions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
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
                        'Enregistrer les prescriptions',
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
