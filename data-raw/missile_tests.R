# URL: https://www.nti.org/analysis/reports/cns-missile-and-slv-launch-databases/
#
# Date Obtained: 2020-01-11
#
# Citations:
# - created by The James Martin Center for Nonproliferation Studies for the Nuclear Threat Initiative

library(data.table)
library(lubridate)

file_urls <- c(
  dprk = "https://www.nti.org/documents/2137/north_korea_missile_test_database.xlsx",
  iran = "https://www.nti.org/documents/2203/iran_missile_launch_database.xlsx",
  india = "https://www.nti.org/documents/2474/india_missile_launch_database.xlsx",
  pakistan = "https://www.nti.org/documents/2473/pakistan_missile_launch_database.xlsx"
)


init <- lapply(file_urls, function(.x) {
  temp_file <- tempfile(fileext = ".xlsx")
  download.file(.x, destfile = temp_file)
  
  setDT(readxl::read_excel(temp_file, guess_max = Inf))
})

clean_col_names <- function(x) {
  standardized_names <- vapply(names(x), function(.x) fcase(.x == "EventID", "F1",
                               .x == "DateOccurred", "Date",
                               .x == "Date Entered/Updated", "Date Entered",
                               .x == "DateEntered", "Date Entered",
                               .x == "TimeOfTest", "Launch Time",
                               .x == "Confirmation", "Confirmation Status",
                               .x == "MissileName", "Missile Name",
                               .x == "MissileFamily", "Missile Family",
                               .x == "Launch Time (UTC)", "Launch Time",
                               .x == "Launch Agency/Authority", "Launch Authority",
                               .x == "LaunchAgency/Authority", "Launch Authority",
                               .x == "Source", "Sources",
                               .x == "Source(s)", "Sources",
                               .x == "FacilityName", "Facility Name",
                               .x == "FacilityLatitude", "Facility Latitude",
                               .x == "FacilityLongitude", "Facility Longitude",
                               .x == "DistanceTravelled", "Distance Travelled",
                               .x == "LandingLocation", "Landing Location",
                               .x == "TestOutcome", "Test Outcome",
                               .x == "AdditionalInformation", "Additional Information",
                               .x == "OperationalUse", "Operational Use",
                               default = .x),
         character(1L), USE.NAMES = FALSE)
  
  new_names <- gsub(" ", "_", gsub("\\(|\\)", "", tolower(standardized_names)))
  
  setnames(x, new_names)
}

combined <- rbindlist(lapply(init, clean_col_names), 
                      fill = TRUE, idcol = "country"
                      )[, -c("f1", "date_entered")
                        ]

# combine launch date and times
cleaned_times <- combined[, launch_time := as.POSIXct(ymd(date), hms(launch_time))
                          ][, -"date"]

chr_cols <- names(which(vapply(combined, is.character, logical(1L))))
na_vals <- c("Unknown", "Unknown (4)", "N/A")

# recode na_vals to `NA`
cleaned_nas <- copy(cleaned_times)[
  , (chr_cols) := lapply(.SD, function(.x) {
    fifelse(.x %chin% na_vals,
            NA_character_, .x)
    }),
  .SDcols = chr_cols
]

# recode logical columns to actually be logical
to_lgl_cols <- c(test_confirmed = "confirmation_status", 
                 test_successful = "test_outcome",
                 in_operational_use = "operational_use")
true_vals <- c("Confirmed", "Success", "Yes", "TRUE")
false_vals <- c("Unconfirmed", "Failure", "No", "FALSE")

cleaned_lgls <- setnames(copy(cleaned_nas), old = to_lgl_cols, new = names(to_lgl_cols))
to_lgl_cols <- to_lgl_cols[!to_lgl_cols == "operational_use"]

cleaned_lgls[
  , (names(to_lgl_cols)) := lapply(.SD, function(.x) {
    fcase(.x %chin% true_vals, TRUE,
          .x %chin% false_vals, FALSE)
  }),
  .SDcols = names(to_lgl_cols)
]

# clean distance columns to be doubles measured in kilometers
distance_cols <- c("apogee", "distance_travelled")
names(distance_cols) <- paste0(distance_cols, "_km")
cleaned_distances <- setnames(copy(cleaned_lgls), old = distance_cols,
                              new = names(distance_cols))

cleaned_distances[
  , (names(distance_cols)) := lapply(.SD, function(.x) {
    init <- trimws(gsub("km|,", "", .x))
    init[nchar(init) == 0L] <- NA
    as.double(init)
  }),
  .SDcols = names(distance_cols)
]

# split by country, drop cols that are all NA
split_by_country <- lapply(
  split(cleaned_distances, by = "country", keep.by = FALSE),
  function(.x) {
    n_na <- colSums(is.na(.x))
    cols_to_drop <- names(which(n_na == nrow(.x)))
    tibble::as_tibble(.x[, -..cols_to_drop])
  }
)


dprk_missile_tests_df <- split_by_country$dprk
iran_missile_tests_df <- split_by_country$iran
india_missile_tests_df <- split_by_country$india
pakistan_missile_tests_df <- split_by_country$pakistan

usethis::use_data(dprk_missile_tests_df, overwrite = TRUE)
usethis::use_data(iran_missile_tests_df, overwrite = TRUE)
usethis::use_data(india_missile_tests_df, overwrite = TRUE)
usethis::use_data(pakistan_missile_tests_df, overwrite = TRUE)


