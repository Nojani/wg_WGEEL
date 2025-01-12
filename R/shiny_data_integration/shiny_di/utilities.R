#' @title converts to boolean
#' @description this function converts any kind of boolean from a spreadsheet
#' such as 0, true or FALSE to real #' boolean
#' @param myvec the vector
#' @param name a name to detect potential errors
#' @return a vector of boolean
#
#port <- 5432
#host <- "localhost"#"192.168.0.100"
#userwgeel <-"wgeel"
#pool <<- pool::dbPool(drv = dbDriver("PostgreSQL"),
#		dbname="wgeel",
#		host=host,
#		port=port,
#		user= userwgeel,
#		password= passwordwgeel) 
#path<-"C:\\Users\\cedric.briand\\Downloads\\modified_series_2020-08-23_FR.xlsx"


convert2boolean <- function(myvec, name){
  myvec <- as.character(myvec)
  if (!all(myvec %in% c(NA,"0","1","true","false","TRUE","FALSE")))
    stop(paste("unrecognised boolean in",name, myvec[!myvec %in% c(NA,"0","1","true","false","TRUE","FALSE")])," is not a boolean, use TRUE or FALSE or 0 or 1")
  myvec[!is.na(myvec)] <- ifelse(myvec[!is.na(myvec)] %in% c("0","false","FALSE"),
                  FALSE,
                  TRUE)
  as.logical(myvec)
}
