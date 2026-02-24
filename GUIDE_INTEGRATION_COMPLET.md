# 🔧 Guide d'Intégration Complète

## Étape 1: Remplacer HomeScreen existant

Dans `lib/views/home_screen.dart`, remplacer le contenu par [home_screen_example.dart](lib/views/home_screen_example.dart)

Ou ajouter simplement ce code au HomeScreen existant:

```dart
// Ajouter cette ligne aux imports
import 'package:veto_app/views/animals_list_screen.dart';

// Ajouter ce bouton dans le body
if (userData != null && userData['role'] == 'PROPRIETAIRE')
  ElevatedButton.icon(
    onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalsListScreen(
          idProprietaire: userData['id'] ?? 0,
          proprietaireName: userData['firstName'] ?? 'Utilisateur',
        ),
      ),
    ),
    icon: const Icon(Icons.pets),
    label: const Text("Mes animaux"),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      minimumSize: const Size(double.infinity, 50),
    ),
  ),
```

---

## Étape 2: Vérifier les imports

Assurez-vous que tous les imports sont corrects dans [animals_list_screen.dart](lib/views/animals_list_screen.dart):

```dart
import 'package:flutter/material.dart';
import 'package:veto_app/models/animal_model.dart';
import 'animal_registration_screen.dart';
import 'dossier_medical_screen.dart';
import 'prescription_screen.dart';
```

---

## Étape 3: Backend - Créer les modèles Java

### AnimalDTO
```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AnimalDTO {
    private Integer id_animal;
    private Integer id_proprietaire;
    private String ghimat_name;
    private String ghimat_especie;
    private String animal_race;
    private LocalDate animal_birthday;
    private Double weight_stat;
    private String sex;
    private String color;
    private LocalDate date_creation;
}
```

### ConsultationDTO
```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ConsultationDTO {
    private Integer id_consultation;
    private Integer id_animal;
    private Integer id_veterinaire;
    private LocalDate date_consultation;
    private String diagnostic;
    private String recommended;
    private LocalDate date_prochain_rdv;
}
```

### PrescriptionDTO
```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PrescriptionDTO {
    private Integer id_prescription;
    private Integer id_consultation;
    private String description;
    private LocalDate date_creation;
    private Boolean unavailable;
}
```

---

## Étape 4: Backend - Créer les endpoints

### AnimalController
```java
@RestController
@RequestMapping("/api/animal")
public class AnimalController {

    @PostMapping("/create")
    public ResponseEntity<?> createAnimal(@RequestBody AnimalDTO animalDTO) {
        try {
            Animal animal = animalService.save(animalDTO);
            return ResponseEntity.status(201).body(animal);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur: " + e.getMessage());
        }
    }

    @GetMapping("/proprietaire/{id}")
    public ResponseEntity<?> getAnimalsByProprietaire(@PathVariable int id) {
        List<Animal> animals = animalService.findByProprietaireId(id);
        return ResponseEntity.ok(animals);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getAnimal(@PathVariable int id) {
        Animal animal = animalService.findById(id);
        if (animal != null) return ResponseEntity.ok(animal);
        return ResponseEntity.notFound().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateAnimal(@PathVariable int id, @RequestBody AnimalDTO animalDTO) {
        Animal animal = animalService.update(id, animalDTO);
        return ResponseEntity.ok(animal);
    }
}
```

### ConsultationController
```java
@RestController
@RequestMapping("/api/consultation")
public class ConsultationController {

    @PostMapping("/create")
    public ResponseEntity<?> createConsultation(@RequestBody ConsultationDTO consultationDTO) {
        try {
            Consultation consultation = consultationService.save(consultationDTO);
            return ResponseEntity.status(201).body(consultation);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur: " + e.getMessage());
        }
    }

    @GetMapping("/animal/{id}")
    public ResponseEntity<?> getConsultationsByAnimal(@PathVariable int id) {
        List<Consultation> consultations = consultationService.findByAnimalId(id);
        return ResponseEntity.ok(consultations);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getConsultation(@PathVariable int id) {
        Consultation consultation = consultationService.findById(id);
        if (consultation != null) return ResponseEntity.ok(consultation);
        return ResponseEntity.notFound().build();
    }
}
```

### PrescriptionController
```java
@RestController
@RequestMapping("/api/prescription")
public class PrescriptionController {

    @PostMapping("/create")
    public ResponseEntity<?> createPrescription(@RequestBody PrescriptionDTO prescriptionDTO) {
        try {
            Prescription prescription = prescriptionService.save(prescriptionDTO);
            return ResponseEntity.status(201).body(prescription);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur: " + e.getMessage());
        }
    }

    @GetMapping("/consultation/{id}")
    public ResponseEntity<?> getPrescriptionsByConsultation(@PathVariable int id) {
        List<Prescription> prescriptions = prescriptionService.findByConsultationId(id);
        return ResponseEntity.ok(prescriptions);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updatePrescription(@PathVariable int id, @RequestBody PrescriptionDTO prescriptionDTO) {
        Prescription prescription = prescriptionService.update(id, prescriptionDTO);
        return ResponseEntity.ok(prescription);
    }
}
```

---

## Étape 5: Tester chaque écran

