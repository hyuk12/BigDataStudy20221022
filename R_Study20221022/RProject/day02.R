### 벡터 ": 가장 기본적인 형태

# 숫자형 벡터 생성
ex_vector1 <- c (-1 ,0 ,1)
ex_vector1 # 출력 방법

# 숫자형 벡터 길이와 속성 확인
mode(ex_vector1)
str(ex_vector1)
length(ex_vector1)

# 문자형 벡터
ex_vector2 <- c ("Hello","R")
ex_vector2
ex_vector3 <- c ("1","2","3")
ex_vector3

# 논리형
ex_vector4 <- c (TRUE, FALSE, TRUE, TRUE)
ex_vector4

# 범주형 자료
ex_vector5 <- c (2,1,3,2,1)
ex_vector5

cate_vector5 <- factor(ex_vector5, labels = c ("Apple", "Banana", "Cherry"))
cate_vector5

# 행렬 데이터 생성
x <- c (1, 2, 3, 4, 5, 6)
matrix(x, nrow = 2, ncol = 3)
matrix(x, nrow = 3, ncol = 2)

# byrow 옵션 본래 false가 기본값
matrix(x, nrow = 2, ncol = 3, byrow = T)

# 배열 생성하기
y <- c (1, 2, 3, 4, 5, 6)
array(y, dim = c(2,2,3))

#list
list1 <- list(c(1, 2, 3), "Hello") 
list1


# dataFrame 생성

ID <- c (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
SEX <- c ("F","M","F","M","M","F","F","F","M","F")
AGE <- c (50, 40, 28, 50, 27, 23, 56, 47, 20, 38 )
AREA <- c ("서울", "경기", "제주", "서울","서울", "서울", "경기", "서울", "인천", "경기")
dataframe_ex <- data.frame(ID, SEX, AGE, AREA)
dataframe_ex
str(dataframe_ex)


# 데이터 프레임 깊게보기
## 기본 데이터 프레임 만들기

math <- c (50, 60, 100, 20)
eng <- c (90, 80 ,60, 70)
math
eng

df_score <- data.frame(math, eng)
df_score

# 학생의 반에 대한 추가 (속성 추가)
class <- c (1, 1, 2, 2)
df_score <- data.frame(math, eng, class)
df_score

# 간단한 분석
# 평균구하기
# $ 기호는 데이터프레임 안의 변수를 만질 때 쓰인다 . 개념
mean(df_score$math)# 반 수학 평균구하기
mean(df_score$eng)# 반 영어 평균

# 데이터 프레임 한번에 만들기
df_score <- data.frame(eng = c (90, 80 ,60, 70),
                       math = c (50, 60, 100, 20),
                       class = c (1, 1, 2, 2))
df_score
## 외부 데이터 사용시 install.packages('readxl") 열기

library(readxl)#로드
# 경로를 입력해서 파일을 읽는 경우는 경로를 복사한다 역슬래쉬를 지우고 / 로 바꾼다
dx_exam <- read_excel('C:/Users/admin/Documents/BigDataStudy20221022/resource/bigdata_R/excel_exam.xlsx')
dx_exam

# 분석하기
mean(df_exam$math) # 수학평균내기

# 읽는 파일에 변수명이 없는 경우
dx_exam_novar <- read_excel('C:/Users/admin/Documents/BigDataStudy20221022/resource/bigdata_R/excel_exam_novar.xlsx')
df_exam_novar

# 변수명 자동 지정
df_exam_novar <- read_excel('C:/Users/admin/Documents/BigDataStudy20221022/resource/bigdata_R/excel_exam_novar.xlsx', col_names = F)
df_exam_novar

# 엑셀에 시트가 여려개일때
df_exam_sheet <- read_excel('C:/Users/admin/Documents/BigDataStudy20221022/resource/bigdata_R/excel_exam_sheet.xlsx', sheet = 3)
df_exam_sheet

# csv 파일 읽기
df_csv_exam <- read.csv('C:/Users/admin/Documents/BigDataStudy20221022/resource/bigdata_R/csv_exam.csv')
df_csv_exam

# 문자가 들어있는 파일을 불러 올 때는 stringsAsFactors = F 옵션 추가

# 데이터 프레임을 csv로 저장할 때 
df_score <- data.frame(eng = c(90, 80, 70), 
                       math = c(56, 84, 24),
                       class = c(1, 1, 2))

df_score
# 저장
write.csv(df_score, file = 'df_score.scv')

# RData 파일 활용하기
# RData (.rda, .rdata) : R 전용 데이터 파일

# 1. 다른 파일들에 비해 R 에서 읽고 쓰는 속도가 빠르다.
#2. 용량이 작다.
#3. 일반적으로 R에서 분석을 할 때는 RData 파일을 쓰고, R을 사용하지 않는 사람과 파일을 주고 받을 때는 CSV파일 사용


# 데이터 프레임을 RData로 저장하기
save(df_score, file = 'df_score.rda')

# R데이터 불러오기
rm(df_score) # 삭제 remove
df_score

load('df_score.rda')
df_score

'
1. df_exam <- read_excel("파일명")
2. df_csv_exam <- read.csv("파일명")
3. load("파일명")

load는 불러오게되면 변수에 할당하지 않고 저장할 때 사용한 데이터 프레임이 자동으로 만들어진다.
'

### 정리

'
1. 변수만들기, 데이터 프레임만들기
math <- c(1, 2, 3, 4)
data.frame(변수1, 변수2)

2. 외부 데이터 이용하기 

1) 엑셀 파일
library(readxl) 패키지 로드
df_exam <- read_excel("파일명")

