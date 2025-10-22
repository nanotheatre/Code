xquery version "3.1";

(:~
 : Exemple simple de génération d'un manifest IIIF v3
 :
 : Cet exemple montre comment créer un manifest minimal avec une seule image
 :)

import module namespace iiif = "http://iiif.io/xquery/manifest" at "../modules/iiif-manifest.xqm";

(: Données d'entrée au format map :)
let $input := map {
  "id": "https://example.org/iiif/book1/manifest",
  "label": "Exemple de Manifest Simple",
  "summary": "Ceci est un manifest IIIF v3 minimal",
  "metadata": map {
    "Auteur": "Jean Dupont",
    "Date": "2025",
    "Langue": "Français"
  },
  "rights": "http://creativecommons.org/licenses/by/4.0/",
  "provider": map {
    "id": "https://example.org/about",
    "label": "Bibliothèque Nationale d'Exemple",
    "homepage": "https://example.org"
  },
  "items": array {
    map {
      "id": "https://example.org/iiif/book1/canvas/p1",
      "label": "Page 1",
      "height": 2000,
      "width": 1500,
      "items": map {
        "body": map {
          "id": "https://example.org/iiif/book1/images/p1.jpg",
          "type": "Image",
          "format": "image/jpeg",
          "height": 2000,
          "width": 1500,
          "service": map {
            "id": "https://example.org/iiif/book1/images/p1",
            "profile": "level2"
          }
        }
      }
    }
  }
}

(: Génération du manifest :)
return iiif:create-manifest-json($input)
