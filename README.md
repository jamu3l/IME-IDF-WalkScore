![GitHub last commit](https://img.shields.io/github/last-commit/jamu3l/IME-IDF-WalkScore?path=ime-idf-walkscore.csv&label=actualis%C3%A9&cacheSeconds=3600)

Ce jeu de données est un remix du jeu de données [_Localisation et caractéristiques des IME d'Île-de-France_](https://www.data.gouv.fr/datasets/localisation-et-caracteristiques-des-ime-dile-de-france) avec l'ajout de l'indice [Walk Score](https://www.walkscore.com/) pour chaque IME.

| Colonne     | Description                                     |
| ----------- | ----------------------------------------------- |
| `walkscore` | Score de marchabilité (0–100)                   |
| `ws_link`   | Lien vers la page Walk Score de l'établissement |

_Walk Score_ est une marque déposée de Walk Score Inc. [Données fournies par Redfin Real Estate.](https://www.redfin.com)

## Reproduire les scores

1. Créez un compte et demandez une clé API sur [walkscore.com/professional/api-sign-up.php](https://www.walkscore.com/professional/api-sign-up.php).

2. Ouvrez le fichier `.Renviron` dans le répertoire de travail du projet. Dans le terminal :

```r
usethis::edit_r_environ(scope = "project")
```

3. Ajoutez votre clé API comme suit, puis sauvegardez et redémarrez R :

```r
WALKSCORE_API_KEY=votre_clé_ici
```

4. Exécutez `score.R`. Le fichier `ime-idf-walkscore.csv` sera généré dans le répertoire du projet.

```r
source("score.R")
```

## Licence

Le code source `score.R` est distribué sous licence [MIT](LICENSE).

Le jeu de données `ime-idf-walkscore.csv` est distribué sous licence [CC BY 4.0](LICENSE-DATA). Il est dérivé du jeu de données [_Localisation et caractéristiques des IME d'Île-de-France_](https://www.data.gouv.fr/datasets/localisation-et-caracteristiques-des-ime-dile-de-france) de Yann Chambon, distribué sous [Licence Ouverte / Open Licence version 2.0](https://ia.numerique.gouv.fr/licence-ouverte-open-licence).
