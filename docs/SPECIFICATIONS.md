# Spécifications IIIF Presentation API 3.0

Documentation de référence pour la conformité du module avec IIIF v3.

## 📋 Vue d'ensemble

Le module implémente les spécifications suivantes de IIIF Presentation API 3.0 :
- https://iiif.io/api/presentation/3.0/

## ✅ Fonctionnalités Implémentées

### Classes de Ressources

#### 1. Manifest (Obligatoire)
- ✅ `@context` : Contexte IIIF v3
- ✅ `id` : URI unique
- ✅ `type` : "Manifest"
- ✅ `label` : Language Map
- ✅ `metadata` : Array de paires label/value
- ✅ `summary` : Language Map
- ✅ `thumbnail` : Array d'objets thumbnail
- ✅ `rights` : URI de licence
- ✅ `provider` : Array d'Agents
- ✅ `homepage` : Array de ressources web
- ✅ `items` : Array de Canvas

#### 2. Canvas (Obligatoire)
- ✅ `id` : URI unique
- ✅ `type` : "Canvas"
- ✅ `label` : Language Map
- ✅ `height` : Dimension en pixels
- ✅ `width` : Dimension en pixels
- ✅ `items` : Array d'AnnotationPage

#### 3. AnnotationPage (Obligatoire)
- ✅ `id` : URI unique
- ✅ `type` : "AnnotationPage"
- ✅ `items` : Array d'Annotation

#### 4. Annotation (Obligatoire)
- ✅ `id` : URI unique
- ✅ `type` : "Annotation"
- ✅ `motivation` : "painting" (par défaut)
- ✅ `body` : Contenu de l'annotation
- ✅ `target` : Canvas cible

#### 5. Annotation Body (Images)
- ✅ `id` : URI de la ressource
- ✅ `type` : "Image"
- ✅ `format` : MIME type
- ✅ `height` : Dimension
- ✅ `width` : Dimension
- ✅ `service` : IIIF Image API service

#### 6. Agent (Provider)
- ✅ `id` : URI de l'organisation
- ✅ `type` : "Agent"
- ✅ `label` : Nom de l'organisation
- ✅ `homepage` : Page web
- ✅ `logo` : Logo de l'organisation

#### 7. Image Service
- ✅ `id` : Base URI du service
- ✅ `type` : "ImageService3"
- ✅ `profile` : "level0" | "level1" | "level2"

### Propriétés Techniques

#### Language Maps
Conforme à la spécification IIIF pour le multilingue :
```json
{
  "en": ["English text"],
  "fr": ["Texte français"],
  "none": ["No specific language"]
}
```

#### Métadonnées
Format standardisé :
```json
[
  {
    "label": { "langue": ["Clé"] },
    "value": { "langue": ["Valeur"] }
  }
]
```

## 🔧 Conformité

### Éléments Obligatoires

Le module garantit la présence des champs obligatoires :

| Ressource | Champs Obligatoires | Implémenté |
|-----------|-------------------|-----------|
| Manifest | `@context`, `id`, `type`, `label`, `items` | ✅ |
| Canvas | `id`, `type`, `label`, `items` | ✅ |
| AnnotationPage | `id`, `type`, `items` | ✅ |
| Annotation | `id`, `type`, `motivation`, `body`, `target` | ✅ |
| Agent | `id`, `type`, `label` | ✅ |

### Éléments Recommandés

| Ressource | Champs Recommandés | Implémenté |
|-----------|-------------------|-----------|
| Manifest | `metadata`, `summary`, `thumbnail`, `rights`, `provider` | ✅ |
| Canvas | `height`, `width` | ✅ |
| Annotation Body | `format`, `height`, `width`, `service` | ✅ |

### Éléments Optionnels

| Ressource | Champs Optionnels | Implémenté |
|-----------|------------------|-----------|
| Manifest | `homepage`, `seeAlso`, `rendering`, `partOf`, `start`, `services` | ❌ Partiellement |
| Canvas | `duration`, `viewingDirection`, `behavior` | ❌ |
| Annotation | `timeMode` | ❌ |

## 📐 Structure Hiérarchique

