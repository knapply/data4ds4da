# URL: http://www.matthewfuhrmann.com/datasets.html
#
# Date Obtained: 2020-01-10
# Citations:
# - Fuhrmann, Matthew and Benjamin Tkach. 2015. "Almost Nuclear: Introducing the Nuclear Latency Dataset." Conflict Management and Peace Science 32 (4): 443-461.

# URLs ===================================================================================
data_url <- "http://www.matthewfuhrmann.com/uploads/2/5/8/2/25820564/nl_dataset_v.1.2.xlsx"
codebook_url <- "http://www.matthewfuhrmann.com/uploads/2/5/8/2/25820564/nl_dataset_-_codebook_2015-1215.pdf"

# get data ===============================================================================
target_dir <- "inst/nl/"
download.file(data_url, destfile = paste0(target_dir, "nl_dataset_v.1.2.xlsx"))

# get codebook ===========================================================================
download.file(codebook_url, destfile = paste0(target_dir, "nl_dataset_-_codebook_2015-1215.pdf"))

# prep data ==============================================================================
data_file <- "inst/nl/nl_dataset_v.1.2.xlsx"

library(data.table)
nl_1.2_df <- setDT(readxl::read_excel(data_file, guess_max = Inf))

start_end_cols <- c(
  "construction_start", "construction_end", "operation_start", "operation_end",
  "operation2_start", "operation2_end"
)

nl_1.2_df[
  , facility_ambiguity := fcase(facility_ambiguity == 0, FALSE,
                                facility_ambiguity == 1, TRUE,
                                facility_ambiguity == 77, NA)
  ][, enr_type := fcase(enr_type == 1, "reprocessing",
                        enr_type == 2, "gaseous diffusion",
                        enr_type == 3, "centrifuge",
                        enr_type == 4, "EMIS",
                        enr_type == 5, "chemical and ion exchange",
                        enr_type == 6, "aerodynamic isotope separation",
                        enr_type == 7, "laser",
                        enr_type == 8, "thermal diffusion")
    ][, size := fcase(size == 1, "laboratory",
                      size == 2, "pilot",
                      size == 3, "commercial")
      ][, (start_end_cols) := lapply(.SD, 
                                     function(.x) {
                                       if (is.character(.x)) {
                                         suppressWarnings(
                                           .x <- as.double(.x)
                                         )
                                       }
                                       fifelse(.x %in% c(9999, 7777),
                                               NA_real_,
                                               .x)
                                     }),
        .SDcols = start_end_cols
        ][, covert := fcase(covert == 0, FALSE,
                            covert == 1, TRUE,
                            covert == 3, NA)
          ][, iaea := fcase(iaea == 0, FALSE,
                            iaea == 1, TRUE,
                            iaea == -99, NA)
            ][, regional := fcase(regional == 0, FALSE,
                                  regional == 1, FALSE,
                                  regional == -99, NA)
              ][, military := fcase(military == 0, FALSE,
                                    military == 1, TRUE,
                                    military == -99, NA)
                ][, military_ambiguity := fcase(military_ambiguity == 0, FALSE,
                                                military_ambiguity == 1, TRUE)
                  ][, multinational := fcase(multinational == 0, FALSE,
                                             multinational == 1, TRUE)
                    ][, foreign_assistance := fcase(foreign_assistance == 0, FALSE,
                                                    foreign_assistance == 1, TRUE,
                                                    foreign_assistance == -99, NA)
                      ][, foreign_assistance_ambiguity := fcase(foreign_assistance_ambiguity == 0, FALSE,
                                                                foreign_assistance_ambiguity == 1, TRUE)
                        ]

nl_1.2_df <- tibble::as_tibble(nl_1.2_df)

# save data ==============================================================================
usethis::use_data(nl_1.2_df, overwrite = TRUE)

