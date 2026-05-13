# Copyright (c) 2026 Samuel Polat
#
# This work is licensed under the terms of the MIT license.
# For a copy, see LICENSE file.

library(readr)
library(dplyr)
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
      
      res$walkscore
    },
    otherwise = NA_integer_ # Valeur de remplacement en cas d'échec
  ),
  rate = rate_delay(1) # Délai d'une seconde entre chaque requête
)

# Exécuter la fonction pour chaque IME
scores <- map2(ime$latitude, ime$longitude, get_walkscore, .progress = TRUE)
