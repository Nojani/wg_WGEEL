# Name : global.R
# Date : 03/07/2018
# Author: cedric.briand
# DON'T FORGET TO SET THE qualify_code for eel_qal_id (this will be use to discard duplicates)
###############################################################################

#########################
# loads shiny packages 
########################
# the shiny is launched from shiny_data_integration/shiny
# debug tool
#setwd("C:\\workspace\\wg_WGEEL\\R\\shiny_data_integration\\shiny_di")
source("load_library.R")
source("utilities.R")
load_package("shiny")
load_package("leaflet.extras")
load_package("sf")

# load_package("shinythemes")
load_package("DT")
load_package("readxl")
load_package("stringr")
load_package("htmltools")
load_package("spsComps")
load_package("writexl")
load_package("shinybusy")


#-----------------
# Data correction table
#-----------------

load_package("pool")
load_package("DBI")
# load_package("RPostgreSQL") # this one works with sqldf
load_package("RPostgres")
load_package("dplyr")
load_package("tidyr")
load_package("glue")
load_package("shinyjs")
load_package("shinydashboard")
load_package("shinyWidgets")
load_package("shinyBS")
#load_package("sqldf")
load_package("leaflet")
load_package("shinytoastr")
load_package("tibble")
load_package("purrr") 
options(shiny.sanitize.errors = FALSE)

#----------------------
# Graphics
#----------------------
load_package("viridis")
load_package("ggplot2")
load_package("plotly")

jscode <- "shinyjs.closeWindow = function() { window.close(); }"

if(packageVersion("DT")<"0.2.30"){
  message("Inline editing requires DT version >= 0.2.30. Installing...")
  devtools::install_github('rstudio/DT')
}

if(packageVersion("glue")<"1.2.0.9000"){
  message("String interpolation implemented in glue version 1.2.0 but this version doesn't convert NA to NULL. Requires version 1.2.0.9000. Installing....")
  devtools::install_github('tidyverse/glue')
}

#source("database_connection.R")

load(file=str_c(getwd(),"/common/data/init_data.Rdata"))
# liste des champs permettant de charger l'interface


# below dbListFields from R postgres doesn't work, so I'm extracting the colnames from 
# the table to be edited there



source("loading_functions.R")
source("check_utilities.R")
source("database_data.R") #function extract_data
source("database_reference.R") # function extract_ref
load("common/data/ccm.rdata")

source("importstep0.R")
source("importstep1.R")
source("importstep2.R")
source("newparticipants.R")
source("plotduplicates.R")
source("importtsstep0.R")
source("importtsstep1.R")
source("importtsstep2.R")
source("importdcfstep0.R")
source("importdcfstep1.R")
source("importdcfstep2.R")
# Local shiny files ---------------------------------------------------------------------------------

source("database_tools.R")
source("graphs.R")
source("tableEdit.R")
options(shiny.maxRequestSize=20*1024^2) #20 MB for excel files
#pool <- pool::dbPool(drv = dbDriver("PostgreSQL"),
#		dbname="postgres",
#		host="localhost",
#		port=5432,
#		user= "test",
#		password= "test")
onStop(function() {
			poolClose(pool)
		}) # important!
# VERY IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -------------------------------------------------
##########################
# CHANGE THIS LINE AT THE NEXT DATACALL AND WHEN TEST IS FINISHED
# BEFORE WGEEL sqldf('delete from datawg.t_eelstock_eel where eel_datasource='test')
# BEFORE WGEEL sqldf('delete from datawg.t_eelstock_eel where eel_datasource='test')
########################
qualify_code<-22 # change this code here and in tr_quality_qal for next wgeel
the_eel_datasource <- "dc_2022"  # change this after tests
current_year <- 2022





###################################"
#DATABASE CONNECTION INFO
##################################"
port <- 5432
host <- "localhost" #"185.135.126.250" #"localhost"#"192.168.0.100"
userwgeel <-"wgeel"






########### create a dictionnary of columns with types
dictionary=c(
  ###########columns in group_metrics sampling	
  "gr_id"="numeric",
  "sai_name"="text",
  "sai_emu_nameshort"="text",
  "gr_year"="numeric",
  "grsa_lfs_code"="text",
  "gr_number"="numeric",
  "lengthmm"="numeric",
  "weightg"="numeric",
  "ageyear" = "numeric",
  "female_proportion"="numeric", 
  "differentiated_proportion" = "numeric",
  "m_mean_lengthmm"= "numeric",
  "m_mean_weightg"= "numeric",
  "m_mean_ageyear"= "numeric",
  "f_mean_lengthmm"= "numeric",
  "f_mean_weightg"= "numeric",
  "f_mean_age"= "numeric",
  "g_in_gy_proportion"= "numeric",
  "s_in_ys_proportion"= "numeric",
  "anguillicola_proportion"= "numeric",
  "anguillicola_intensity"= "numeric",
  "muscle_lipid_fatmeter_perc"= "numeric",
  "muscle_lipid_gravimeter_perc"= "numeric",
  "sum_6_pcb"= "numeric",
  "teq"= "numeric",
  "evex_proportion"= "numeric",
  "hva_proportion"= "numeric",
  "pb"= "numeric",
  "hg"= "numeric",
  "cd"= "numeric",
  "gr_comment"="text",
  "gr_last_update" = "date",
  "gr_dts_datasource"="text",
  ####columns in fish individual metrics samplings	
  "fi_id"="numeric",
  "sai_name"="text",
  "sai_emu_nameshort"="text",
  "fi_date"="date",
  "fi_year"="numeric",
  "fi_lfs_code"="text",
  "fisa_x_4326"="numeric",
  "fisa_y_4326"="numeric",
  "fi_comment"="text",
  "lengthmm"="numeric",
  "weightg"="numeric",
  "ageyear"="numeric",
  "eye_diam_meanmm"="numeric",
  "pectoral_lengthmm"="numeric",
  "is_female_(1=female,0=male)"="numeric",
  "is_differentiated_(1=differentiated,0_undifferentiated)"="numeric",
  "anguillicola_presence_(1=present,0=absent)"="numeric",
  "anguillicola_intensity"="numeric",
  "muscle_lipid_fatmeter_perc"="numeric",
  "muscle_lipid_gravimeter_perc"="numeric",
  "sum_6_pcb"="numeric",
  "teq"="numeric",
  "evex_presence_(1=present,0=absent)"="numeric",
  "hva_presence_(1=present,0=absent)"="numeric",
  "pb"="numeric",
  "hg"="numeric",
  "cd"="numeric",
  "fi_last_update"="date",
  "fi_dts_datasource"="text"
)