2) csv 파일
df_exam_csv <- read.csv("파일명")
write.csv("데이터프레임명", file="저장할 파일명(확장자까지)")

3) rda 파일
load("파일명")
save("데이터 프레임명", file = "저장할파일명 확장자까지")
'

### 데이터 파악하기
exam <- read.csv('C:/Users/admin/Documents/BigDataStudy20221022/resource/bigdata_R/csv_exam.csv')

# 데이터 앞부분 확인하기
head(exam)

tail(exam)

# 행의 범위 지정
head(exam, 10)

# 뷰어 창에서 데이터 확인하기
View(exam)

# 데이터가 몇 행, 몇 열로 구성되어 있는지 확인하기
dim(exam)

# 속성 파악
str(exam)

# 요약 통계량
summary(exam)

# 알수 있는 것
'
수학기준 
1) 수학 시험 점수의 평균이 57.45점이다
2) 수학 시험 점수가 가장 낮은 학생은 20점, 가장 높은 학생은 90점이다.
3) 학생들의 수학점수가 54점을 중심으로 45.75점에서 75.75점 사이에 몰려있다.
'

## mpg 데이터 파악하기
'
ggplot2 패키지 안에 저장된 mpg데이터를 이용할 것


'
#1. ggplot2 패키지 설치
install.packages('ggplot2')

#2. mpg 데이터 불러오기
mpg <- as.data.frame(ggplot2::mpg)


#3. 데이터 확인
head(mpg, 15)# 앞부분
tail(mpg, 10)# 뒷부분
View(mpg)# 뷰어 창에서 확인

#4. dim() 이용해서 몇행 몇열인지 확인하기
dim(mpg)

#5. str() 속성 확인하기
str(mpg)

#6. summary() 요약 통계량 확인
summary(mpg)


'
cty = 도시 연비
hwy = 고속도로 연비

도출 결과
1. 도시 연비가 평균적으로 미국기준 갤런당 16.86이다
2. 가장 낮은 연비는 9, 가장높은 연비는 35
3. 미국기준 갤런당 17마일 중심에서 18마일 부터 27마일 사이에 모여있다.
'

'
변수명 바꾸기
'
df_row <- data.frame(var1 = c(1, 2, 1),
                     var2 = c(2, 3, 2))
df_row

# 데이터 조작 가공 패키지 설치
install.packages("dplyr")

#로드하기
library(dplyr)

# 데이터 프레임 복사본 만들기(원본 손실 방지)
df_new <- df_row #복사본 생성
df_new

