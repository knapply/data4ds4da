#' UCDP Georeferenced Event Dataset (GED) Syria 20160101-20191130 (652.1601.1911)
#'
#' This dataset contains georeferenced events data for Syria, covering 20160101-20191130. The dataset includes the same variables as the UCDP GED Global 19.1 dataset, and the same Codebook applies to both datasets. 
#' In contrast to UCDP GED Global 19.1, this dataset includes all clear events, meaning that dyads do not have to pass the threshold of 25 battle-related deaths during one calendar year, to be included (see the UCDP GED Codebook for definitions and more information on events, dyads, and the 25 threshold).
#'
#' @source \url{https://ucdp.uu.se/downloads/index.html#ged_global/}
#' 
#' @references 
#' * Sundberg, Ralph, and Erik Melander, 2013, “Introducing the UCDP Georeferenced Event Dataset”, Journal of Peace Research, vol.50, no.4, 523-532
#' * Högbladh Stina, 2019, “UCDP GED Codebook version 19.1”, Department of Peace and Conflict Research, Uppsala University
#' 
#' @examples 
#' ucdp_syria_df
#' dplyr::glimpse(ucdp_syria_df)
#' 
"ucdp_syria_df"
