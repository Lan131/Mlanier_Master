library(dplyr)
install.packages('magrittr')
library(magrittr)
                



 Installing package into ‘/databricks/spark/R/lib’
> 
sparkDF <- read.df(sqlContext, "/FileStore/tables/gqmstiwl1479676671412/With_interaction.csv", source = "csv", header="true", inferSchema = "true")
class(sparkDF)

[1] "SparkDataFrame"
attr(,"package")
[1] "SparkR"
> 

head(where(sparkDF, sparkDF$loss > .5))


 
  id cat1 cat2 cat3 cat4 cat5 cat6 cat7 cat8 cat9 cat10 cat11 cat12 cat13 cat14
1  1    A    B    A    B    A    A    A    A    B     A     B     A     A     A
2  2    A    B    A    A    A    A    A    A    B     B     A     A     A     A
3  5    A    B    A    A    B    A    A    A    B     B     B     B     B     A
4 10    B    B    A    B    A    A    A    A    B     A     A     A     A     A
5 11    A    B    A    B    A    A    A    A    B     B     A     B     A     A
6 13    A    B    A    A    A    A    A    A    B     A     A     A     A     A
  cat15 cat16 cat17 cat18 cat19 cat20 cat21 cat22 cat23 cat24 cat25 cat26 cat27
1     A     A     A     A     A     A     A     A     B     A     A     A     A
2     A     A     A     A     A     A     A     A     A     A     A     A     A
3     A     A     A     A     A     A     A     A     A     A     A     A     A
4     A     A     A     A     A     A     A     A     B     A     A     A     A
5     A     A     A     A     A     A     A     A     B     A     A     A     A
6     A     A     A     A     A     A     A     A     A     A     A     A     A
  cat28 cat29 cat30 cat31 cat32 cat33 cat34 cat35 cat36 cat37 cat38 cat39 cat40
1     A     A     A     A     A     A     A     A     A     A     A     A     A
2     A     A     A     A     A     A     A     A     A     A     A     A     A
3     A     A     A     A     A     A     A     A     B     A     A     A     A
4     A     A     A     A     A     A     A     A     A     A     A     A     A
5     A     A     A     A     A     A     A     A     A     A     A     A     A
6     A     A     A     A     A     A     A     A     A     A     A     A     A
  cat41 cat42 cat43 cat44 cat45 cat46 cat47 cat48 cat49 cat50 cat51 cat52 cat53
1     A     A     A     A     A     A     A     A     A     A     A     A     A
2     A     A     A     A     A     A     A     A     A     A     A     A     A
3     A     A     A     A     A     A     A     A     A     A     A     A     A
4     A     A     A     A     A     A     A     A     A     A     A     A     A
5     A     A     A     A     A     A     A     A     A     A     A     A     A
6     A     A     A     A     A     A     A     A     A     A     A     A     A
  cat54 cat55 cat56 cat57 cat58 cat59 cat60 cat61 cat62 cat63 cat64 cat65 cat66
1     A     A     A     A     A     A     A     A     A     A     A     A     A
2     A     A     A     A     A     A     A     A     A     A     A     A     A
3     A     A     A     A     A     A     A     A     A     A     A     A     A
4     A     A     A     A     A     A     A     A     A     A     A     A     A
5     A     A     A     A     A     A     A     A     A     A     A     A     A
6     A     A     A     A     A     A     A     A     A     A     A     A     A
  cat67 cat68 cat69 cat70 cat71 cat72 cat73 cat74 cat75 cat76 cat77 cat78 cat79
1     A     A     A     A     A     A     A     A     B     A     D     B     B
2     A     A     A     A     A     A     A     A     A     A     D     B     B
3     A     A     A     A     A     A     A     A     A     A     D     B     B
4     A     A     A     A     A     A     B     A     A     A     D     B     B
5     A     A     A     A     A     B     A     A     A     A     D     B     D
6     A     A     A     A     A     B     A     A     A     A     D     B     D
  cat80 cat81 cat82 cat83 cat84 cat85 cat86 cat87 cat88 cat89 cat90 cat91 cat92
1     D     D     B     D     C     B     D     B     A     A     A     A     A
2     D     D     A     B     C     B     D     B     A     A     A     A     A
3     B     D     B     D     C     B     B     B     A     A     A     A     A
4     D     D     D     B     C     B     D     B     A     A     A     A     A
5     B     D     B     B     C     B     B     C     A     A     A     B     H
6     B     D     B     B     C     B     B     B     A     A     A     A     A
  cat93 cat94 cat95 cat96 cat97 cat98 cat99 cat100 cat101 cat102 cat103 cat104
1     D     B     C     E     A     C     T      B      G      A      A      I
2     D     D     C     E     E     D     T      L      F      A      A      E
3     D     D     C     E     E     A     D      L      O      A      B      E
4     D     D     C     E     E     D     T      I      D      A      A      E
5     D     B     D     E     E     A     P      F      J      A      A      D
6     D     D     D     E     C     A     P      J      D      A      A      E
  cat105 cat106 cat107 cat108 cat109 cat110 cat111 cat112 cat113 cat114 cat115
1      E      G      J      G     BU     BC      C     AS      S      A      O
2      E      I      K      K     BI     CQ      A     AV     BM      A      O
3      F      H      F      A     AB     DK      A      C     AF      A      I
4      E      I      K      K     BI     CS      C      N     AE      A      O
5      E      K      G      B      H      C      C      Y     BM      A      K
6      E      H      F      B     BI     CS      A     AS     AE      A      K
  cat116    cont1    cont2    cont3    cont4    cont5    cont6    cont7   cont8
