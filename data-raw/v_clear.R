# URL: https://williamspaniel.com/papers/nuclear/
#
# Date Obtained: 2020-01-21
#
# Citations: 
# - Smith, Bradley & Spaniel, William. (2018). Introducing ν -CLEAR: a latent variable approach to measuring nuclear proficiency. Conflict Management and Peace Science. 073889421774161. 10.1177/0738894217741619.


data_file <- "inst/datasets/v-CLEAR/nu_public_rep.csv"

# prep data ==============================================================================
library(data.table)
print.data.table <- function(x) print(tibble::as_tibble(x))

cow <- unique(
  setDT(states::cowstates[, c("cowcode", "country_name")])
)
setnames(cow, "cowcode", "ccode")


init <- fread(data_file)[, -"V1"]

stopifnot(
  all(init$ccode %in% cow$ccode)
)

recoded_countries <- copy(init
                          )[cow, on = "ccode", nomatch = 0
                            ]

int_to_lgl_cols <- setdiff(
  names(recoded_countries)[vapply(recoded_countries, is.integer, logical(1L))],
  c("ccode", "year", "ID")
)

recoded_lgl <- copy(recoded_countries
                    )[, (int_to_lgl_cols) := lapply(.SD, as.logical),
                      .SDcols = int_to_lgl_cols]

cols_to_keep <- c(
  id = "ID",
  ccode = "ccode", 
  country_name = "country_name",
  year = "year", 
  uranium_possession = "ura_i", 
  metallurgical_capability = "metal_i",
  chemical_capability = "chemi_i",
  nitric_production = "nitric_i",
  electricity_production = "elect_i", 
  nuclear_engineering = "nuke_i",
  explosive_production = "explo_i",
  non_heavy_water_reactor = "Non_HWR",
  heavy_water_reactor = "HWR",
  nuclear_test = "test",
  reprocessing = "reprocess",
  uranium_enrichment = "enrichment",
  submarines = "submarines",
  weapons_exploration = "explore",
  weapons_pursuit = "pursue",
  nuclear_weapons = "possession"
)

if (!all(good_cols_names <- cols_to_keep %in% names(recoded_lgl))) {
  print(cols_to_keep[!good_cols_names])
}


v_clear <- setnames(
  copy(recoded_lgl
       )[, ..cols_to_keep],
  names(cols_to_keep)
)

# fwrite(v_clear, "~/Desktop/v-CLEAR-cleaned.csv")

v_clear_df <- tibble::as_tibble(v_clear)

usethis::use_data(v_clear_df, overwrite = TRUE)
