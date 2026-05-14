# Copyright (c) 2026 Samuel Polat
#
# This work is licensed under the terms of the MIT license.
# For a copy, see LICENSE file.

library(readr)
library(dplyr)
library(stringr)
library(purrr)
library(httr2)

# Importer jeu de données
ime <- read_csv("ime-idf-geocod-tri.csv") %>%
  # Ne conserver que les lignes contenant des coordonnées valides
  filter(!is.na(latitude), !is.na(longitude))

# Fonction pour récupérer le WalkScore via l'API Score
# Inclut une gestion des erreurs et un délai entre les requêtes
get_walkscore <- slowly(
  safely(
    function(lat, lon) {
      # Requête à l'API
      res <- request("https://api.walkscore.com/score") %>%
        req_url_query(
          format = "json",
          lat = lat,
          lon = lon,
          wsapikey = Sys.getenv("WALKSCORE_API_KEY")
        ) %>%
        req_perform() %>%
        resp_body_json()
      
      # Extraire les données pertinentes de la réponse API
      list(
        walkscore = res$walkscore %||% NA_integer_,
        ws_link   = res$ws_link   %||% NA_character_
      )
    },
    otherwise = list(walkscore = NA_integer_, ws_link = NA_character_) # Valeur de remplacement en cas d'échec
  ),
  rate = rate_delay(1) # Délai d'une seconde entre chaque requête
)

# Exécuter la fonction pour chaque IME
scores <- map2(ime$latitude, ime$longitude, get_walkscore, .progress = TRUE)

# Ajouter le score à chaque ligne du jeu de données
ime <- ime %>%
  bind_cols(map_dfr(scores, \(x) x$result)) %>%
  # Supprimer paramètres UTM
  mutate(ws_link = str_remove(ws_link, "\\?.*$"))

# Exporter le jeu de données avec le walkscore
write_csv(ime, "ime-idf-walkscore.csv")