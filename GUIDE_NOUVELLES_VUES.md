# 🏥 Guide des Nouvelles Vues - Gestion Clinique Vétérinaire

## 📁 Fichiers Créés

### Models
- ✅ **[animal_model.dart](lib/models/animal_model.dart)** - Modèle Animal
- ✅ **[prescription_model.dart](lib/models/prescription_model.dart)** - Modèle Prescription
- ✅ **[dossier_medical_model.dart](lib/models/dossier_medical_model.dart)** - Modèle Consultation/Dossier Médical

### Views (Écrans)
- ✅ **[animal_registration_screen.dart](lib/views/animal_registration_screen.dart)** - Enregistrement animal
- ✅ **[dossier_medical_screen.dart](lib/views/dossier_medical_screen.dart)** - Créer consultation
- ✅ **[prescription_screen.dart](lib/views/prescription_screen.dart)** - Ajouter prescriptions
- ✅ **[animals_list_screen.dart](lib/views/animals_list_screen.dart)** - Liste des animaux + actions

### Services
- ✅ **[api_service.dart](lib/services/api_service.dart)** - Méthodes POST/GET génériques ajoutées

---

## 🎯 Flow d'Utilisation

### Scénario Propriétaire

```
HomePage
  ↓
LoginScreen (login)
  ↓
HomeScreen (accueil)
  ↓
AnimalsListScreen (mes animaux)
  ├── Voir liste des animaux
  ├── Ajouter un animal
  │   └── AnimalRegistrationScreen
  ├── Créer consultation (dossier médical)
  │   └── DossierMedicalScreen
  └── Ajouter prescription
      └── PrescriptionScreen
```

---

## 📝 Guide d'Intégration

### 1. Ajouter un bouton "Mes animaux" dans HomeScreen

```dart
// Dans lib/views/home_screen.dart
ElevatedButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AnimalsListScreen(
        idProprietaire: userData['id'],
        proprietaireName: userData['firstName'],
      ),
    ),
  ),
  child: const Text('Mes animaux'),
),
```

### 2. Utiliser AnimalRegistrationScreen

```dart
final result = await Navigator.push<AnimalModel>(
  context,
  MaterialPageRoute(
    builder: (context) => AnimalRegistrationScreen(
      idProprietaire: userId,
    ),
  ),
);

if (result != null) {
  // Animal enregistré avec succès
  print('Animal créé: ${result.nom}');
}
```

### 3. Créer une consultation

```dart
final consultation = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DossierMedicalScreen(
      idAnimal: animal.idAnimal ?? 0,
      idVeterinaire: veterinaireid,
      nomAnimal: animal.nom,
    ),
  ),
);
```

### 4. Ajouter des prescriptions

```dart
final prescriptions = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PrescriptionScreen(
      idConsultation: consultationId,
      nomAnimal: animal.nom,
    ),
  ),
);
```

---

## 🔧 Configuration Backend

### Endpoints à implémenter (Java Spring Boot)

#### 1. Animal Controller
```java
@PostMapping("/api/animal/create")
public ResponseEntity<?> createAnimal(@RequestBody AnimalDTO animal)

@GetMapping("/api/animal/proprietaire/{id}")
public ResponseEntity<?> getAnimalsByProprietaire(@PathVariable int id)

@GetMapping("/api/animal/{id}")
public ResponseEntity<?> getAnimal(@PathVariable int id)

@PutMapping("/api/animal/{id}")
public ResponseEntity<?> updateAnimal(@PathVariable int id, @RequestBody AnimalDTO animal)
```

#### 2. Consultation Controller
```java
@PostMapping("/api/consultation/create")
public ResponseEntity<?> createConsultation(@RequestBody ConsultationDTO consultation)

@GetMapping("/api/consultation/animal/{id}")
public ResponseEntity<?> getConsultationsByAnimal(@PathVariable int id)

@GetMapping("/api/consultation/{id}")
public ResponseEntity<?> getConsultation(@PathVariable int id)
```

#### 3. Prescription Controller
```java
@PostMapping("/api/prescription/create")
public ResponseEntity<?> createPrescription(@RequestBody PrescriptionDTO prescription)

@GetMapping("/api/prescription/consultation/{id}")
public ResponseEntity<?> getPrescriptionsByConsultation(@PathVariable int id)

@PutMapping("/api/prescription/{id}")
public ResponseEntity<?> updatePrescription(@PathVariable int id, @RequestBody PrescriptionDTO prescription)
```

