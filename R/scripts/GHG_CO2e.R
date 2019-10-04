#This file is for converting gases listed in F_gases and GHG_gases into CO2e so that NDC constraints can be set.


#function to convert LUC emissions into a format that can be added to a GHG emissions query
format_LUC_CO2 <- function(data){
  model_periods <- c(1990, seq(2005, 2100, 5))
  data %>%
    gather(year, value, -c(scenario, region, LandLeaf, Units)) %>%
    mutate(GHG = "CO2", Units = "MTC", year = as.integer(gsub("X", "", year))) %>%
    select(scenario, region, GHG, year, value) %>%
    filter( year %in% model_periods) %>%
    return()
}

#function to convert emissions into long format
format_emissions <- function(data){
  data %>%
    gather(year, value, -c(scenario,	region,	GHG, Units)) %>%
    mutate(year = as.integer(gsub("X", "", year))) %>%
    filter(region != "Global") %>%
    return()
}

# function covert GHG to CO2e
conv_ghg_co2e <- function (data) {
  require(dplyr)
  require(tidyr)

  # GHG emission conversion
  F_GASES <- c("C2F6", "CF4", "HFC125", "HFC134a", "HFC245fa", "SF6", "HFC143a", "HFC152a", "HFC227ea", "HFC23", "HFC236fa", "HFC32", "HFC365mfc")
  GHG_gases <- c("CH4", "N2O", F_GASES, "CO2")
  # GWP conversions - uses 100-yr GWPs from AR4 in GCAM unit
  GWP_C2F6 <- 12.2
  GWP_CF4 <- 7.39
  GWP_HFC125 <- 3.5
  GWP_HFC134a <- 1.43
  GWP_HFC245fa <- 1.03
  GWP_SF6 <- 22.8
  GWP_HFC143a <- 4.47
  GWP_HFC152a <- 0.124
  GWP_HFC227ea <- 3.22
  GWP_HFC23 <- 14.8
  GWP_HFC236fa <- 9.81
  GWP_HFC32 <- 0.675
  GWP_HFC365mfc <- 0.794
  GWP_CH4 <- 25
  GWP_N2O <- 298 #times of CO2

  MTC_to_MtCO2 <- 44/12
  MTC_to_GtCO2 <- 44/12/1000

  GWP_adjuster <- data.frame(GHG_gases, GWP = c(25, 298, 12.2, 7.39, 3.5, 1.43, 1.03, 22.8, 4.47, 0.124, 3.22, 14.8, 9.81, 0.675, 0.794, 44/12))

  data %>%
    separate(GHG, into = c("gas", "sector"), sep = "_", fill = "right") %>%
    select(-sector, -Units) %>%
    filter(gas %in% GHG_gases) %>%
    left_join(GWP_adjuster, by = c("gas" = "GHG_gases")) %>%
    mutate(value = value * GWP) %>%
    select(-GWP) %>%
    return()
}

write_const_csv <- function(x, file, f = write.csv, ...){
  header <- "INPUT_TABLE\nVariable ID\nGHGConstr\n"
  tail <- "\nINPUT_TABLE\nVariable ID\nGHGConstrMkt\n\nregion,ghgpolicy,market\nEU-15,GHG,EU"
  # create and open the file connection
  datafile <- file(file, open = 'wt')
  # close on exit
  on.exit(close(datafile))
  # if a header is defined, write it to the file
  writeLines(header,con=datafile)
  # write the file using the defined function and required addition arguments
  f(x, datafile,...)
  # write the tail of the csv
  writeLines(tail, con=datafile)
}
