# Référence API - Module IIIF Manifest

Documentation complète des fonctions du module `iiif-manifest.xqm`.

## Table des Matières

- [Fonctions Principales](#fonctions-principales)
- [Fonctions de Création](#fonctions-de-création)
- [Fonctions Utilitaires](#fonctions-utilitaires)
- [Types de Données](#types-de-données)
- [Exemples](#exemples)

---

## Fonctions Principales

### `iiif:generate-manifest($input-json as map(*)) as map(*)`

Génère un manifest IIIF v3 complet à partir de données JSON/map.

**Paramètres:**
- `$input-json` (map(*)) : Map contenant les données structurées du manifest

**Retourne:**
- map(*) : Map XQuery représentant le manifest IIIF v3

**Exemple:**
```xquery
let $input := map {
  "id": "https://example.org/manifest",
  "label": "Mon Manifest",
  "items": array {}
}
return iiif:generate-manifest($input)
```

**Propriétés supportées dans $input-json:**
- `id` (string, obligatoire) : URI unique du manifest
- `label` (string|map, obligatoire) : Titre du manifest
- `summary` (string|map, optionnel) : Description
- `metadata` (map|array, optionnel) : Métadonnées structurées
- `rights` (string, optionnel) : URI de la licence
- `thumbnail` (string|map|array, optionnel) : Image miniature
- `provider` (map|array, optionnel) : Information sur l'organisation
- `homepage` (string|map|array, optionnel) : Page web associée
- `items` (array, obligatoire) : Liste des canvases

---

### `iiif:create-manifest-json($input-json as map(*)) as xs:string`

Fonction de haut niveau qui génère un manifest et le sérialise en JSON.

**Paramètres:**
- `$input-json` (map(*)) : Map contenant les données du manifest

**Retourne:**
- xs:string : String JSON formatée et indentée

**Exemple:**
```xquery
let $input := map { "id": "...", "label": "...", "items": array {} }
return iiif:create-manifest-json($input)
(: Retourne une chaîne JSON valide :)
```

---

### `iiif:serialize-to-json($manifest as map(*)) as xs:string`

Sérialise un manifest XQuery map en chaîne JSON.

**Paramètres:**
- `$manifest` (map(*)) : Map du manifest IIIF

**Retourne:**
- xs:string : Chaîne JSON indentée

**Options de sérialisation:**
- Méthode : JSON
- Indentation : activée
- Encodage : UTF-8

---

## Fonctions de Création

### `iiif:create-language-map($label as item()*) as map(*)`

Crée un language map conforme IIIF à partir de différents types d'entrée.

**Paramètres:**
- `$label` (string|map|array) : Label à transformer

**Retourne:**
- map(*) : Language map IIIF

**Comportement:**
- String simple → `{ "none": ["valeur"] }`
- Map → retourné tel quel (assumé conforme)
- Array → `{ "none": array }`

**Exemples:**
```xquery
(: String simple :)
iiif:create-language-map("Titre")
(: → { "none": ["Titre"] } :)

(: Map multilingue :)
iiif:create-language-map(map {
  "fr": ["Titre en français"],
  "en": ["English title"]
})
(: → { "fr": ["Titre en français"], "en": ["English title"] } :)
```

---

### `iiif:create-metadata-array($metadata as item()*) as array(*)`

Transforme des métadonnées en array IIIF conforme.

**Paramètres:**
- `$metadata` (map|array) : Métadonnées source

**Retourne:**
- array(*) : Array d'objets avec `label` et `value`

**Format de sortie:**
```json
[
  {
    "label": { "none": ["Clé1"] },
    "value": { "none": ["Valeur1"] }
  },
  {
    "label": { "none": ["Clé2"] },
    "value": { "none": ["Valeur2"] }
  }
]
```

**Exemple:**
```xquery
let $meta := map {
  "Auteur": "Jean Dupont",
  "Date": "2025"
}
return iiif:create-metadata-array($meta)
```

---

### `iiif:create-canvas($canvas-data as map(*)) as map(*)`

Crée un canvas IIIF complet.

**Paramètres:**
- `$canvas-data` (map) : Données du canvas

**Retourne:**
- map(*) : Canvas IIIF v3

**Propriétés attendues:**
- `id` (string, obligatoire) : URI du canvas
- `label` (string|map, optionnel) : Titre du canvas
- `height` (integer, optionnel) : Hauteur en pixels
- `width` (integer, optionnel) : Largeur en pixels
- `items` (map|array, optionnel) : Annotations/images

**Exemple:**
```xquery
let $canvas := map {
  "id": "https://example.org/canvas/1",
  "label": "Page 1",
  "height": 2000,
  "width": 1500,
  "items": map { "body": "https://example.org/image.jpg" }
}
return iiif:create-canvas($canvas)
```

---

### `iiif:create-annotation($canvas-id, $anno-data, $position) as map(*)`

Crée une annotation IIIF (généralement pour une image).

**Paramètres:**
- `$canvas-id` (xs:string) : ID du canvas parent
- `$anno-data` (map) : Données de l'annotation
- `$position` (xs:integer) : Position de l'annotation

**Retourne:**
- map(*) : Annotation IIIF

**Structure d'annotation:**
```json
{
  "id": "...",
  "type": "Annotation",
  "motivation": "painting",
  "body": { ... },
  "target": "canvas-id"
}
```

**Exemple:**
```xquery
let $anno := map {
  "body": map {
    "id": "https://example.org/image.jpg",
    "type": "Image",
    "format": "image/jpeg"
  }
}
return iiif:create-annotation("https://example.org/canvas/1", $anno, 1)
```

---

### `iiif:create-annotation-body($body-data as item()*) as map(*)`

Crée le corps d'une annotation (image, vidéo, etc.).

**Paramètres:**
- `$body-data` (string|map) : Données du corps

**Retourne:**
- map(*) : Corps de l'annotation

**Propriétés supportées:**
- `id` (string) : URI de la ressource
- `type` (string) : Type (Image, Video, Audio, etc.)
- `format` (string) : MIME type
- `height` (integer) : Hauteur
- `width` (integer) : Largeur
- `service` (map|array) : Service IIIF Image API

**Exemples:**
```xquery
(: URL simple :)
iiif:create-annotation-body("https://example.org/image.jpg")

(: Objet complet :)
iiif:create-annotation-body(map {
  "id": "https://example.org/image.jpg",
  "type": "Image",
  "format": "image/jpeg",
  "height": 2000,
  "width": 1500,
  "service": map {
    "id": "https://example.org/iiif/image",
    "profile": "level2"
  }
})
```

---

### `iiif:create-provider($provider-data as item()*) as array(*)`

Crée un objet provider (organisation).

**Paramètres:**
- `$provider-data` (string|map|array) : Données du provider

**Retourne:**
- array(*) : Array contenant le provider

**Structure attendue:**
```xquery
map {
  "id": "https://organization.org",
  "label": "Nom de l'Organisation",
  "homepage": "https://organization.org",
  "logo": [...]
}
```

**Exemple:**
```xquery
let $provider := map {
  "id": "https://bibliotheque.example.org",
  "label": map {
    "fr": ["Bibliothèque Nationale"],
    "en": ["National Library"]
  },
  "homepage": "https://bibliotheque.example.org",
  "logo": array {
    map {
      "id": "https://bibliotheque.example.org/logo.png",
      "type": "Image"
    }
  }
}
return iiif:create-provider($provider)
```

---

### `iiif:create-thumbnail($thumbnail-data as item()*) as array(*)`

Crée un objet thumbnail.

**Paramètres:**
- `$thumbnail-data` (string|map|array) : Données du thumbnail

**Retourne:**
- array(*) : Array contenant le thumbnail

**Formats acceptés:**
- String : URL simple
- Map : Objet thumbnail complet
- Array : Array de thumbnails

**Exemples:**
```xquery
(: URL simple :)
iiif:create-thumbnail("https://example.org/thumb.jpg")

(: Objet complet :)
iiif:create-thumbnail(map {
  "id": "https://example.org/thumb.jpg",
  "type": "Image",
  "format": "image/jpeg",
  "width": 200,
  "height": 300
})
```

---

### `iiif:create-homepage($homepage-data as item()*) as array(*)`

Crée un objet homepage.

**Paramètres:**
- `$homepage-data` (string|map|array) : Données de la homepage

**Retourne:**
- array(*) : Array contenant la homepage

**Format par défaut (string):**
```json
[{
  "id": "url",
  "type": "Text",
  "format": "text/html"
}]
```

---

### `iiif:create-image-service($service-data as item()*) as array(*)`

Crée un service IIIF Image API.

**Paramètres:**
- `$service-data` (map|array) : Données du service

**Retourne:**
- array(*) : Array contenant le service

**Propriétés:**
- `id` (string) : Base URI du service IIIF Image
- `type` (string) : "ImageService3" (automatique)
- `profile` (string) : "level0", "level1", ou "level2" (défaut: "level2")

**Exemple:**
```xquery
let $service := map {
  "id": "https://example.org/iiif/image/abc123",
  "profile": "level2"
}
return iiif:create-image-service($service)
(: Retourne un service ImageService3 :)
```

---

## Fonctions de Construction de Structure

### `iiif:create-canvas-items($items-data as item()*) as array(*)`

Crée l'array des canvases pour le manifest.

**Paramètres:**
- `$items-data` (array) : Array de données de canvases

**Retourne:**
- array(*) : Array de canvases IIIF

---

### `iiif:create-annotation-pages($canvas-id, $items-data) as array(*)`

Crée les annotation pages d'un canvas.

**Paramètres:**
- `$canvas-id` (xs:string) : ID du canvas parent
- `$items-data` (item) : Données des annotations

**Retourne:**
- array(*) : Array d'annotation pages

---

### `iiif:create-annotations($canvas-id, $annotation-data) as array(*)`

Crée les annotations pour une annotation page.

**Paramètres:**
- `$canvas-id` (xs:string) : ID du canvas
- `$annotation-data` (item) : Données des annotations

**Retourne:**
- array(*) : Array d'annotations

---

## Types de Données

### Language Map

Structure IIIF pour le contenu multilingue :

```json
{
  "en": ["English text"],
  "fr": ["Texte français"],
  "none": ["Sans langue spécifiée"]
}
```

### Metadata Entry

```json
{
  "label": { "langue": ["Clé"] },
  "value": { "langue": ["Valeur"] }
}
```

### Canvas

```json
{
  "id": "uri",
  "type": "Canvas",
  "label": { ... },
  "height": 2000,
  "width": 1500,
  "items": [ ... ]
}
```

### Annotation

```json
{
  "id": "uri",
  "type": "Annotation",
  "motivation": "painting",
  "body": { ... },
  "target": "canvas-uri"
}
```

---

## Variables du Module

### `$iiif:context`

URI du contexte IIIF Presentation API v3.

**Valeur:**
```
"http://iiif.io/api/presentation/3/context.json"
```

---

## Exemples Complets

### Manifest Minimal

```xquery
iiif:create-manifest-json(map {
  "id": "https://example.org/manifest",
  "label": "Titre Minimal",
  "items": array {}
})
```

### Manifest avec Image

```xquery
iiif:create-manifest-json(map {
  "id": "https://example.org/manifest",
  "label": "Une Image",
  "items": array {
    map {
      "id": "https://example.org/canvas/1",
      "label": "Image 1",
      "height": 1000,
      "width": 800,
      "items": map {
        "body": "https://example.org/image.jpg"
      }
    }
  }
})
```

### Manifest Multilingue avec Métadonnées

```xquery
iiif:create-manifest-json(map {
  "id": "https://example.org/manifest",
  "label": map {
    "fr": ["Titre en Français"],
    "en": ["English Title"]
  },
  "summary": map {
    "fr": ["Description en français"],
    "en": ["English description"]
  },
  "metadata": map {
    "Auteur": "Jean Dupont",
    "Date": "2025",
    "Langue": "Français"
  },
  "rights": "http://creativecommons.org/licenses/by/4.0/",
  "items": array { ... }
})
```

---

## Gestion des Erreurs

Le module adopte une approche tolérante :
- Les champs manquants utilisent des valeurs par défaut
- Les types incorrects sont convertis quand possible
- Les arrays vides sont acceptés

**Exemple :**
```xquery
(: Label manquant → utilise "Sans titre" :)
iiif:generate-manifest(map {
  "id": "https://example.org/manifest",
  "items": array {}
})
```

---

## Compatibilité

- **XQuery:** 3.1 minimum
- **Processeurs testés:** BaseX, eXist-db, Saxon-EE
- **IIIF:** Presentation API 3.0
- **JSON:** Nécessite support `parse-json()` et sérialisation JSON

---

## Notes de Performance

- Les grandes collections (>1000 canvases) peuvent nécessiter l'optimisation
- Utiliser le streaming si disponible pour très grands manifests
- La sérialisation JSON peut être coûteuse pour structures profondes

---

## Versions

**1.0** (2025-10-22)
- Version initiale
- Support complet IIIF Presentation API 3.0
- Toutes les fonctionnalités principales

---

**Documentation générée pour iiif-manifest.xqm v1.0**
