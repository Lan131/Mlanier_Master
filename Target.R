#install.packages("rvest")
#install.packages("ggmap")
library(ggmap)
library(rvest)
library(dplyr)
library(tidyr)

# Set the URL to borrow the data.
TargetURL <- paste0('http://www.target.com/store-locator/state-result?stateCode=', 'OH')

state='OH'
# Download the webpage.
TargetWebpage <-
  TargetURL %>%
  xml2::read_html()


# Get all of the store locations.
TargetStores <-
  TargetWebpage %>%
  rvest::html_nodes(xpath = '//*[@id="stateresultstable"]/table') %>%
  rvest::html_table() %>%
  data.frame() %>%
  dplyr::select(`Store Name` = Store.Name, Address, `City/State/ZIP` = City.State.ZIP) %>%
  tidyr::separate(`City/State/ZIP`, into = c('City', 'Zipcode'), sep = paste0(', ', state)) %>%
  dplyr::mutate(State = state) %>%
  dplyr::as_data_frame()

write.csv(file="TargetStores.csv",TargetStores)
