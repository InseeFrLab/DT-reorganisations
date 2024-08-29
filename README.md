# Reorganizing global supply-chains: Who, What, How, and Where?

Codes pour répliquer les résultats du Document de travail n 2024-XXX "Reorganizing global supply-chains: Who, What, How, and Where", par Gabriel Baratte, Raphaël Lafrogne-Joussier, Lionel Fontagné

## Données
- Données confidentielles accessibles via une demande au comité du secret:
  - Enquête CAM 2020 (Insee) ([Description](https://www.insee.fr/fr/metadonnees/source/operation/s2038/presentation))
  - Statistiques annuelles d'entreprises Ésane-FARE (Insee) ([Description](https://www.insee.fr/fr/metadonnees/source/serie/s1188), [Données](https://www.casd.eu/source/statistique-structurelle-annuelle-dentreprises-issue-du-dispositif-esane/))
  - Base tous salariés (anciennement DADS, Insee) ([Description](https://www.insee.fr/fr/metadonnees/source/serie/s1998), [Données](https://www.casd.eu/source/base-tous-salaries-fichier-etablissements/))
  - Contour des entreprises profilées (Insee) ([Données](https://www.casd.eu/source/contour-des-entreprises-profilees/))
- Répertoire d'entreprises SIRUS, indisponible via le comité du secret ([Description](https://www.insee.fr/fr/metadonnees/source/serie/s1024))
- Données publiques:
  - Distances et PIB par habitant issus de la base Gravity du CEPII ([Description et données](https://www.cepii.fr/CEPII/fr/bdd_modele/bdd_modele_item.asp?id=8))
  - Indices de tâches routinières de Le Barbanchon et Rizzotti 2020 ([Github avec les données](https://github.com/tlebarbanchon/occupations), [Papier](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3653262))


## Utilisation
Pour reproduire les résultats du document de travail:
- Ouvrir le projet `reorganisations_replication_package.Rproj` dans `Rstudio`
- Installer les librairies spécifiées dans le fichier `DESCRIPTION.md`:
```R
remotes::install_deps(".")
```

- Copier-coller le code ci-dessous dans un fichier `.Renviron`, en remplissant entre les guillemets les chemins vers les dossiers contenant les différentes données:
```
## Data paths
cam_path <- ""
fare_path <- ""
dads_path <- ""
contour_path <- ""
sirus_path <- ""
gravity_path <- ""
## Path to store working data
data_path <- ""
## Path where the code folder is
global_path <- "" 
## Path where to store results
output_path <- "" 

```
- Copier-coller le code ci-dessous dans un fichier `_stata_setup.do`, avec les mêmes chemins que ceux spécifiés dans le `R.environ`, et l'exécuter:
```
# Path with the working data
global data_path ""
# Path of the code folder
global code_path ""
# Path to store results
global output_path ""

```
- Exécuter `0_master.R` pour créer les fichiers de données et les tables descriptives (Tables 1 à 4)
- Avec Stata, exécuter `0_master.do` pour construire les fichiers de régressions et tous les résultats du papier (Figures 1 à 3, Tables 5 à 8, S2 à S6).

- Le code qui historicise les entreprises profilées est `1_6_1_build_contour_17.R`.