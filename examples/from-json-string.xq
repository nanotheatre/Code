xquery version "3.1";

(:~
 : Exemple de génération d'un manifest IIIF v3 à partir d'une chaîne JSON
 :
 : Cet exemple montre comment parser une chaîne JSON et générer un manifest
 :)

import module namespace iiif = "http://iiif.io/xquery/manifest" at "../modules/iiif-manifest.xqm";

(: Exemple de chaîne JSON en entrée :)
let $json-string := '{
  "id": "https://example.org/iiif/collection1/manifest",
  "label": "Collection d''images",
  "summary": "Une collection d''images historiques",
  "metadata": {
    "Collection": "Archives historiques",
    "Date": "1900-1950",
    "Nombre d''images": "10"
  },
  "rights": "http://creativecommons.org/publicdomain/mark/1.0/",
  "items": [
    {
      "id": "https://example.org/iiif/collection1/canvas/img1",
      "label": "Image 1",
      "height": 1024,
      "width": 768,
      "items": {
        "body": {
          "id": "https://example.org/images/img1.jpg",
          "type": "Image",
          "format": "image/jpeg",
          "height": 1024,
          "width": 768
        }
      }
    },
    {
      "id": "https://example.org/iiif/collection1/canvas/img2",
      "label": "Image 2",
      "height": 1024,
      "width": 768,
      "items": {
        "body": {
          "id": "https://example.org/images/img2.jpg",
          "type": "Image",
          "format": "image/jpeg",
          "height": 1024,
          "width": 768
        }
      }
    }
  ]
}'

(: Parser le JSON en map :)
let $input := parse-json($json-string)

(: Génération du manifest :)
return iiif:create-manifest-json($input)
