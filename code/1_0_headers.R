#===============================================================================
# Packages 
#===============================================================================

PACKAGES <- c("dplyr", "tidyverse", "haven", "DT", "data.table", "arrow", "xtable") 
inst <- match(PACKAGES, .packages(all=TRUE))
need <- which(is.na(inst))
repos = "https://nexus.insee.fr/repository/r-cran/" 
if (length(need) > 0) install.packages(PACKAGES[need], repos = repos) # installation à partir du miroir du Cran à l'Insee

lapply(PACKAGES, library, character.only=T)
