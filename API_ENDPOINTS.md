# 📋 Endpoints API - Clinique Vétérinaire

## 🔐 Authentification

### Login
```http
POST /api/auth/login?email=user@example.com&password=pwd123
Response 200:
{
  "id": 1,
  "email": "user@example.com",
  "role": "PROPRIETAIRE"
}
```

### Inscription
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "new@example.com",
  "password": "securepass123",
  "firstName": "Jean",
  "lastName": "Dupont",
  "role": "PROPRIETAIRE"
}
Response 201:
{
  "id": 2,
  "email": "new@example.com",
  "role": "PROPRIETAIRE"
}
```

---

## 🐾 Animal

### Créer un animal
```http
POST /api/animal/create
Content-Type: application/json

{
  "id_proprietaire": 1,
  "ghimat_name": "Rex",
  "ghimat_especie": "Chien",
  "animal_race": "Labrador",
  "animal_birthday": "2020-05-15",
  "weight_stat": 30.5,
  "sex": "Mâle",
  "color": "Noir"
}
Response 201:
{
  "id_animal": 10,
  "id_proprietaire": 1,
  "ghimat_name": "Rex",
  "ghimat_especie": "Chien",
  "animal_race": "Labrador",
  "animal_birthday": "2020-05-15",
  "weight_stat": 30.5,
  "sex": "Mâle",
  "color": "Noir",
  "date_creation": "2026-02-24"
}
```

### Récupérer les animaux d'un propriétaire
```http
GET /api/animal/proprietaire/{id_proprietaire}
Response 200:
[
  {
    "id_animal": 10,
    "ghimat_name": "Rex",
    ...
  },
  {
    "id_animal": 11,
    "ghimat_name": "Minou",
    ...
  }
]
```

### Récupérer un animal
```http
GET /api/animal/{id_animal}
Response 200:
{
  "id_animal": 10,
  "ghimat_name": "Rex",
  ...
}
```

### Mettre à jour un animal
```http
PUT /api/animal/{id_animal}
Content-Type: application/json

{
  "weight_stat": 32.0,
  "color": "Noir et blanc"
}
Response 200:
{
  "id_animal": 10,
  "weight_stat": 32.0,
  ...
}
```

---

## 👨‍⚕️ Consultation (Dossier Médical)

### Créer une consultation
```http
POST /api/consultation/create
Content-Type: application/json

{
  "id_animal": 10,
  "id_veterinaire": 1,
  "date_consultation": "2026-02-24",
  "diagnostic": "Otite externe",
  "recommended": "Traitement antibiotique local",
  "date_prochain_rdv": "2026-03-10"
}
Response 201:
{
  "id_consultation": 50,
  "id_animal": 10,
  "id_veterinaire": 1,
  "date_consultation": "2026-02-24",
  "diagnostic": "Otite externe",
  "recommended": "Traitement antibiotique local",
  "date_prochain_rdv": "2026-03-10"
}
```

### Récupérer les consultations d'un animal
```http
GET /api/consultation/animal/{id_animal}
Response 200:
[
  {
    "id_consultation": 50,
    "date_consultation": "2026-02-24",
    "diagnostic": "Otite externe"
  },
  {
    "id_consultation": 51,
    "date_consultation": "2026-02-10",
    "diagnostic": "Vaccination"
  }
]
```

### Récupérer une consultation
```http
GET /api/consultation/{id_consultation}
Response 200:
{
  "id_consultation": 50,
  "id_animal": 10,
  "diagnostic": "Otite externe",
  ...
}
```

---

## 💊 Prescription

### Créer une prescription
```http
POST /api/prescription/create
Content-Type: application/json

{
  "id_consultation": 50,
  "description": "Amoxicilline 500mg, 3 fois par jour pendant 7 jours",
  "date_creation": "2026-02-24",
  "unavailable": false
}
Response 201:
{
  "id_prescription": 100,
  "id_consultation": 50,
  "description": "Amoxicilline 500mg, 3 fois par jour pendant 7 jours",
  "date_creation": "2026-02-24",
  "unavailable": false
}
```

### Récupérer les prescriptions d'une consultation
```http
GET /api/prescription/consultation/{id_consultation}
Response 200:
[
  {
    "id_prescription": 100,
    "description": "Amoxicilline 500mg, 3 fois par jour pendant 7 jours",
    "date_creation": "2026-02-24",
    "unavailable": false
  },
  {
    "id_prescription": 101,
    "description": "Nettoyage auriculaire quotidien",
    ...
  }
]
```

### Marquer comme indisponible
```http
PUT /api/prescription/{id_prescription}
Content-Type: application/json

