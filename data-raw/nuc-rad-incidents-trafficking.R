# URL: https://www.nti.org/analysis/articles/cns-global-incidents-and-trafficking-database/
#
# Date Obtained: 2020-0115-
# Citations:
# - created by The James Martin Center for Nonproliferation Studies for the Nuclear Threat Initiative

# URLs ===================================================================================
data_url <- "https://www.nti.org/documents/2096/global_incidents_and_trafficking.xlsm"

# get data ===============================================================================
temp_file <- tempfile(fileext = ".xlsm")
download.file(data_url, destfile = temp_file)

# prep data ==============================================================================
library(data.table)
library(stringr)

init <- setDT(readxl::read_excel(temp_file, sheet = "Full Database"))

setnames(
  init,
  tolower(gsub("\\?", "", gsub("(\\s|/|,|-)+", "_", names(init))))
)


filtered <- init[
  !is.na(date_occurred), 
  -"date_input_updated"
]

chr_cols <- names(which(vapply(filtered, is.character, logical(1L))))
na_vals <- c("Unknown", "unknown", "N/A", "n/a")

filtered[
  , (chr_cols) := lapply(.SD, function(.x) {
    .x
    fifelse(.x %chin% na_vals, NA_character_, .x)
  }),
  .SDcols = chr_cols
]

notes_added <- copy(filtered)[
  , while_moving := fcase(
    str_detect(in_transport, "movement/transit"), TRUE,
    str_detect(in_transport, "stationary/[Ii]dle"), FALSE
  )
  ][, recovery_type := fcase(
    recovered == "Seizure", "seized",
    recovered %chin% c("Officially Recovered", "Officially recovered"), "official",
    recovered == "Accidental find", "accidental find"
  )]


lgl_cols <- c("recovered", "in_transport",
              "if_stolen_attended_unattended", "device_involved")

recoded_lgls <- copy(filtered)[
  , (lgl_cols) := lapply(.SD, function(.x) {
    fifelse(.x == "")
  })
]



# save data ==============================================================================
usethis::use_data(, overwrite = TRUE)


