# URL: https://www.nti.org/analysis/articles/cns-north-korea-missile-test-database/
#
# Date Obtained: 2020-01-11
# Citations:
# - created by The James Martin Center for Nonproliferation Studies for the Nuclear Threat Initiative

# URLs ===================================================================================
data_url <- "https://www.nti.org/documents/2137/north_korea_missile_test_database.xlsx"

# get data ===============================================================================
target_dir <- "inst/datasets/north_korea_missile_test_database/"
data_file <- paste0(target_dir, "north_korea_missile_test_database.xlsx")

download.file(data_url, destfile = paste0(target_dir, "north_korea_missile_test_database.xlsx"))

# prep data ==============================================================================
library(data.table)

north_korea_missile_test_database <- setDT(readxl::read_excel(data_file, guess_max = Inf))
old_names <- c("F1", "Date", "Date Entered/Updated", "Launch Time (UTC)", 
               "Missile Name", "Missile Type", "Launch Agency/Authority", "Facility Name", 
               "Facility Location", "Other Name", "Facility Latitude", "Facility Longitude", 
               "Landing Location", "Apogee", "Distance Travelled", "Confirmation Status", 
               "Test Outcome", "Additional Information", "Source(s)")

clean_names <- function(x) {
  x[x == "Test Outcome"] <- "success"
  x[x == "Confirmation Status"] <- "confirmed"
  x[x == "Apogee"] <- "apogee_km"
  x[x == "Distance Travelled"] <- "distance_travelled_km"
  no_paren <- gsub("\\(|\\)", "", tolower(x))
  gsub("/|\\s+", "_", no_paren)
}

setnames(north_korea_missile_test_database,
         old = old_names,
         new = clean_names(old_names))


chr_cols <- names(north_korea_missile_test_database
                  )[vapply(north_korea_missile_test_database, is.character, logical(1L))]

distance_cols <- c("apogee_km", "distance_travelled_km")

lat_lng_cols <- c("facility_latitude", "facility_longitude")

north_korea_missile_test_database <- north_korea_missile_test_database[
  , -1
  ][, c("date", "date_entered_updated") := lapply(.SD, as.Date),
    .SDcols = c("date", "date_entered_updated")
    ][, (chr_cols) := lapply(.SD, function(.x) {
          .x[.x %chin% c("N/A", "Unknown")] <- NA_character_
          .x
        }),.SDcols = chr_cols
      ][, success := fifelse(success == "Success", 
                             TRUE, FALSE)
      ][, confirmed := fifelse(confirmed == "Confirmed", 
                               TRUE, FALSE)
        ][, (distance_cols) := lapply(.SD, 
                                      function(.x) as.double(gsub("km|,", "", .x))),
          .SDcols = distance_cols
        ][, (lat_lng_cols) := lapply(.SD, as.double),
          .SDcols = lat_lng_cols
          ]

dprk_missile_tests_df <- tibble::as_tibble(north_korea_missile_test_database)

# save data ==============================================================================
usethis::use_data(dprk_missile_tests_df, overwrite = TRUE)
