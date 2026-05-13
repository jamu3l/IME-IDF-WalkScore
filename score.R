# Copyright (c) 2026 Samuel Polat

library(readr)
library(dplyr)
library(httr2)

# Importer jeu de données
ime <- read_csv("ime-idf-geocod-tri.csv") %>%
  # Ne conserver que les lignes contenant des coordonnées valides
  filter(!is.na(latitude), !is.na(longitude))

# Fonction pour obtenir le Walkscore d'un lieu spécifique
get_walkscore <- function(lat, lon) {
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
}