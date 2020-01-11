# URL: http://www.matthewfuhrmann.com/datasets.html
#
# Date Obtained: 2020-01-10
# Citations:
# - FFuhrmann, Matthew. 2012. Atomic Assistance: How "Atoms for Peace" Programs Cause Nuclear Insecurity. Ithaca, NY: Cornell University Press.

# URLs ===================================================================================
data_url <- "http://www.matthewfuhrmann.com/uploads/2/5/8/2/25820564/nca_dataset.dta"
codebook_url <- "http://www.matthewfuhrmann.com/uploads/2/5/8/2/25820564/nca_codebook.pdf"

# get data ===============================================================================
target_dir <- "inst/nca/"
download.file(data_url, destfile = paste0(target_dir, "nca_dataset.dta"))

# get codebook ===========================================================================
download.file(codebook_url, destfile = paste0(target_dir, "nca_codebook.pdf"))

# prep data ==============================================================================
data_file <- "inst/nca/nca_dataset.dta"

library(data.table)

nca_df <- setDT(haven::read_dta(data_file))

nca_df[, nca_type := fcase(
  nca_type == 1, "nuclear safety",
  nca_type == 2, "intangibles",
  nca_type == 3, "nuclear materials",
  nca_type == 4, "research",
  nca_type == 5, "comprehensive power, restricted",
  nca_type == 6, "comprehensive power, unrestricted",
  nca_type == 7, "military assistance"
)]

nca_df <- tibble::as_tibble(nca_df)

# save data ==============================================================================
usethis::use_data(nca_df, overwrite = TRUE)
