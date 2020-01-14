#' @name bauer-sigacts
#' 
#' @title Iraq and Afghanistan SIGACTS FOIA'd by Vincent Bauer
#'
#' @description 
#' * `sigacts_afghanistan_df`
#'   + "This data source publishes over 600,000 reports of ‘significant activities’ in Afghanistan from January 2008 through December 2014 These data were declassified by CENTCOM in 2014 and include information on both insurgent and Coalition activity. While freely available, these data are not usable by in their original form. I walk through the process of converting the declassified PDF documents into a dataframe and make the final results available as an Excel file. I have converted the military grid reference system (MGRS) locations to latitude and longtitude."
#' * `sigacts_iraq_df`
#'   + "This data source publishes over 250,000 declassified reports of ‘significant activities’ in Iraq from January 2004 to July 2007. While freely available, these data are not usable by in their original form. I walk through the process of converting the declassified PDF documents into a dataframe and make the final results available as an Excel file. Unlike the data available for Afghanistan, these data do not include significant activities carried out by Coalition forces and are not geolocated."
#'   
#' @source \url{https://stanford.edu/~vbauer/data.html}
#' 
#' @examples 
#' # Afghanistan =========================================================================
#' sigacts_afghanistan_df
#' dplyr::glimpse(sigacts_afghanistan_df)
#' 
#' # Iraq ================================================================================ 
#' sigacts_iraq_df
#' dplyr::glimpse(sigacts_iraq_df)

#' @rdname bauer-sigacts
"sigacts_afghanistan_df"

#' @rdname bauer-sigacts
"sigacts_iraq_df"