---

## 🎨 Fonctionnalités de Chaque Vue

### AnimalRegistrationScreen
- ✅ Enregistrement animal complet
- ✅ Validation tous les champs
- ✅ Sélecteur de date (date naissance)
- ✅ Dropdown sexe (Mâle/Femelle)
- ✅ Loading indicator
- ✅ Gestion des erreurs

### DossierMedicalScreen
- ✅ Créer consultation pour un animal
- ✅ Renseigner diagnostic
- ✅ Ajouter recommandations
- ✅ Planifier prochain RDV
- ✅ Affichage animal concerné
- ✅ Date consultation

### PrescriptionScreen
- ✅ Ajouter plusieurs prescriptions
- ✅ Lister les prescriptions avant sauvegarde
- ✅ Supprimer prescription avant envoi
- ✅ Validation prescription non vide
- ✅ Création multiple en une requête

### AnimalsListScreen
- ✅ Affichage liste animaux (avec expansion)
- ✅ Détails animal (sexe, poids, couleur, date naissance)
- ✅ Actions rapides (consultation, prescription)
- ✅ FAB pour ajouter animal
- ✅ Message si aucun animal

---

## 🚀 Extensions Possibles

### Court terme
```dart
// 1. Ajouter vaccination
class VaccinationScreen extends StatefulWidget {
  // Enregistrer vaccinations avec dates
}

// 2. Ajouter traitement
class TraitementScreen extends StatefulWidget {
  // Suivre traitements en cours
}

// 3. Historique consultation
class ConsultationHistoryScreen extends StatefulWidget {
  // Voir toutes les consultations d'un animal
}
```

### Moyen terme
- PDF export dossier médical
- Photos/images pour chaque animal
- Suivi du poids dans le temps
- Rappels notifications avant RDV
- Chat propriétaire-vétérinaire

### Long terme
- Scan code QR animal
- Suivi vaccins manquants
- Rappels médicaments automatiques
- Partage données avec vétérinaires

---

## 📱 Tests Locaux

### 1. Tester AnimalRegistrationScreen
```bash
flutter run
# À partir de HomeScreen → AnimalsListScreen → + FAB
```

### 2. Vérifier les appels API
```dart
// Dans ApiService:
print('POST $url with body: $body');
// Vérifier dans console Flutter
```

### 3. Mock backend (optionnel)
```dart
// Créer MockApiService pour développement offline
class MockApiService {
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    await Future.delayed(const Duration(seconds: 1));
    return {'id': Random().nextInt(1000), ...body};
  }
}
```

---

## 🔐 Sécurité

⚠️ **À implémenter:**

1. **JWT Tokens**
   - Stocker token après login
   - Ajouter token à toutes les requêtes

2. **Permissions**
   - Vérifier propriétaire avant accès animal
   - Vérifier vétérinaire avant créer consultation

3. **Validation**
   - Valider email avant création
   - Valider ID étrangères (animal, vétérinaire)

---

## 📊 Exemple Complète d'Utilisation

```dart
// Dans HomeScreen, après connexion réussie
if (userData['role'] == 'PROPRIETAIRE') {
  ElevatedButton(
    onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalsListScreen(
          idProprietaire: userData['id'],
          proprietaireName: userData['firstName'],
        ),
      ),
    ),
    child: const Text('Gérer mes animaux'),
  ),
}

// AnimalsListScreen affiche liste
// Clic sur animal → ExpansionTile se déploie
// Options: Consultation, Prescription
// Consultation crée DossierMedical → DossierMedicalScreen
// Après consultation → Proposition PrescriptionScreen
// Prescriptions enregistrées et listées
```

---

## 🐛 Troubleshooting

### "Animal not found"
- Vérifier ID propriétaire correct
- Vérifier animal existe en DB

### "Consultation creation failed"
- Vérifier ID animal valide
- Vérifier ID vétérinaire existe
- Vérifier format dates ISO 8601

### "Prescriptions not saved"
- Vérifier ID consultation valide
- Vérifier description non vide
- Vérifier réponse API 201

---

Bon développement ! 🚀
