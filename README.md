# Module XQuery pour Génération de Manifests IIIF v3

Module XQuery professionnel pour générer des manifests conformes à la spécification [IIIF Presentation API 3.0](https://iiif.io/api/presentation/3.0/) à partir de données JSON.

## 🎯 Objectif

Ce module permet de transformer des données structurées (JSON/maps) en manifests IIIF v3 valides, facilitant l'intégration avec les viewers IIIF comme Mirador, Universal Viewer, ou OpenSeadragon.

## 📋 Caractéristiques

- ✅ **Conforme IIIF v3** : Génère des manifests respectant la spécification IIIF Presentation API 3.0
- 🌍 **Support multilingue** : Gestion des language maps IIIF
- 🎨 **Flexible** : Supporte les métadonnées riches, thumbnails, providers, et services d'images
- 🧪 **Testé** : Suite de tests unitaires incluse
- 📚 **Documenté** : Exemples complets et documentation détaillée
- 🔧 **Modulaire** : Architecture propre et réutilisable

## 🚀 Installation

### Prérequis

- Un processeur XQuery 3.1+ (BaseX, eXist-db, MarkLogic, Saxon, etc.)
- Support du parsing JSON (fonction `parse-json()`)
- Support de la sérialisation JSON

### Installation du module

1. Clonez ce dépôt :
```bash
git clone <repository-url>
cd Code
```

2. Copiez le module dans votre environnement XQuery :
```bash
cp modules/iiif-manifest.xqm /path/to/your/xquery/modules/
```

3. Importez le module dans vos requêtes XQuery :
```xquery
import module namespace iiif = "http://iiif.io/xquery/manifest"
  at "/path/to/iiif-manifest.xqm";
```

## 📖 Usage

### Exemple Simple

```xquery
xquery version "3.1";

import module namespace iiif = "http://iiif.io/xquery/manifest"
  at "../modules/iiif-manifest.xqm";

let $input := map {
  "id": "https://example.org/iiif/book1/manifest",
  "label": "Mon Premier Manifest",
  "items": array {
    map {
      "id": "https://example.org/iiif/book1/canvas/p1",
      "label": "Page 1",
      "height": 2000,
      "width": 1500,
      "items": map {
        "body": "https://example.org/images/p1.jpg"
      }
    }
  }
}

return iiif:create-manifest-json($input)
```

### À partir d'une Chaîne JSON

```xquery
let $json-string := '{
  "id": "https://example.org/manifest",
  "label": "Exemple",
  "items": [...]
}'

let $input := parse-json($json-string)
return iiif:create-manifest-json($input)
```

### Manifest Complet avec Métadonnées

```xquery
let $input := map {
  "id": "https://example.org/iiif/manuscript/manifest",
  "label": map {
    "fr": ["Manuscrit Médiéval"],
    "en": ["Medieval Manuscript"]
  },
  "summary": map {
    "fr": ["Un manuscrit du XIIIe siècle"],
    "en": ["A 13th century manuscript"]
  },
  "metadata": map {
    "Auteur": "Guillaume de Lorris",
    "Date": "circa 1230",
    "Langue": "Ancien français"
  },
  "rights": "http://creativecommons.org/licenses/by/4.0/",
  "provider": map {
    "id": "https://bibliotheque.example.org",
    "label": "Bibliothèque Nationale",
    "homepage": "https://bibliotheque.example.org"
  },
  "items": array {
    map {
      "id": "https://example.org/iiif/manuscript/canvas/f1r",
      "label": "Folio 1r",
      "height": 4000,
      "width": 3000,
      "items": map {
        "body": map {
          "id": "https://example.org/images/f1r.jpg",
          "type": "Image",
          "format": "image/jpeg",
          "height": 4000,
          "width": 3000,
          "service": map {
            "id": "https://example.org/iiif/images/f1r",
            "profile": "level2"
          }
        }
      }
    }
  }
}

return iiif:create-manifest-json($input)
```

## 📚 Structure du Projet

```
Code/
├── modules/
│   └── iiif-manifest.xqm        # Module principal
├── examples/
│   ├── simple-manifest.xq       # Exemple simple
│   ├── complex-manifest.xq      # Exemple avancé
│   └── from-json-string.xq      # Parse depuis JSON
├── data/
│   ├── sample-input.json        # Données d'exemple
│   └── sample-output.json       # Résultat attendu
├── tests/
│   └── test-iiif-manifest.xq    # Tests unitaires
└── README.md                     # Cette documentation
```

## 🔧 Fonctions Principales

### `iiif:generate-manifest($input-json as map(*)) as map(*)`

Génère un manifest IIIF v3 à partir d'un map XQuery.

**Paramètres:**
- `$input-json` : Map contenant les données du manifest

**Retourne:** Map représentant le manifest IIIF v3

### `iiif:create-manifest-json($input-json as map(*)) as xs:string`

Génère un manifest IIIF v3 et le sérialise en JSON.

**Paramètres:**
- `$input-json` : Map contenant les données du manifest

**Retourne:** String JSON du manifest IIIF v3

### Fonctions Utilitaires

- `iiif:create-language-map($label)` : Crée un language map IIIF
- `iiif:create-metadata-array($metadata)` : Transforme les métadonnées
- `iiif:create-canvas($canvas-data)` : Crée un canvas IIIF
- `iiif:create-annotation($canvas-id, $anno-data, $position)` : Crée une annotation
- `iiif:create-provider($provider-data)` : Crée un objet provider
- `iiif:create-image-service($service-data)` : Crée un service d'image IIIF

## 📐 Format des Données d'Entrée

### Structure JSON d'Entrée

```json
{
  "id": "https://example.org/manifest",
  "label": "Titre du manifest (string ou language map)",
  "summary": "Description (optionnel)",
  "metadata": {
    "Clé": "Valeur"
  },
  "rights": "URL de licence (optionnel)",
  "thumbnail": "URL ou objet (optionnel)",
  "provider": {
    "id": "URL",
    "label": "Nom de l'organisation",
    "homepage": "URL"
  },
  "homepage": "URL (optionnel)",
  "items": [
    {
      "id": "URL du canvas",
      "label": "Titre de la page",
      "height": 2000,
      "width": 1500,
      "items": {
        "body": {
          "id": "URL de l'image",
          "type": "Image",
          "format": "image/jpeg",
          "height": 2000,
          "width": 1500,
          "service": {
            "id": "URL du service IIIF Image",
            "profile": "level0|level1|level2"
          }
        }
      }
    }
  ]
}
```

### Champs Obligatoires

- `id` : Identifiant unique du manifest
- `label` : Titre du manifest
- `items` : Array de canvases (peut être vide)

### Champs Optionnels

- `summary` : Résumé ou description
- `metadata` : Métadonnées structurées
- `rights` : URL de la licence
- `thumbnail` : Image miniature
- `provider` : Organisation responsable
- `homepage` : Page web associée

## 🧪 Tests

Exécutez les tests unitaires :

```bash
# Avec BaseX
basex tests/test-iiif-manifest.xq

# Avec eXist-db
curl -u admin:password \
  -X POST \
  -H "Content-Type: application/xml" \
  --data-binary @tests/test-iiif-manifest.xq \
  http://localhost:8080/exist/rest/db
```

Résultat attendu :
```
==============================================================
  Tests du module IIIF Manifest
==============================================================

✓ PASS: Language map from string
✓ PASS: Language map multilingual
✓ PASS: Minimal manifest generation
✓ PASS: Metadata array creation
✓ PASS: Canvas creation
✓ PASS: Annotation creation
✓ PASS: Provider creation
✓ PASS: Thumbnail from URL string
✓ PASS: Image service creation
✓ PASS: Complete manifest with canvas
✓ PASS: JSON serialization

==============================================================
  Résultats: 11 passés, 0 échoués sur 11 tests
==============================================================
```

## 📊 Exemples d'Exécution

### Avec BaseX

```bash
basex examples/simple-manifest.xq > output/manifest.json
```

### Avec eXist-db

```bash
curl -u admin:password \
  -X POST \
  -H "Content-Type: application/xml" \
  --data-binary @examples/simple-manifest.xq \
  http://localhost:8080/exist/rest/db > manifest.json
```

### Avec Saxon

```bash
saxon -xq:examples/simple-manifest.xq -o:manifest.json
```

## 🔗 Validation IIIF

Pour valider vos manifests générés :

1. **Validator officiel IIIF** : https://presentation-validator.iiif.io/
2. **Viewer Mirador** : https://projectmirador.org/
3. **Universal Viewer** : https://universalviewer.io/

## 🌟 Exemples de Cas d'Usage

### 1. Bibliothèque Numérique

Générez des manifests pour une collection de livres numérisés avec métadonnées complètes.

### 2. Archives Photographiques

Créez des manifests pour des collections de photographies historiques.

### 3. Manuscrits Médiévaux

Générez des manifests pour des manuscrits avec métadonnées codicologiques.

### 4. Collections de Musée

Créez des manifests pour des œuvres d'art avec informations détaillées.

## 🐛 Débogage

Pour déboguer le module :

```xquery
(: Activer le mode verbose :)
let $manifest := iiif:generate-manifest($input)
return (
  "Type:", map:get($manifest, "type"),
  "Context:", map:get($manifest, "@context"),
  "Items count:", array:size(map:get($manifest, "items"))
)
```

## 📝 Licence

Ce projet est fourni sous licence libre pour usage académique et commercial.

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Signaler des bugs
- Proposer des améliorations
- Soumettre des pull requests
- Ajouter des exemples

## 📚 Ressources

- [IIIF Presentation API 3.0](https://iiif.io/api/presentation/3.0/)
- [IIIF Image API 3.0](https://iiif.io/api/image/3.0/)
- [XQuery 3.1 Specification](https://www.w3.org/TR/xquery-31/)
- [JSON Support in XQuery](https://www.w3.org/TR/xquery-31/#id-json-support)

## ✨ Auteur

Généré avec Claude Code

## 📧 Support

Pour toute question ou problème, veuillez ouvrir une issue sur le dépôt GitHub.

---

**Version:** 1.0
**Date:** 2025-10-22
**Compatibilité:** XQuery 3.1+, IIIF Presentation API 3.0
