'복습'
'
1. 데이터 준비, 패키지 준비
mpg <- as.data.frame(ggplot2::mpg)# 데이터 불러오기
library(dplyr)
library(ggplot2)

2. 데이터 파악
head(mpg, 범위지정)
tail(mpg)
View(mpg)
dim(mpg)

'
### 필요한 변수만 추출하기
'- select()'

library(dplyr)
exam <- read.csv("C:/Users/admin/Documents/BigDataStudy20221022/resource/bigdata_R/csv_exam.csv")
head(exam)
