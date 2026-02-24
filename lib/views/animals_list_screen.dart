import 'package:flutter/material.dart';
import 'package:veto_app/models/animal_model.dart';
import 'animal_registration_screen.dart';
import 'dossier_medical_screen.dart';
import 'prescription_screen.dart';

class AnimalsListScreen extends StatefulWidget {
  final int idProprietaire;
  final String proprietaireName;

  const AnimalsListScreen({
    super.key,
    required this.idProprietaire,
    required this.proprietaireName,
  });

  @override
  State<AnimalsListScreen> createState() => _AnimalsListScreenState();
}

class _AnimalsListScreenState extends State<AnimalsListScreen> {
  List<AnimalModel> _animals = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    // À implémenter: appel API pour récupérer les animaux
    setState(() => _isLoading = true);
    try {
      // var response = await ApiService.get('/animal/proprietaire/${widget.idProprietaire}');
      // if (response is List) {
      //   _animals = (response as List).map((a) => AnimalModel.fromJson(a)).toList();
      // }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _openAnimalRegistration() async {
    final result = await Navigator.push<AnimalModel>(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalRegistrationScreen(
          idProprietaire: widget.idProprietaire,
        ),
      ),
    );
    if (result != null) {
      setState(() => _animals.add(result));
    }
  }

  void _openConsultation(AnimalModel animal, int idVeterinaire) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DossierMedicalScreen(
          idAnimal: animal.idAnimal ?? 0,
          idVeterinaire: idVeterinaire,
          nomAnimal: animal.nom,
        ),
      ),
    );
    if (result != null) {
      _showPrescriptionOptions(animal);
    }
  }

  void _showPrescriptionOptions(AnimalModel animal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une prescription ?'),
        content: Text('Voulez-vous ajouter une prescription pour ${animal.nom} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // À adapter avec l'ID de consultation réel
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrescriptionScreen(
                    idConsultation: 0, // À remplacer par l'ID réel
                    nomAnimal: animal.nom,
                  ),
                ),
              );
            },
            child: const Text('Oui'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes animaux - ${widget.proprietaireName}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _animals.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.pets, size: 100, color: Colors.grey),
                      const SizedBox(height: 20),
                      const Text('Aucun animal enregistré'),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _openAnimalRegistration,
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter mon premier animal'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: _animals.length,
                  itemBuilder: (context, index) {
                    final animal = _animals[index];
                    return Card(
                      child: ExpansionTile(
                        leading: const Icon(Icons.pets, color: Colors.blueAccent),
                        title: Text(animal.nom),
                        subtitle: Text('${animal.espece} - ${animal.race}'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('Sexe', animal.sexe),
                                _buildDetailRow('Poids', '${animal.poids} kg'),
                                _buildDetailRow('Couleur', animal.couleur),
                                _buildDetailRow(
                                  'Date de naissance',
                                  '${animal.dateNaissance.day}/${animal.dateNaissance.month}/${animal.dateNaissance.year}',
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => _openConsultation(animal, 0),
                                      icon: const Icon(Icons.medical_services),
                                      label: const Text('Consultation'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PrescriptionScreen(
                                            idConsultation: 0,
                                            nomAnimal: animal.nom,
                                          ),
                                        ),
                                      ),
                                      icon: const Icon(Icons.medication),
                                      label: const Text('Prescription'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orangeAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAnimalRegistration,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }
}
