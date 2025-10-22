xquery version "3.1";

(:~
 : Tests unitaires pour le module IIIF Manifest
 :
 : Ce fichier contient des tests pour vérifier le bon fonctionnement
 : des fonctions du module iiif-manifest.xqm
 :)

import module namespace iiif = "http://iiif.io/xquery/manifest" at "../modules/iiif-manifest.xqm";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";
declare option output:indent "yes";

(:~
 : Test helper pour afficher les résultats
 :)
declare function local:test($name as xs:string, $condition as xs:boolean) {
  if ($condition) then
    "✓ PASS: " || $name
  else
    "✗ FAIL: " || $name
};

(:~
 : Test 1: Création d'une language map simple
 :)
declare function local:test-language-map() {
  let $result := iiif:create-language-map("Test Label")
  return local:test(
    "Language map from string",
    map:contains($result, "none") and array:get(map:get($result, "none"), 1) = "Test Label"
  )
};

(:~
 : Test 2: Création d'une language map multilangue
 :)
declare function local:test-multilang-map() {
  let $input := map { "en": ["English"], "fr": ["Français"] }
  let $result := iiif:create-language-map($input)
  return local:test(
    "Language map multilingual",
    map:contains($result, "en") and map:contains($result, "fr")
  )
};

(:~
 : Test 3: Génération d'un manifest minimal
 :)
declare function local:test-minimal-manifest() {
  let $input := map {
    "id": "https://example.org/test/manifest",
    "label": "Test Manifest",
    "items": array {}
  }
  let $result := iiif:generate-manifest($input)
  return local:test(
    "Minimal manifest generation",
    map:get($result, "@context") = $iiif:context and
    map:get($result, "type") = "Manifest" and
    map:get($result, "id") = "https://example.org/test/manifest"
  )
};

(:~
 : Test 4: Création de métadonnées
 :)
declare function local:test-metadata() {
  let $input := map {
    "Author": "John Doe",
    "Date": "2025"
  }
  let $result := iiif:create-metadata-array($input)
  return local:test(
    "Metadata array creation",
    array:size($result) = 2
  )
};

(:~
 : Test 5: Création d'un canvas
 :)
declare function local:test-canvas() {
  let $input := map {
    "id": "https://example.org/canvas/1",
    "label": "Canvas 1",
    "height": 1000,
    "width": 800,
    "items": array {}
  }
  let $result := iiif:create-canvas($input)
  return local:test(
    "Canvas creation",
    map:get($result, "type") = "Canvas" and
    map:get($result, "height") = 1000 and
    map:get($result, "width") = 800
  )
};

(:~
 : Test 6: Création d'une annotation
 :)
declare function local:test-annotation() {
  let $canvas-id := "https://example.org/canvas/1"
  let $anno-data := map {
    "body": map {
      "id": "https://example.org/image.jpg",
      "type": "Image",
      "format": "image/jpeg"
    }
  }
  let $result := iiif:create-annotation($canvas-id, $anno-data, 1)
  return local:test(
    "Annotation creation",
    map:get($result, "type") = "Annotation" and
    map:get($result, "motivation") = "painting"
  )
};

(:~
 : Test 7: Création d'un provider
 :)
declare function local:test-provider() {
  let $input := map {
    "id": "https://example.org",
    "label": "Example Organization",
    "homepage": "https://example.org"
  }
  let $result := iiif:create-provider($input)
  return local:test(
    "Provider creation",
    array:size($result) = 1 and
    map:get(array:get($result, 1), "type") = "Agent"
  )
};

(:~
 : Test 8: Création d'un thumbnail
 :)
declare function local:test-thumbnail() {
  let $input := "https://example.org/thumb.jpg"
  let $result := iiif:create-thumbnail($input)
  return local:test(
    "Thumbnail from URL string",
    array:size($result) = 1 and
    map:get(array:get($result, 1), "type") = "Image"
  )
};

(:~
 : Test 9: Création d'un service d'image
 :)
declare function local:test-image-service() {
  let $input := map {
    "id": "https://example.org/iiif/image/1",
    "profile": "level2"
  }
  let $result := iiif:create-image-service($input)
  return local:test(
    "Image service creation",
    array:size($result) = 1 and
    map:get(array:get($result, 1), "type") = "ImageService3"
  )
};

(:~
 : Test 10: Manifest complet avec items
 :)
declare function local:test-complete-manifest() {
  let $input := map {
    "id": "https://example.org/manifest",
    "label": "Complete Test",
    "items": array {
      map {
        "id": "https://example.org/canvas/1",
        "label": "Page 1",
        "height": 1000,
        "width": 800,
        "items": map {
          "body": "https://example.org/image.jpg"
        }
      }
    }
  }
  let $result := iiif:generate-manifest($input)
  return local:test(
    "Complete manifest with canvas",
    array:size(map:get($result, "items")) = 1
  )
};

(:~
 : Test 11: Sérialisation JSON
 :)
declare function local:test-json-serialization() {
  let $input := map {
    "id": "https://example.org/manifest",
    "label": "Test",
    "items": array {}
  }
  let $json := iiif:create-manifest-json($input)
  return local:test(
    "JSON serialization",
    contains($json, "@context") and contains($json, "Manifest")
  )
};

(:~
 : Exécution de tous les tests
 :)
let $tests := (
  local:test-language-map(),
  local:test-multilang-map(),
  local:test-minimal-manifest(),
  local:test-metadata(),
  local:test-canvas(),
  local:test-annotation(),
  local:test-provider(),
  local:test-thumbnail(),
  local:test-image-service(),
  local:test-complete-manifest(),
  local:test-json-serialization()
)

let $passed := count($tests[starts-with(., "✓")])
let $failed := count($tests[starts-with(., "✗")])

return string-join((
  "=" || string-join(for $i in 1 to 60 return "=", "") || "=",
  "  Tests du module IIIF Manifest",
  "=" || string-join(for $i in 1 to 60 return "=", "") || "=",
  "",
  $tests,
  "",
  "=" || string-join(for $i in 1 to 60 return "=", "") || "=",
  "  Résultats: " || $passed || " passés, " || $failed || " échoués sur " || count($tests) || " tests",
  "=" || string-join(for $i in 1 to 60 return "=", "") || "=",
  ""
), "&#10;")