{
  "unavailable": true
}
Response 200:
{
  "id_prescription": 100,
  "unavailable": true,
  ...
}
```

---

## 💉 Vaccination

### Créer une vaccination
```http
POST /api/vaccination/create
Content-Type: application/json

{
  "id_consultation": 50,
  "type_vaccin": "Rage",
  "date_administration": "2026-02-24",
  "status": "Administrée"
}
Response 201:
{
  "id_vaccination": 200,
  "id_consultation": 50,
  "type_vaccin": "Rage",
  "date_administration": "2026-02-24",
  "status": "Administrée"
}
```

### Récupérer les vaccinations d'un animal
```http
GET /api/vaccination/animal/{id_animal}
Response 200:
[
  {
    "id_vaccination": 200,
    "type_vaccin": "Rage",
    "date_administration": "2026-02-24",
    "status": "Administrée"
  }
]
```

---

## 🔬 Examen Médical

### Créer un examen
```http
POST /api/examen/create
Content-Type: application/json

{
  "id_consultation": 50,
  "type_examen": "Radiographie",
  "observations": "Rien anormal détecté",
  "date_examen": "2026-02-24"
}
Response 201:
{
  "id_examen": 300,
  "id_consultation": 50,
  "type_examen": "Radiographie",
  "observations": "Rien anormal détecté",
  "date_examen": "2026-02-24"
}
```

---

## 🏥 Traitement

### Créer un traitement
```http
POST /api/traitement/create
Content-Type: application/json

{
  "id_consultation": 50,
  "nom_medicament": "Amoxicilline",
  "dosage": "500mg",
  "frequence": "3 fois par jour",
  "date_debut": "2026-02-24",
  "date_fin": "2026-03-02",
  "voie_admin": "Orale"
}
Response 201:
{
  "id_traitement": 400,
  "id_consultation": 50,
  "nom_medicament": "Amoxicilline",
  ...
}
```

---

## 📋 Maladie

### Créer/Enregistrer une maladie
```http
POST /api/maladie/create
Content-Type: application/json

{
  "id_consultation": 50,
  "nom_maladie": "Otite externe",
  "description": "Inflammation de l'oreille externe"
}
Response 201:
{
  "id_maladie": 500,
  "nom_maladie": "Otite externe",
  "description": "Inflammation de l'oreille externe"
}
```

---

## 📊 Codes de Réponse

| Code | Signification |
|------|---------------|
| 200 | OK - Succès |
| 201 | Created - Ressource créée |
| 400 | Bad Request - Erreur de requête |
| 401 | Unauthorized - Non authentifié |
| 403 | Forbidden - Non autorisé |
| 404 | Not Found - Ressource non trouvée |
| 409 | Conflict - Ressource existe déjà |
| 500 | Internal Server Error - Erreur serveur |

---

## 🔗 Relations entre Tables

```
Utilisateur (USER)
├── Propriétaire
│   └── Animal
│       ├── Consultation
│       │   ├── Prescription
│       │   ├── Vaccination
│       │   ├── Examen Médical
│       │   ├── Traitement
│       │   └── Maladie
│       ├── Race
│       └── Espèce
├── Vétérinaire
│   ├── Consultation
│   └── Admin
```

---

## 📝 Notes Importantes

1. **Date Format**: Utiliser le format ISO 8601 (`YYYY-MM-DD` ou `YYYY-MM-DDTHH:mm:ss`)
2. **Authentication**: Implémenter JWT tokens pour sécuriser les requêtes après login
3. **Permissions**: Vérifier que seuls les propriétaires/vétérinaires accèdent à leurs données
4. **Validation**: Valider côté backend tous les champs

---

Endpoints générés automatiquement par l'app Flutter. À adapter selon votre backend Java Spring Boot.
