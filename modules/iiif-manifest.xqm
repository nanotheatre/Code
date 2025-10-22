xquery version "3.1";

(:~
 : Module pour la génération de manifests IIIF v3 à partir de JSON
 :
 : Ce module fournit des fonctions pour créer des manifests IIIF Presentation API 3.0
 : conformes à la spécification officielle.
 :
 : @author Claude Code
 : @version 1.0
 : @see https://iiif.io/api/presentation/3.0/
 :)

module namespace iiif = "http://iiif.io/xquery/manifest";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace array = "http://www.w3.org/2005/xpath-functions/array";

(:~
 : Contexte IIIF Presentation API v3
 :)
declare variable $iiif:context := "http://iiif.io/api/presentation/3/context.json";

(:~
 : Génère un manifest IIIF v3 complet à partir de données JSON
 :
 : @param $input-json les données JSON d'entrée contenant les métadonnées et ressources
 : @return le manifest IIIF v3 au format JSON (map)
 :)
declare function iiif:generate-manifest($input-json as map(*)) as map(*) {
  let $manifest-id := map:get($input-json, "id")
  let $label := map:get($input-json, "label")
  let $metadata := map:get($input-json, "metadata")
  let $summary := map:get($input-json, "summary")
  let $items := map:get($input-json, "items")

  return map:merge((
    map { "@context": $iiif:context },
    map { "id": $manifest-id },
    map { "type": "Manifest" },

    (: Label (obligatoire) :)
    if (exists($label)) then
      map { "label": iiif:create-language-map($label) }
    else
      map { "label": map { "none": ["Sans titre"] } },

    (: Métadonnées (optionnel) :)
    if (exists($metadata)) then
      map { "metadata": iiif:create-metadata-array($metadata) }
    else (),

    (: Summary (optionnel) :)
    if (exists($summary)) then
      map { "summary": iiif:create-language-map($summary) }
    else (),

    (: Thumbnail (optionnel) :)
    if (map:contains($input-json, "thumbnail")) then
      map { "thumbnail": iiif:create-thumbnail(map:get($input-json, "thumbnail")) }
    else (),

    (: Rights (optionnel) :)
    if (map:contains($input-json, "rights")) then
      map { "rights": map:get($input-json, "rights") }
    else (),

    (: Provider (optionnel) :)
    if (map:contains($input-json, "provider")) then
      map { "provider": iiif:create-provider(map:get($input-json, "provider")) }
    else (),

    (: Homepage (optionnel) :)
    if (map:contains($input-json, "homepage")) then
      map { "homepage": iiif:create-homepage(map:get($input-json, "homepage")) }
    else (),

    (: Items (canvases) - obligatoire :)
    if (exists($items)) then
      map { "items": iiif:create-canvas-items($items) }
    else
      map { "items": [] }
  ))
};

(:~
 : Crée un objet language map conforme IIIF
 :
 : @param $label peut être une string simple ou un map avec codes de langue
 : @return un map conforme au format IIIF language map
 :)
declare function iiif:create-language-map($label as item()*) as map(*) {
  if ($label instance of map(*)) then
    $label
  else if ($label instance of xs:string) then
    map { "none": [$label] }
  else if ($label instance of array(*)) then
    map { "none": $label }
  else
    map { "none": [string($label)] }
};

(:~
 : Crée un tableau de métadonnées IIIF
 :
 : @param $metadata array ou map de métadonnées
 : @return un array de maps avec label et value
 :)
declare function iiif:create-metadata-array($metadata as item()*) as array(*) {
  if ($metadata instance of array(*)) then
    $metadata
  else if ($metadata instance of map(*)) then
    array {
      for $key in map:keys($metadata)
      return map {
        "label": iiif:create-language-map($key),
        "value": iiif:create-language-map(map:get($metadata, $key))
      }
    }
  else
    []
};

(:~
 : Crée un objet thumbnail IIIF
 :
 : @param $thumbnail-data données du thumbnail (URL ou map)
 : @return un array contenant l'objet thumbnail
 :)
