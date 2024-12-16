# Reorganizing global supply-chains: Who, What, How, and Where?

[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/InseeFrLab/DT-reorganisations/blob/main/README.md)
[![fr](https://img.shields.io/badge/lang-fr-green.svg)](https://github.com/InseeFrLab/DT-reorganisations/blob/main/README.fr.md)

Codes to replicate the results of [Working Paper n 2024-24 ‘Reorganisation of global supply chains: who, what, how and where’](https://www.insee.fr/fr/statistiques/8286407), by Gabriel Baratte, Raphaël Lafrogne-Joussier, Lionel Fontagné

## Data
- Confidential data accessible on the [CASD](https://www.casd.eu/en/) via a request to the [secrecy committee](https://www.comite-du-secret.fr/home/):
  - CAM 2020 survey (Insee) ([Description](https://www.insee.fr/fr/metadonnees/source/operation/s2038/presentation))
  - Annual business statistics Ésane-FARE (Insee) ([Description](https://www.insee.fr/fr/metadonnees/source/serie/s1188), [Data](https://www.casd.eu/source/statistique-structurelle-annuelle-dentreprises-issue-du-dispositif-esane/))
  - Base tous salariés (formerly DADS, Insee) ([Description](https://www.insee.fr/fr/metadonnees/source/serie/s1998), [Data](https://www.casd.eu/source/base-tous-salaries-fichier-etablissements/))
  - Contour of profiled companies (Insee) ([Data](https://www.casd.eu/source/contour-des-entreprises-profilees/))
- SIRUS business directory, unavailable via the secrecy committee ([Description](https://www.insee.fr/fr/metadonnees/source/serie/s1024))
- Public data:
  - Distances and GDP per capita from CEPII's Gravity database ([Description and data](https://www.cepii.fr/CEPII/fr/bdd_modele/bdd_modele_item.asp?id=8))
  - Indices of routine tasks from Le Barbanchon and Rizzotti 2020 ([Github with data](https://github.com/tlebarbanchon/occupations), [Paper](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3653262))


## Use
To reproduce the results of the working paper
- Open the project `reorganisations_replication_package.Rproj` in `Rstudio`.
- Install the libraries specified in the `DESCRIPTION.md` file:
```R
remotes::install_deps(".")
```

- Copy and paste the code below into a `.Renviron' file, enclosing the paths to the folders containing the various data in inverted commas:
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
- Copy and paste the code below into a `_stata_setup.do` file, with the same paths as specified in the `R.environ`, and run it:
```
# Path with the working data
global data_path ""
# Path of the code folder
global code_path ""
# Path to store results
global output_path ""

```
- Run `0_master.R` to create the data files and descriptive tables (Tables 2 to 5)
- With Stata, run `0_master.do` to build the regression files and all the results of the paper (Figures 1 to 3, Tables 6 to 9, S2 to S6).

- The code that historicises the profiled companies is `1_6_1_build_contour_17.R`.
