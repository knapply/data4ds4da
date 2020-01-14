# URL: https://stanford.edu/~vbauer/data.html
#
# Date Obtained: 2020-01-14
# Citations:
# - 

library(data.table)
read_excel <- readxl::read_excel
str_count <- stringr::str_count
str_extract <- stringr::str_extract
str_remove <- stringr::str_remove
str_remove_all <- stringr::str_remove_all
as_tibble <- tibble::as_tibble


# URLs ===================================================================================
file_urls <- c(
  afghanistan = "https://stanford.edu/~vbauer/files/data/sigacts/AfgSigacts.xlsx",
  iraq = "https://stanford.edu/~vbauer/files/data/sigacts/IraqSigacts.xlsx"
)

# get data ===============================================================================
init <- lapply(file_urls, function(.x) {
  temp_file <- tempfile(fileext = ".xlsx")
  download.file(.x, destfile = temp_file)
  # Iraq file has "DateOccurred" in row 41858, which prevents proper type guessing
  setDT(read_excel(temp_file, na = "DateOccurred", guess_max = Inf))
})


# prep data ==============================================================================
clean_col_names <- function(x) {
  standardized_names <- vapply(
    names(x), function(.x) {
      fcase(.x == "...1", "Field1",
            .x %chin% c("type", "PrimaryEventType"), "event_type",
            .x == "PrimaryEventCategroy", "event_category",
            .x == "DDLat", "lat",
            .x == "DDLon", "lon",
            .x %chin% c("date", "DateOccurred", "...6"), "time",
            default = .x)
      },
    character(1L), USE.NAMES = FALSE
  )
  
  new_names <- gsub(" ", "_", gsub("\\(|\\)", "", tolower(standardized_names)))
  
  setnames(x, new_names)
}


cleaned_names <- lapply(
  init,
  function(.x) clean_col_names(copy(.x))[, -"field1"]
)


cleaned_nas <- lapply(cleaned_names, function(.x) {
  chr_cols <- names(which(vapply(.x, is.character, logical(1L))))
  
  na_vals <- c("NA", "Unknown", "None")
  
  out <- copy(.x)[
    , (chr_cols) := lapply(.SD, function(.y) {
      fifelse(.y %chin% na_vals, NA_character_, .y)
      }),
    .SDcols = chr_cols
  ]
  
  out
})


clean_mgrs <- function(mgrs) {
  is_odd_length_easting_northing <- function(x) {
    easting_northing <- str_extract(x, "\\d+$")
    easting_northing_digit_count <- str_count(easting_northing, "\\d")
    remainder_of_division_by_two <- easting_northing_digit_count %% 2
    
    remainder_of_division_by_two != 0
  }
  
  truncate_mgrs <- function(mgrs) {
    str_remove(string = mgrs, pattern = "\\d(?=$)")
  }
  
  fifelse(is_odd_length_easting_northing(str_remove_all(mgrs, "\\s+")),
          truncate_mgrs(mgrs),
          mgrs)
}


cleaned_mgrs <- lapply(cleaned_nas, function(.x) {
  if ("mgrs" %chin% names(.x)) {
    .x[, mgrs := clean_mgrs(mgrs)]
  }
  .x
}) 


finished <- lapply(cleaned_mgrs, function(.x) {
  priority_cols <- c("time", "event_type", "event_category",
                     "target", "city", "mgrs", "lat", "lon")
  cols_to_keep <- intersect(priority_cols, names(.x))
    
  .x[!is.na(event_type), ..cols_to_keep]
})


# save data ==============================================================================
sigacts_iraq_df <- as_tibble(finished$iraq)
sigacts_afghanistan_df <- as_tibble(finished$afghanistan)

usethis::use_data(sigacts_iraq_df, overwrite = TRUE)
usethis::use_data(sigacts_afghanistan_df, overwrite = TRUE)
