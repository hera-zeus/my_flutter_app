import 'package:flutter/material.dart';
import 'package:veto_app/services/api_service.dart';
import 'package:veto_app/models/animal_model.dart';

class AnimalRegistrationScreen extends StatefulWidget {
  final int idProprietaire;
  const AnimalRegistrationScreen({super.key, required this.idProprietaire});

  @override
  State<AnimalRegistrationScreen> createState() => _AnimalRegistrationScreenState();
}

class _AnimalRegistrationScreenState extends State<AnimalRegistrationScreen> {
  final _nomController = TextEditingController();
  final _especeController = TextEditingController();
  final _raceController = TextEditingController();
  final _poidsController = TextEditingController();
  final _couleurController = TextEditingController();
  
  DateTime? _dateNaissance;
  String? _sexeSelectionne;
  bool _isLoading = false;
  
  String? _nomError;
  String? _especeError;
  String? _raceError;
  String? _dateError;
  String? _poidsError;
  String? _sexeError;

  final List<String> _sexes = ['Mâle', 'Femelle'];

  @override
  void dispose() {
    _nomController.dispose();
    _especeController.dispose();
    _raceController.dispose();
    _poidsController.dispose();
    _couleurController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateNaissance) {
      setState(() {
        _dateNaissance = picked;
        _dateError = null;
      });
    }
  }

  void _validateAndRegisterAnimal() async {
    // Réinitialiser les erreurs
    setState(() {
      _nomError = null;
      _especeError = null;
      _raceError = null;
      _dateError = null;
      _poidsError = null;
      _sexeError = null;
    });

    // Validation
    bool hasError = false;

    if (_nomController.text.isEmpty) {
      setState(() => _nomError = 'Le nom de l\'animal est requis');
      hasError = true;
    }
    if (_especeController.text.isEmpty) {
      setState(() => _especeError = 'L\'espèce est requise');
      hasError = true;
    }
    if (_raceController.text.isEmpty) {
      setState(() => _raceError = 'La race est requise');
      hasError = true;
    }
    if (_dateNaissance == null) {
      setState(() => _dateError = 'La date de naissance est requise');
      hasError = true;
    }
    if (_poidsController.text.isEmpty) {
      setState(() => _poidsError = 'Le poids est requis');
      hasError = true;
    } else {
      try {
        double.parse(_poidsController.text);
      } catch (e) {
        setState(() => _poidsError = 'Poids invalide (nombre décimal)');
        hasError = true;
      }
    }
    if (_sexeSelectionne == null) {
      setState(() => _sexeError = 'Le sexe est requis');
      hasError = true;
    }

    if (hasError) return;

    setState(() => _isLoading = true);

    try {
      final animal = AnimalModel(
        idProprietaire: widget.idProprietaire,
        nom: _nomController.text.trim(),
        espece: _especeController.text.trim(),
        race: _raceController.text.trim(),
        dateNaissance: _dateNaissance!,
        poids: double.parse(_poidsController.text),
        sexe: _sexeSelectionne!,
        couleur: _couleurController.text.trim(),
      );

      // Appel API - adapter l'endpoint selon votre backend
      var response = await ApiService.post(
        '/animal/create',
        animal.toJson(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Animal enregistré avec succès !'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, animal);
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
        title: const Text('Enregistrer un Animal'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.pets, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 30),
            
            // Nom
            TextField(
              controller: _nomController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Nom de l\'animal',
                prefixIcon: const Icon(Icons.pets),
                border: const OutlineInputBorder(),
                errorText: _nomError,
              ),
            ),
            const SizedBox(height: 15),

            // Espèce
            TextField(
              controller: _especeController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Espèce (ex: Chien, Chat, Oiseau)',
                prefixIcon: const Icon(Icons.category),
                border: const OutlineInputBorder(),
                errorText: _especeError,
              ),
            ),
            const SizedBox(height: 15),

            // Race
            TextField(
              controller: _raceController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Race',
                prefixIcon: const Icon(Icons.info),
                border: const OutlineInputBorder(),
                errorText: _raceError,
              ),
            ),
            const SizedBox(height: 15),

            // Date de naissance
            GestureDetector(
              onTap: _isLoading ? null : () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: _dateError != null ? Colors.red : Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.blueAccent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _dateNaissance != null
                            ? '${_dateNaissance!.day}/${_dateNaissance!.month}/${_dateNaissance!.year}'
                            : 'Date de naissance',
                        style: TextStyle(
                          color: _dateNaissance == null ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_dateError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(_dateError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ),
            const SizedBox(height: 15),

            // Poids
            TextField(
              controller: _poidsController,
              enabled: !_isLoading,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Poids (kg)',
                prefixIcon: const Icon(Icons.scale),
                border: const OutlineInputBorder(),
                errorText: _poidsError,
              ),
            ),
            const SizedBox(height: 15),

            // Sexe
            DropdownButtonFormField<String>(
              value: _sexeSelectionne,
              onChanged: _isLoading ? null : (newValue) {
                setState(() {
                  _sexeSelectionne = newValue;
                  _sexeError = null;
                });
              },
              decoration: InputDecoration(
                labelText: 'Sexe',
                prefixIcon: const Icon(Icons.wc),
                border: const OutlineInputBorder(),
                errorText: _sexeError,
              ),
              items: _sexes.map((sexe) {
                return DropdownMenuItem(value: sexe, child: Text(sexe));
              }).toList(),
            ),
            const SizedBox(height: 15),

            // Couleur
            TextField(
              controller: _couleurController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Couleur (optionnel)',
                prefixIcon: Icon(Icons.palette),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Bouton d'enregistrement
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _validateAndRegisterAnimal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
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
                        'Enregistrer l\'animal',
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