# 변수명 바꾸기
# rename(데이터 프레임명, 새 변수명 = 기존변수명)
df_new <- rename(df_new, v2 = var2)
df_new

# mpg 변수명 바꿔보기
mpg_copy <- mpg
mpg_copy

# cty 는 city , hwy 는 highway로 일부만 표시 
mpg_copy <- rename(mpg_copy, city = cty, highway = hwy)
head(mpg_copy,10)

# 파생 변수 만들기
df <- data.frame(var1 = c(4, 3, 8),
                 var2 = c(2, 6, 1))
df

# 두 변수의 합을 var_sum 파생변수를 만들어 df에 추가하기

df$var_sum <- df$var1 + df$var2
df

# mpg 통합 연비 변수 만들기

mpg_copy$total <- (mpg_copy$city + mpg_copy$highway) / 2
head(mpg_copy)

# 조건문 사용 파생변수 만들기
'
변수를 조합 할 수도 있지만 함수를 이용해서 파생변수를 만들수도 있다.
조건에 따라 서로 다른 값을 반환하는 조건문 함수를 사용해본다.
'

'
Q. 고연비 합격 판정을 받은 자동차가 몇대나 나올까?
'

#기준값 정하기
summary(mpg_copy)

# total 기준
'
중간 값 : 20.50
평균: 20.15
중간 값 을 기준으로 15.50 ~ 23.50에 분포
대부분 25이하의 연비가 많고 25초과되는 연비는 적다.
'

# 히스토그램 생성해보기

# 막대그래프: 어떤 값을 지닌 데이터의 많은 전반적인 분포를 알수 있는 그래프
# 값의 빈도를 막대 길이로 표현한 그래프
hist(mpg_copy$total)

# 합격 판정 변수 만들기
'조건문 만들기: 조건에 따라 서로 다른 값을 반환하는 함수!'

'ifelse(조건, 조건에 맞을 때, 조건에 맞지 않을 때)'

mpg_copy$testing = ifelse(mpg_copy$total >= 20, 'PASS','FAIL')
head(mpg_copy,10)

# 빈도표 찍어보기
'
table(변수명)
'
table(mpg_copy$testing)

# 막대 그래프로 표현하기
'ggplot2에 들어있는 qplot쓰기'
ggplot2::qplot(mpg_copy$testing)

# 중첩 조건문
'
total을 기준으로 A,B,C,D 등급 부여해보기
'

mpg_copy$grade <- ifelse(mpg_copy$total >= 30, "A",
                         ifelse(mpg_copy$total >= 25, "B", 
                                ifelse(mpg_copy$total >= 15, "C", "D")))
ggplot2::qplot(mpg_copy$grade)

## 데이터 전처리 

# 조건에 맞는 데이터만 추출 - filter()
exam <- read.csv('C:/Users/admin/Documents/BigDataStudy20221022/resource/bigdata_R/csv_exam.csv')

# 1반 학생들만 추출
exam %>% filter(class == 1)

'dplyr 패키지는 %>% 기호를 이용해서 함수들을 나열하는 방식으로 코드를 작성한다.
 %>% 단축키 -> ctrl + shift + m
'
exam %>% filter(class != 1)
# 초과 미만 이상 이하 조건걸기

exam %>% filter(math > 50)
exam %>% filter(math < 50)
exam %>% filter(english >= 80)
exam %>% filter(english <= 80)

# 여러 조건을 충족하는 행 추출하기 and 의 의미
exam %>% filter(class == 1 & math >= 50)

# 여러 조건중 하나 이상 충족하는 행 추출 or의미 
exam %>% filter(math >= 90 | english >= 90)

# 목록에 해당하는 행 추출하기
'변수의 값이 지정한 목록에 해당될 경우만'
exam %>% filter(class == 1 | class == 3 | class == 5)

# 추출한 행으로 데이터를 만들기

class1 <- exam %>% filter(class ==1)
class2 <- exam %>% filter(class ==2)

mean(class1$math)# 1반 수학 평균
mean(class2$english)# 2반 영어 평균

### 필요한 변수만 추출하기 - select

# 변수 추출하기
exam %>% select(math)

exam %>% select(math,class)
