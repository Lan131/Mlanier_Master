# #Output table
# 
# library(shiny)
# 
# 
# runApp(list(
#   ui = basicPage(h2('The goal data'),
#                  dataTableOutput('mytable')),
#   server = function(input, output) {
#     output$mytable = renderDataTable({
#       goal
#     })
#   }
# ))

