# URL: 
#
# Date Obtained: 2020--
# Citations:
# - 

# URLs ===================================================================================
data_url <- 

# get data ===============================================================================
temp_file <- tempfile(fileext = )
download.file(data_url, destfile = temp_file)

# prep data ==============================================================================
library(data.table)

# save data ==============================================================================
usethis::use_data(, overwrite = TRUE)