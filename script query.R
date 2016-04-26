

for(i in 4:19)
{
  if(i<9 || i>10)
       {print(paste("
             INSERT INTO [Portal].[dbo].[PTORequests]
           ([Emp]
           ,[DT]
           ,[Hours]
           ,[App]
           ,[Type]
           ,[Owner]
           ,[DTEntered])
     VALUES
           ('Jeremy Stotler'
           ,CAST('1/",
                   
                   
                   
                   toString(i),"/2016' as DATE)
                   ,8
                   ,1
                   ,'PTO'
                   ,'Michael Lanier'
                   ,CAST('2/11/2016' as DATE))" ) )
              
  
  }
}


