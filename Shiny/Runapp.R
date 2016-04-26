



library(shiny)
library(rsconnect)

rsconnect::setAccountInfo(name='mlanier131',
                          token='5419D62A77BAA6D730CA4D58F5DE014C',
                          secret='0/17/yd5Ahm9FKEueF136icSwW4sHDzIkCYuD1Ae')

rsconnect::deployApp('2app')