declare function iiif:create-thumbnail($thumbnail-data as item()*) as array(*) {
  if ($thumbnail-data instance of xs:string) then
    array {
      map {
        "id": $thumbnail-data,
        "type": "Image"
      }
    }
  else if ($thumbnail-data instance of map(*)) then
    array { $thumbnail-data }
  else if ($thumbnail-data instance of array(*)) then
    $thumbnail-data
  else
    []
};

(:~
 : Crée un objet provider IIIF
 :
 : @param $provider-data données du provider
 : @return un array contenant l'objet provider
 :)
declare function iiif:create-provider($provider-data as item()*) as array(*) {
  if ($provider-data instance of array(*)) then
    $provider-data
  else if ($provider-data instance of map(*)) then
    array {
      map:merge((
        map { "id": map:get($provider-data, "id") },
        map { "type": "Agent" },
        if (map:contains($provider-data, "label")) then
          map { "label": iiif:create-language-map(map:get($provider-data, "label")) }
        else (),
        if (map:contains($provider-data, "homepage")) then
          map { "homepage": iiif:create-homepage(map:get($provider-data, "homepage")) }
        else (),
        if (map:contains($provider-data, "logo")) then
          map { "logo": iiif:create-thumbnail(map:get($provider-data, "logo")) }
        else ()
      ))
    }
  else
    []
};

(:~
 : Crée un objet homepage IIIF
 :
 : @param $homepage-data données de la homepage
 : @return un array contenant l'objet homepage
 :)
declare function iiif:create-homepage($homepage-data as item()*) as array(*) {
  if ($homepage-data instance of xs:string) then
    array {
      map {
        "id": $homepage-data,
        "type": "Text",
        "format": "text/html"
      }
    }
  else if ($homepage-data instance of array(*)) then
    $homepage-data
  else if ($homepage-data instance of map(*)) then
    array { $homepage-data }
  else
    []
};

(:~
 : Crée les items (canvases) du manifest
 :
 : @param $items-data array de données pour les canvases
 : @return un array de canvases IIIF
 :)
declare function iiif:create-canvas-items($items-data as item()*) as array(*) {
  if ($items-data instance of array(*)) then
    array {
      for $item in array:flatten($items-data)
      return iiif:create-canvas($item)
    }
  else
    []
};

(:~
 : Crée un canvas IIIF
 :
 : @param $canvas-data map contenant les données du canvas
 : @return un map représentant un canvas IIIF
 :)
declare function iiif:create-canvas($canvas-data as map(*)) as map(*) {
  let $canvas-id := map:get($canvas-data, "id")
  let $label := map:get($canvas-data, "label")
  let $height := map:get($canvas-data, "height")
  let $width := map:get($canvas-data, "width")
  let $items := map:get($canvas-data, "items")

  return map:merge((
    map { "id": $canvas-id },
    map { "type": "Canvas" },

    if (exists($label)) then
      map { "label": iiif:create-language-map($label) }
    else
      map { "label": map { "none": ["Canvas"] } },

    if (exists($height)) then
      map { "height": xs:integer($height) }
    else (),

    if (exists($width)) then
      map { "width": xs:integer($width) }
    else (),

    (: Annotation pages :)
    if (exists($items)) then
      map { "items": iiif:create-annotation-pages($canvas-id, $items) }
    else
      map { "items": [] }
  ))
};

(:~
 : Crée les annotation pages d'un canvas
 :
 : @param $canvas-id l'ID du canvas parent
 : @param $items-data les données des annotations
 : @return un array d'annotation pages
 :)
declare function iiif:create-annotation-pages($canvas-id as xs:string, $items-data as item()*) as array(*) {
  if ($items-data instance of array(*)) then
    $items-data
  else
    array {
      map {
        "id": $canvas-id || "/page/1",
        "type": "AnnotationPage",
        "items": iiif:create-annotations($canvas-id, $items-data)
      }
    }
};

(:~
 : Crée les annotations (images) d'un canvas
 :
 : @param $canvas-id l'ID du canvas parent
 : @param $annotation-data les données des annotations
 : @return un array d'annotations
 :)