```
Manifest
├── @context (string)
├── id (URI)
├── type = "Manifest"
├── label (Language Map)
├── metadata (array)
├── summary (Language Map)
├── thumbnail (array)
├── rights (URI)
├── provider (array)
│   └── Agent
│       ├── id (URI)
│       ├── type = "Agent"
│       ├── label (Language Map)
│       ├── homepage (array)
│       └── logo (array)
├── homepage (array)
└── items (array)
    └── Canvas
        ├── id (URI)
        ├── type = "Canvas"
        ├── label (Language Map)
        ├── height (integer)
        ├── width (integer)
        └── items (array)
            └── AnnotationPage
                ├── id (URI)
                ├── type = "AnnotationPage"
                └── items (array)
                    └── Annotation
                        ├── id (URI)
                        ├── type = "Annotation"
                        ├── motivation (string)
                        ├── body
                        │   ├── id (URI)
                        │   ├── type = "Image"
                        │   ├── format (MIME)
                        │   ├── height (integer)
                        │   ├── width (integer)
                        │   └── service (array)
                        │       └── ImageService3
                        └── target (URI)
```

## 🎯 Cas d'Usage Supportés

### 1. Livre Numérique Simple
- ✅ Manifest avec plusieurs pages
- ✅ Une image par page
- ✅ Métadonnées bibliographiques

### 2. Manuscrit avec Métadonnées Riches
- ✅ Métadonnées complexes
- ✅ Multilinguisme
- ✅ Information sur le provider

### 3. Collection d'Images
- ✅ Multiples canvases
- ✅ Services IIIF Image API
- ✅ Thumbnails

### 4. Archives Numériques
- ✅ Droits et licences
- ✅ Homepage et liens externes
- ✅ Provider avec logo

## 🚫 Limitations Connues

### Fonctionnalités Non Implémentées (v1.0)

1. **Collections** : Pas de support pour `Collection` type
2. **Ranges** : Structure de table des matières non supportée
3. **Annotations non-painting** : Seulement motivation "painting"
4. **Contenu A/V** : Pas de support vidéo/audio (seulement images)
5. **Services avancés** : Seulement ImageService3
6. **Behavior** : Propriétés de comportement non implémentées
7. **ViewingDirection** : Pas de support pour direction de lecture
8. **Multilingual metadata values** : Simplifié

### Contournements

#### Collections
Pour créer une collection, créez plusieurs manifests séparés.

#### Ranges
Utilisez des métadonnées structurées ou des labels de canvas.

#### Annotations Avancées
Pour des annotations complexes, étendez `iiif:create-annotation()`.

## 🔍 Validation

### Validators Recommandés

1. **IIIF Presentation Validator**
   - URL: https://presentation-validator.iiif.io/
   - Valide la conformité complète

2. **IIIF Viewer (Mirador)**
   - Test de visualisation réelle
   - Vérification de l'interopérabilité

3. **JSON Schema Validation**
   - Validation structurelle du JSON

### Commandes de Validation

```bash
# Générer un manifest
basex examples/simple-manifest.xq > manifest.json

# Valider avec un outil externe
curl -X POST \
  -H "Content-Type: application/json" \
  -d @manifest.json \
  https://presentation-validator.iiif.io/validate
```

## 📊 Comparaison IIIF v2 vs v3

| Aspect | IIIF v2 | IIIF v3 | Module |
|--------|---------|---------|---------|
| Context | presentation/2 | presentation/3 | ✅ v3 |
| @type vs type | @type | type | ✅ type |
| label format | String ou objet | Language Map | ✅ Language Map |
| Service type | "ImageService2" | "ImageService3" | ✅ ImageService3 |
| Annotation structure | Simple | Web Annotation | ✅ Web Annotation |
| Resource vs Body | resource | body | ✅ body |

## 🔗 Références

### Spécifications IIIF
- [Presentation API 3.0](https://iiif.io/api/presentation/3.0/)
- [Image API 3.0](https://iiif.io/api/image/3.0/)
- [Change Log v2 to v3](https://iiif.io/api/presentation/3.0/change-log/)

### Implémentations de Référence
- [IIIF Cookbook](https://iiif.io/api/cookbook/)
- [Bodleian Libraries Examples](https://github.com/bodleian/iiif-manifest-examples)
- [IIIF Awesome](https://github.com/IIIF/awesome-iiif)

### JSON-LD Context
- [IIIF Context](http://iiif.io/api/presentation/3/context.json)
- [Web Annotation Context](http://www.w3.org/ns/anno.jsonld)

## 📝 Notes de Conformité

### Stricte
Le module génère des manifests **strictement conformes** à IIIF v3 pour :
- Structure de base du manifest
- Canvas et annotations
- Language maps
- Services d'images

### Tolérante
Le module est **tolérant en entrée** :
- Accepte différents formats (string, map, array)
- Fournit des valeurs par défaut
- Convertit automatiquement les types

### Validation
Il est **fortement recommandé** de valider les manifests générés avec le validator officiel IIIF avant publication.

---

**Version:** 1.0
**Conforme à:** IIIF Presentation API 3.0
**Date:** 2025-10-22