### Test AnimalRegistrationScreen
```dart
// Dans main.dart, temporairement:
home: AnimalRegistrationScreen(idProprietaire: 1),
```

Vérifier:
- ✅ Tous les champs affichent correctement
- ✅ Date picker fonctionne
- ✅ Dropdown sexe fonctionne
- ✅ Validation marche
- ✅ Message succès affiche
- ✅ Retour au parent avec résultat

### Test DossierMedicalScreen
```dart
home: DossierMedicalScreen(
  idAnimal: 1,
  idVeterinaire: 1,
  nomAnimal: "Rex",
),
```

Vérifier:
- ✅ Card animal affiche bien
- ✅ Date pickers fonctionnent
- ✅ Diagnostic requis
- ✅ Recommandations optionnel
- ✅ RDV optionnel avec suppression

### Test PrescriptionScreen
```dart
home: PrescriptionScreen(
  idConsultation: 1,
  nomAnimal: "Rex",
),
```

Vérifier:
- ✅ Ajout prescription fonctionne
- ✅ Liste affiche en temps réel
- ✅ Suppression fonctionne
- ✅ Validation avant sauvegarde
- ✅ Batch creation API

### Test AnimalsListScreen
```dart
home: AnimalsListScreen(
  idProprietaire: 1,
  proprietaireName: "Jean Dupont",
),
```

Vérifier:
- ✅ Liste affiche (ou message vide)
- ✅ ExpansionTile déploie détails
- ✅ Boutons consultation/prescription fonctionnent
- ✅ FAB ouvre AnimalRegistrationScreen
- ✅ Navigation retour OK

---

## Étape 6: Intégration complète

### 1. Adapter le flow HomeScreen

```dart
// lib/views/home_screen.dart
if (userData['role'] == 'PROPRIETAIRE') {
  ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnimalsListScreen(
            idProprietaire: userData['id'] ?? 0,
            proprietaireName: userData['firstName'] ?? 'Utilisateur',
          ),
        ),
      );
    },
    icon: const Icon(Icons.pets),
    label: const Text('Mes animaux'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      minimumSize: const Size(double.infinity, 50),
    ),
  ),
}
```

### 2. Mettre à jour main.dart si besoin

```dart
routes: {
  'home': (context) => const HomeScreen(),
  'animals': (context) => const AnimalsListScreen(
    idProprietaire: 0,
    proprietaireName: '',
  ),
},
```

### 3. Corriger les appels API réels

Dans `AnimalsListScreen._loadAnimals()`:
```dart
Future<void> _loadAnimals() async {
  setState(() => _isLoading = true);
  try {
    var response = await ApiService.get('/animal/proprietaire/${widget.idProprietaire}');
    if (response is List) {
      setState(() {
        _animals = (response as List)
            .map((a) => AnimalModel.fromJson(a as Map<String, dynamic>))
            .toList();
      });
    }
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
```

---

## Étape 7: Tester le flow complet

1. **Login** → HomeScreen
2. **Clic "Mes animaux"** → AnimalsListScreen
3. **Clic FAB** → AnimalRegistrationScreen
4. **Remplir et soumettre** → Retour à AnimalsListScreen avec nouvel animal
5. **Clic animal → déployer** → Voir détails
6. **Clic "Consultation"** → DossierMedicalScreen
7. **Remplir et soumettre** → Proposition "Ajouter prescription"?
8. **Oui** → PrescriptionScreen
9. **Ajouter prescriptions** → Soumettre
10. **Succès** → Retour à AnimalsListScreen

---

## Étape 8: Ajouter des améliorations

### Pull-to-Refresh dans AnimalsListScreen
```dart
body: RefreshIndicator(
  onRefresh: () => Future(() => _loadAnimals()),
  child: ListView.builder(...),
),
```

### Pagination sur liste animaux
```dart
// À implémenter selon nombre d'animaux
const int ANIMALS_PER_PAGE = 10;
```

### Recherche d'animal
```dart
// Dans AnimalsListScreen
TextField(
  onChanged: (value) {
    setState(() {
      _filteredAnimals = _animals
          .where((animal) => animal.nom.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  },
  decoration: const InputDecoration(
    hintText: 'Rechercher un animal...',
  ),
),
```

---

## Étape 9: Sécurité

### Ajouter JWT token
```dart
// Dans ApiService
static String? _token;

static void setToken(String token) => _token = token;

static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
  final headers = {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };
  // ...
}
```

### Valider permissions
```dart
// Dans AnimalRegistrationScreen
// Vérifier que idProprietaire = userData['id']
if (widget.idProprietaire != userData['id']) {
  throw Exception('Accès refusé');
}
```

---

## Étape 10: Déploiement

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web (optionnel)
```bash
flutter build web --release
```

---

## ✅ Checklist finale

- [ ] Tous les endpoints créés
- [ ] Tous les DTOs/modèles Java créés
- [ ] Chaque écran testé individuellement
- [ ] Flow complet testé
- [ ] Données persistées en DB vérifiées
- [ ] Gestion erreurs fonctionnelle
- [ ] JWT tokens implémentés
- [ ] Permissions vérifiées
- [ ] Pull-to-refresh fonctionne
- [ ] Messages utilisateur clairs
- [ ] App compilée en APK/IPA
- [ ] Tests device réel OK

---

Bon développement ! 🚀
