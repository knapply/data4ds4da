# URL: https://ucdp.uu.se/downloads/index.html#ged_global
#
# Date Obtained: 2020-01-10
#
# Citations:
# - Sundberg, Ralph, and Erik Melander, 2013, “Introducing the UCDP Georeferenced Event Dataset”, Journal of Peace Research, vol.50, no.4, 523-532
# - Högbladh Stina, 2019, “UCDP GED Codebook version 19.1”, Department of Peace and Conflict Research, Uppsala University
#

# URLs ===================================================================================
data_url <- "http://ucdp.uu.se/downloads/ged/ged_syria.csv.zip"
codebook_url <- "https://ucdp.uu.se/downloads/ged/ged191.pdf"

# get data ===============================================================================
temp_file <- tempfile()
target_dir <- "inst/datasets/ucdp_syria/"
download.file(data_url, destfile = temp_file)
unzip(temp_file, files = "ged_syria.csv", exdir = target_dir)

# get codebook ===========================================================================
download.file(codebook_url, destfile = paste0(target_dir, "ged191.pdf"))

# prep data ==============================================================================
data_file <- "inst/datasets/ucdp_syria/ged_syria.csv"

ucdp_syria_df <- tibble::as_tibble(readr::read_csv(data_file, guess_max = Inf))

# save data ==============================================================================
usethis::use_data(ucdp_syria_df, overwrite = TRUE)
