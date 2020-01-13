#' @name cns-missile-test-databases
#' 
#' @title The CNS Missile and SLV Launch Databases
#'
#' @description 
#' * `dprk_missile_tests_df`
#'   + The James Martin Center for Nonproliferation Studies (CNS) North Korea Missile Test Database is the first database to record flight tests of all missiles launched by North Korea capable of delivering a payload of at least 500 kilograms (1102.31 pounds) a distance of at least 300 kilometers (186.4 miles). The database captures advancements in North Korea's missile program by documenting all such tests since the first one occurred in April 1984, and will be routinely updated as events warrant.
#' * `iran_missile_tests_df`
#'   + The James Martin Center for Nonproliferation Studies Iran Missile and SLV Launch Database records flight tests and operational uses of all missiles and SLVs launched by Iran that are capable of delivering a payload of at least 500 kilograms (1102.31 pounds) a distance of at least 300 kilometers (186.4 miles). The database captures advancements in Iran’s rocket programs by documenting all such launches by Iran since the end of the Iran-Iraq War in 1988. The database will be routinely updated as events warrant.
#' * `india_missile_tests_df` and `pakistan_missile_tests_df`
#'   + The James Martin Center for Nonproliferation Studies (CNS) India and Pakistan Missile Launch Databases record flight tests of all missiles launched by India and Pakistan, as well as space launch vehicles (SLVs) tested by India, that are capable of delivering a payload of at least 500 kilograms (1102.31 pounds) or traveling a distance of at least 300 kilometers (186.4 miles). The database captures advancements in both countries’ rocket programs by documenting all such launches carried out by India and Pakistan. The database will be routinely updated as events warrant.
#'
#' @source \url{https://www.nti.org/analysis/reports/cns-missile-and-slv-launch-databases/}
#' 
#' @references 
#' * Created by The James Martin Center for Nonproliferation Studies for the Nuclear Threat Initiative
#' 
#' @examples 
#' dprk_missile_tests_df
#' dplyr::glimpse(dprk_missile_tests_df)
#' 
#' iran_missile_tests_df
#' dplyr::glimpse(iran_missile_tests_df)
#' 
#' india_missile_tests_df
#' dplyr::glimpse(iran_missile_tests_df)
#' 
#' pakistan_missile_tests_df
#' dplyr::glimpse(pakistan_missile_tests_df)

#' @rdname cns-missile-test-databases
"dprk_missile_tests_df"

#' @rdname cns-missile-test-databases
"iran_missile_tests_df"

#' @rdname cns-missile-test-databases
"india_missile_tests_df"

#' @rdname cns-missile-test-databases
"pakistan_missile_tests_df"