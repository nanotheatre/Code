xquery version "3.1";

(:~
 : Exemple avancé de génération d'un manifest IIIF v3
 :
 : Cet exemple montre un manifest avec plusieurs canvases, métadonnées riches,
 : et multiples annotations
 :)

import module namespace iiif = "http://iiif.io/xquery/manifest" at "../modules/iiif-manifest.xqm";

(: Données d'entrée complètes :)
let $input := map {
  "id": "https://example.org/iiif/manuscript123/manifest",
  "label": map {
    "fr": ["Manuscrit Médiéval Illustré"],
    "en": ["Illuminated Medieval Manuscript"]
  },
  "summary": map {
    "fr": ["Un magnifique manuscrit médiéval du XIIIe siècle avec enluminures"],
    "en": ["A beautiful 13th century medieval manuscript with illuminations"]
  },
  "metadata": map {
    "Titre": "Le Roman de la Rose",
    "Auteur": "Guillaume de Lorris et Jean de Meun",
    "Date de création": "circa 1230-1280",
    "Langue": "Ancien français",
    "Matériau": "Parchemin",
    "Dimensions": "30 x 21 cm",
    "Provenance": "Bibliothèque Royale, Paris"
  },
  "rights": "http://creativecommons.org/licenses/by-nc/4.0/",
  "thumbnail": array {
    map {
      "id": "https://example.org/iiif/manuscript123/thumb.jpg",
      "type": "Image",
      "format": "image/jpeg",
      "width": 200,
      "height": 300
    }
  },
  "provider": map {
    "id": "https://bibliotheque.example.org",
    "label": map {
      "fr": ["Bibliothèque Nationale de France"],
      "en": ["National Library of France"]
    },
    "homepage": "https://bibliotheque.example.org",
    "logo": array {
      map {
        "id": "https://bibliotheque.example.org/logo.png",
        "type": "Image",
        "format": "image/png"
      }
    }
  },
  "homepage": array {
    map {
      "id": "https://bibliotheque.example.org/manuscripts/123",
      "type": "Text",
      "format": "text/html",
      "label": map {
        "fr": ["Page du catalogue"],
        "en": ["Catalog page"]
      }
    }
  },
  "items": array {
    (: Page 1 - Folio 1r :)
    map {
      "id": "https://example.org/iiif/manuscript123/canvas/f1r",
      "label": map {
        "none": ["Folio 1r"]
      },
      "height": 4000,
      "width": 3000,
      "items": array {
        map {
          "body": map {
            "id": "https://example.org/iiif/manuscript123/images/f1r.jpg",
            "type": "Image",
            "format": "image/jpeg",
            "height": 4000,
            "width": 3000,
            "service": map {
              "id": "https://example.org/iiif/manuscript123/images/f1r",
              "profile": "level2"
            }
          }
        }
      }
    },
    (: Page 2 - Folio 1v :)
    map {
      "id": "https://example.org/iiif/manuscript123/canvas/f1v",
      "label": map {
        "none": ["Folio 1v"]
      },
      "height": 4000,
      "width": 3000,
      "items": array {
        map {
          "body": map {
            "id": "https://example.org/iiif/manuscript123/images/f1v.jpg",
            "type": "Image",
            "format": "image/jpeg",
            "height": 4000,
            "width": 3000,
            "service": map {
              "id": "https://example.org/iiif/manuscript123/images/f1v",
              "profile": "level2"
            }
          }
        }
      }
    },
    (: Page 3 - Folio 2r :)
    map {
      "id": "https://example.org/iiif/manuscript123/canvas/f2r",
      "label": map {
        "none": ["Folio 2r"]
      },
      "height": 4000,
      "width": 3000,
      "items": array {
        map {
          "body": map {
            "id": "https://example.org/iiif/manuscript123/images/f2r.jpg",
            "type": "Image",
            "format": "image/jpeg",
            "height": 4000,
            "width": 3000,
            "service": map {
              "id": "https://example.org/iiif/manuscript123/images/f2r",
              "profile": "level2"
            }
          }
        }
      }
    }
  }
}

(: Génération du manifest :)
return iiif:create-manifest-json($input)