declare function iiif:create-annotations($canvas-id as xs:string, $annotation-data as item()*) as array(*) {
  if ($annotation-data instance of array(*)) then
    array {
      for $anno at $pos in array:flatten($annotation-data)
      return iiif:create-annotation($canvas-id, $anno, $pos)
    }
  else if ($annotation-data instance of map(*)) then
    array { iiif:create-annotation($canvas-id, $annotation-data, 1) }
  else
    []
};

(:~
 : Crée une annotation IIIF (généralement pour une image)
 :
 : @param $canvas-id l'ID du canvas parent
 : @param $anno-data les données de l'annotation
 : @param $position la position de l'annotation
 : @return un map représentant une annotation
 :)
declare function iiif:create-annotation($canvas-id as xs:string, $anno-data as map(*), $position as xs:integer) as map(*) {
  let $anno-id :=
    if (map:contains($anno-data, "id")) then
      map:get($anno-data, "id")
    else
      $canvas-id || "/annotation/" || $position

  let $body-data := map:get($anno-data, "body")

  return map {
    "id": $anno-id,
    "type": "Annotation",
    "motivation":
      if (map:contains($anno-data, "motivation")) then
        map:get($anno-data, "motivation")
      else
        "painting",
    "body": iiif:create-annotation-body($body-data),
    "target":
      if (map:contains($anno-data, "target")) then
        map:get($anno-data, "target")
      else
        $canvas-id
  }
};

(:~
 : Crée le corps d'une annotation (généralement une image)
 :
 : @param $body-data les données du corps de l'annotation
 : @return un map représentant le corps de l'annotation
 :)
declare function iiif:create-annotation-body($body-data as item()*) as map(*) {
  if ($body-data instance of xs:string) then
    map {
      "id": $body-data,
      "type": "Image",
      "format": "image/jpeg"
    }
  else if ($body-data instance of map(*)) then
    map:merge((
      map { "id": map:get($body-data, "id") },
      map {
        "type":
          if (map:contains($body-data, "type")) then
            map:get($body-data, "type")
          else
            "Image"
      },
      if (map:contains($body-data, "format")) then
        map { "format": map:get($body-data, "format") }
      else (),
      if (map:contains($body-data, "height")) then
        map { "height": xs:integer(map:get($body-data, "height")) }
      else (),
      if (map:contains($body-data, "width")) then
        map { "width": xs:integer(map:get($body-data, "width")) }
      else (),
      if (map:contains($body-data, "service")) then
        map { "service": iiif:create-image-service(map:get($body-data, "service")) }
      else ()
    ))
  else
    map { "id": "", "type": "Image" }
};

(:~
 : Crée un service IIIF Image API
 :
 : @param $service-data les données du service
 : @return un array contenant le(s) service(s)
 :)
declare function iiif:create-image-service($service-data as item()*) as array(*) {
  if ($service-data instance of array(*)) then
    $service-data
  else if ($service-data instance of map(*)) then
    array {
      map:merge((
        map { "id": map:get($service-data, "id") },
        map { "type": "ImageService3" },
        map { "profile":
          if (map:contains($service-data, "profile")) then
            map:get($service-data, "profile")
          else
            "level2"
        }
      ))
    }
  else
    []
};

(:~
 : Sérialise un manifest en JSON
 :
 : @param $manifest le manifest sous forme de map
 : @return la chaîne JSON
 :)
declare function iiif:serialize-to-json($manifest as map(*)) as xs:string {
  serialize($manifest, map { "method": "json", "indent": true })
};

(:~
 : Fonction principale : génère un manifest IIIF v3 et le sérialise en JSON
 :
 : @param $input-json les données JSON d'entrée
 : @return la chaîne JSON du manifest IIIF v3
 :)
declare function iiif:create-manifest-json($input-json as map(*)) as xs:string {
  let $manifest := iiif:generate-manifest($input-json)
  return iiif:serialize-to-json($manifest)
};
