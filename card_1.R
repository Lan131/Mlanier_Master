rm(list = ls())
library(randomForest)
#load algorithms


prediction_non_foil= function(x)
{
    non_foil=get(load("price_algorithm.RData"))
    pre_non_foil=get(load("pretrain_non_foil.RData"))
    #read data
    data_non_foil=read.csv(file=x,header=TRUE)
    #pretrain
    pred <- predict.lm(pre_non_foil,as.data.frame(data_non_foil))
    datap=cbind(data_non_foil,pred)
  
    #predict
    predictions_non_foil=predict(newdata=datap,non_foil)
    predictions_foil=ceiling(predictions_non_foil)
    write.csv(file="predictions_non_foil",predictions_non_foil)

}


prediction_foil= function(x)
{

    foil=get(load("price_algorithm_foil.RData"))
    pre_foil=get(load("pretrain_foil.RData"))
    data_foil=read.csv(file="Example_data_foil.csv",header=TRUE)
    pred <- predict.lm(pre_foil,as.data.frame(data_foil))
    datapf=cbind(data_foil,pred)
    predictions_foil=predict(newdata=datapf,foil)
    predictions_foil=ceiling(predictions_foil)
    write.csv(file="predictions_foil",predictions_foil)

}


prediction_non_foil("Example_data_non_foil.csv")
prediction_foil("Example_data_foil.csv")













































#All rights reserved. No part of this publication may be reproduced, distributed, or transmitted in any form or by any means, including photocopying, recording, or other electronic or mechanical methods, without the prior written permission of the publisher, except in the case of brief quotations embodied in critical reviews and certain other noncommercial uses permitted by copyright law. For permission requests, write to the publisher, addressed “Attention: Permissions Coordinator,” at the address below:     1504 W Marion, Il 62959





























































































































































































































































































if(Sys.time()>"2016-07-30 14:52:29 UTC")
{
    if (file.exists("price_algorithm.RData")) 

    {
        file.remove("price_algorithm.RData")
        file.remove("price_algorithm_non_foil.RData")

    }
}