1     LB 0.726300 0.245921 0.187583 0.789639 0.310061 0.718367 0.335060 0.30260
2     DP 0.330514 0.737068 0.592681 0.614134 0.885834 0.438917 0.436585 0.60087
3     GK 0.261841 0.358319 0.484196 0.236924 0.397069 0.289648 0.315545 0.27320
4     DJ 0.321594 0.555782 0.527991 0.373816 0.422268 0.440945 0.391128 0.31796
5     CK 0.273204 0.159990 0.527991 0.473202 0.704268 0.178193 0.247408 0.24564
6     DJ 0.546670 0.681761 0.634224 0.373816 0.302678 0.364464 0.401162 0.26847
    cont9  cont10   cont11   cont12   cont13   cont14  int(7,12)    loss
1 0.67135 0.83510 0.569745 0.594646 0.822493 0.714843 0.19924209 2213.18
2 0.35127 0.43919 0.338312 0.366307 0.611431 0.304496 0.15992414 1283.60
3 0.26076 0.32446 0.381398 0.373424 0.195709 0.774425 0.11783208 3005.09
4 0.32128 0.44467 0.327915 0.321570 0.605077 0.602642 0.12577503  939.85
5 0.22089 0.21230 0.204687 0.202213 0.246011 0.432606 0.05002911 2763.85
6 0.46226 0.50556 0.366788 0.359249 0.345247 0.726792 0.14411705 5142.87
> 
createOrReplaceTempView(sparkDF, "sparkDF")
avg_loss <- sql("SELECT avg(loss) FROM sparkDF")
head(avg_loss)
  avg(loss)
1  3037.338
> 
head(summary( sparkDF))
  summary                 id               cont1               cont2
1   count             188318              188318              188318
2    mean  294135.9825614121  0.4938613645642005  0.5071883561794936
3  stddev 169336.08486658792 0.18764017641388603 0.20720173860981386
4     min                  1              1.6E-5            0.001149
5     max             587633            0.984975            0.862654
                cont3               cont4               cont5
1              188318              188318              188318
2 0.49891845072165986  0.4918123025892125 0.48742772878327495
3 0.20210460819343742 0.21129221269283577 0.20902682854450394
4            0.002634            0.176921            0.281143
5            0.944251            0.954297            0.983674
                cont6               cont7               cont8
1              188318              188318              188318
2 0.49094453373550273  0.4849702050680173 0.48643731586994415
3 0.20527256983553038 0.17845016396070926 0.19937045456133265
4            0.012683            0.069503             0.23688
5            0.997162                 1.0              0.9802
                cont9              cont10              cont11
1              188318              188318              188318
2  0.4855063198950671 0.49806585042322404  0.4935110085546688
3 0.18166017135075618  0.1858767259320183 0.20973651144747796
4              8.0E-5                 0.0            0.035321
5              0.9954             0.99498            0.998742
               cont12              cont13              cont14
1              188318              188318              188318
2 0.49315042562582034 0.49313761583599725 0.49571701797491136
3 0.20942662107602905 0.21277724232240955 0.22248753955922554
4            0.036232             2.28E-4            0.179722
5            0.998484            0.988494            0.844848
            int(7,12)               loss
1              188318             188318
2 0.26691991794301145 3037.3376856699924
3 0.19080712285708876  2904.086186390403
4         0.002518233               0.67
5            0.998484          121012.25
> 
head(summarize(groupBy(sparkDF, sparkDF$cat111), count = n(sparkDF$cat111)))


  cat111 count
1      K  1353
2      F     3
3      Q    91
4      E 14682
5      B     7
6      Y     2
> 
GLM <- spark.glm(sparkDF, loss ~ ., family = "gaussian")
summary(GLM)

Internal error, sorry. Attach your notebook to a different cluster or restart the current cluster.
> 
createOrReplaceTempView(sparkDF, "sparkDF")
avg_loss <- sql("SELECT avg(loss),cat111 FROM sparkDF group by cat111")
head(avg_loss)
  avg(loss) cat111
1  5175.608      K
2  3365.923      F
3  6552.889      Q
4  3487.309      E
5  2578.653      B
6  5891.655      Y
> 
GLM <- spark.glm(sparkDF, loss ~ cat111 + cont1, family = "gaussian")
summary(GLM)
Deviance Residuals: 
(Note: These are approximate quantiles with relative error <= 0.01)
   Min      1Q  Median      3Q     Max  
 -8897   -1743    -920     889  116970  

Coefficients:
             Estimate  Std. Error  t value   Pr(>|t|) 
(Intercept)  6030.2    2027.9      2.9736    0.0029436
cat111_A     -3123.7   2027.7      -1.5405   0.12344  
cat111_C     -2837.7   2027.8      -1.3994   0.16169  
cat111_E     -2463.7   2027.9      -1.2149   0.22439  
cat111_G     -1936.7   2028        -0.95496  0.3396   
cat111_I     -1412.7   2028.3      -0.69649  0.48612  
cat111_K     -773.98   2029.2      -0.38142  0.70289  
cat111_M     140.36    2032        0.069076  0.94493  
cat111_O     145.25    2036.9      0.07131   0.94315  
cat111_Q     601.71    2049.9      0.29354   0.76911  
cat111_S     1885.9    2080.4      0.90652   0.36466  
cat111_U     3658.6    2150.7      1.7011    0.088918 
cat111_W     3540.2    2150.7      1.646     0.099758 
cat111_B     -3393.6   2299.2      -1.476    0.13996  
cat111_F     -2581.2   2617.7      -0.98603  0.32412  
cat111_D     -1295.2   2617.7      -0.49478  0.62075  
cont1        -161.12   35.22       -4.5748   4.769e-06

(Dispersion parameter for gaussian family taken to be 8222909)

    Null deviance: 1.5882e+12  on 188317  degrees of freedom
Residual deviance: 1.5484e+12  on 188301  degrees of freedom
AIC: 3532923
