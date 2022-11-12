'복습'
'
%>% : 연결의 의미
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
exam <- read.csv("C:/Users/admin/Documents/resource/R_resource/csv_exam.csv")
head(exam)
exam %>% select(math)

## 여러 변수를 추출하기
exam %>% select(class, math, english)

## 변수 제외하기

exam %>% select(-math)

## dplyr 함수 조합하기
'filter와 select 조합'

exam %>% filter(class == 1) %>% select(english)

## 가독성 있게 줄 바꾸기
exam %>% 
  filter(class == 2) %>% 
  select(id, math)

## 순서대로 정렬하기 - arrange()
exam %>% arrange(math) ## 수학 점수상 오름차순
exam %>% arrange(desc(math)) ## 수학점수 기준 내림 차순

## 파생변수 추가하기 - mutate()
' 새로만들 변수명과 변수를 만들 때 사용할 공식 입력 '
exam %>% 
  mutate(total = math + english + science) %>% 
  head

## 여러 파생변수 한번에 추가하기
exam %>% 
  mutate(total = math + english + science,
         mean = (math + english + science)/3) %>% 
  head

## mutate() 에 ifelse() 적용
exam %>% 
  mutate(test = ifelse(science >= 60, "pass", "fail")) %>% 
  head()


## 추가한 변수를 dplyr 코드에 활용하기
exam %>% 
  mutate(total = math + english + science) %>% 
  arrange(desc(total)) %>% 
  head()

# 집단별로 요약하기 groub_by, summarise
## 요약하기

exam %>% summarise(mean_math = mean(math))

exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math))

# 여러 요약 통계량 한번에 산출하기
exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math),
            sum_math = sum(math),
            median_math = median(math),
            n = n())

' 
summarise 안에 자주 들어가는 함수들
mean(): 평균
sum() : 합계
sd(): 표준편차
median(): 중앙값
min(): 최솟값
max(): 최댓값
n(): 빈도
'

#mpg 데이터 불러오기
library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)
head(mpg)
?mpg

# 각 집단별로 다시 집단 나누기

mpg %>% 
  group_by(manufacturer, drv) %>% # 회사, 구방방식 별 분리 전륜,4륜,후륜
  summarise(mean_cty = mean(cty)) %>% # 도심연비 평균
  head

# dplyr 조합하기
'dplyr  -> 함수를 조합할 때 진가를 발휘한다.'

'회사별로 suv자동차의 도시 및 고속도로 통합 연비 평균을 구해서 내림차순으로 정렬하고, 1~5위까지 출력하기'
mpg %>% 
  group_by(manufacturer) %>% 
  filter(class == 'suv') %>% 
  mutate(total = (cty + hwy)/2) %>% 
  summarise(mean_total = mean(total)) %>% 
  arrange(desc(mean_total)) %>% 
  head(5)


# 데이터 합치기

## 데이터 생성
test1 <- data.frame(id = c(1,2,3,4,5),
                    midterm=c(60,70,85,90,85))

test2 <- data.frame(id = c(1,2,3,4,5),
                    final=c(66,76,87,89,80))

test1
test2

# id 기준으로 합치기
total <- left_join(test1, test2, by="id") # by 부분이 기준점
' by에 변수 지정 할 때 겹 따옴표 입력'
total

# 세로로 합치기
group_a <- data.frame(id=c(1,2,3,4,5),
                      test=c(60,80,76,80,81))

group_b <- data.frame(id=c(6,7,8,9,10),
                      test=c(70,85,70,81,98))

group_a
group_b

group_all <- bind_rows(group_a, group_b)
group_all
df <- data.frame(s = c("M","F",NA,"M","F"),
                 score = c(5,4,3,4,NA))
df

# 결측치 확인하기
is.na(df) # TRUE가 표기되는 부분은 결측치가 있다.

# 결측치 빈도확인하기
table(is.na(df)) # 빈도표

# 변수 별로 결측치 확인
table(is.na(df$s))
table(is.na(df$score))

# 결측치 포함한 상태로 분석
# 무조건 NA로 나옴
mean(df$score)
sum(df$score)

# 결측치 제거하기
'결측치 있는 행만 제거하기'
library(dplyr)
new_df <- df %>% 
  filter(!is.na(score))

mean(new_df$score)
sum(new_df$score)

# 여러 변수 동시에 결측치 없는 데이터 추출
's, score'

new_df <- df %>% 
  filter(!is.na(score) & !is.na(s))
new_df

# 결측치가 하나라도 있으면 제거하기
'1. 분석에 필요한 데이터가 제거 될 수도 있다.
예를 들어 성별-소득 관계를 분석하는데 지역값이 제거 될 수도 있다.'

new_df2 <- na.omit(df)# 모든 변수에 결측치 없는 데이터 추출
new_df2

# summarise 에서 na.rm = T 사용하기
'결측치 제외하고 요약'

exam <- read.csv("C:/Users/admin/Documents/resource/R_resource/csv_exam.csv")
exam[c(3,8,15),"math"] <- NA # 3,8,15 행의 math에 NA 할당

exam %>% summarise(mean_math = mean(math))

# 결측치 제외 평균 산출
exam %>% summarise(mean_math = mean(math, na.rm = T))

# 다른 함수에 적용
exam %>% summarise(mean_math = mean(math, na.rm = T),
                   sum_math = sum(math, na.rm = T),
                   median_math = median(math, na.rm = T))

mean_math <- mean(exam$math, na.rm = T)

exam$math <- ifelse(is.na(exam$math), mean_math, exam$math)
table(is.na(exam$math))

exam
mean(exam$math) # 결측치 제거한 뒤에 나온 평균 = 활용 가능

'mpg 데이터 활용 - 결측치 제거'
' 결측치 없는 mpg에 결측치를 넣는다'

mpg[c(65,124,131,153,212), 'hwy'] <- NA
mpg
'1. drv 별로 hwy 평균이 어떻게 다른지 알아본다
2. 두 변수에 결측치가 있는지 확인 drv, hwy에 
결측치가 몇개 있는지'

'3. filter사용해서 hwy에 있는 결측치 제외하고 어떤 구동 방식의
고속도로 연비 평균이 높은지 알아보세요.'

table(is.na(mpg$drv))
table(is.na(mpg$hwy))

mpg %>%  
  filter(!is.na(mpg$hwy))%>%
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy))  

'mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(mpg$hwy, na.rm = T))'

mpg

outlier <- data.frame(s = c(1,2,1,3,2,1),
                      score=c(5,4,3,4,2,6))
# 결측 처리
outlier$s <- ifelse(outlier$s == 3, NA, outlier$s)
outlier

outlier$score <- ifelse(outlier$score > 5, NA, outlier$score) 
outlier

# 결측 제외하고 분석
outlier %>% 
  filter(!is.na(s) & !is.na(score)) %>% 
  group_by(s) %>% 
  summarise(mean_score = mean(score))

'
     [,1]
[1,]   12 : 극단치 경계
[2,]   18 : 1사분위수
[3,]   24 : 중앙값
[4,]   27 : 3사분위수
[5,]   37 : 극단치 경계
'

# 상자 그림 생성
mpg <- as.data.frame(ggplot2::mpg)
boxplot(mpg$hwy)

# 통계치 출력
boxplot(mpg$hwy)$stats

# 결측 처리

mpg$hwy <- ifelse(mpg$hwy < 12 | mpg$hwy > 37, NA, mpg$hwy)
mpg$hwy

table(is.na(mpg$hwy))

# 결측 제외하고 분석하기

mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy, na.rm = T))

# 그래프 그리기 
'ggplot2 레이어 구조
1단계 : 배경 설정(축)
2단계 : 그래프 추가(점, 막대, 선...)
3단계 : 설정 추가(색, 축 범위, 표식...)
'

## 산점도 - 변수간의 관계를 표현

'데이터를 x축과 y축에 점으로 표현한 그래프 방법'

' 연속된 값으로 이루어진 두 변수 간의 관계를 알아볼 때 쓰인다'
# 라이브러리 로드
library(ggplot2)
# 1. 배경설정

'x축 : displ(배기량) , y축 : hwy(고속도로연비)'

ggplot(data = mpg, aes(x = displ, y= hwy))

# 2. 그래프 추가
ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_point()

# 3. 축 범위 조정 설정

ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  xlim(3,6)

# 4. y축 범위 10~30지정

ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  xlim(3,6) +
  ylim(10,30)

# ggplot() vs qplot()
' ggplot() : 전처리 단계 데이터 확인용, 문법 간단, 기능단순'
'qplot() : 최종 보고용, 색, 크기, 폰트 등 세부 조작 가능 '

'mpg 데이터에서 도시연비, 고속도로 연비 간에 관계를 본다 x 축은 cty y축은 hwy 산점도'
ggplot(data = mpg , aes(x = cty, y = hwy)) +
  geom_point()

# 막대 그래프

'데이터의 크기를 막대의 길이로 표현한 그래프
성별 소득 차이처럼 집단 간의 차이를 표현 할 때 자주 사용한다.'

# 평균 막대 그래프

library(dplyr)
mpg <- as.data.frame(ggplot2::mpg)
df_mpg <- mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy))
df_mpg  

# 그래프 생성하기
ggplot(data = df_mpg, aes(x = drv, y = mean_hwy)) + geom_col()

# 크기 순으로 정렬
ggplot(data = df_mpg, aes(x =reorder(drv, -mean_hwy), y = mean_hwy)) + geom_col()
'reorder(): x축 변수와 정렬 기준으로 
삼을 변수를 값의 크기순으로 정렬하게 해주는 함수,
정렬 기준 변수 앞에 "-"기호를 붙이면 내림차순으로 정렬된다.'

# 빈도 막대 그래프
' 값의 개수로 막대의 길이를 표현한 그래프'
ggplot(data = mpg, aes(x = drv)) + geom_bar()

# x축에 연속된 변수, y축에 빈도
ggplot(data = mpg, aes(x = hwy)) + geom_bar()

# geom_col() vs geom_bar
' 평균 막대 그래프: 데이터를 요약한 평균 표를 먼저 만든 후에
평균 표를 이용해서 그래프 생성 - geom_col()

빈도 막대 그래프: 별도로 표를 만들지 않고 
원자료를 이용해서 바로 그래프 생성 - geom_bar()'

# 문제
'어떤 회사에서 생산한 suv 차종의 도시 연비가 높은지 알아보려한다.
suv 차종을 대상으로 평균 cty(도시 연비)가 가장 높은 회사 다섯 곳을 막대그래프로
표현해보세요, 대신 연비가 높은 순으로 정렬해보세요'

mpg <- as.data.frame(ggplot2::mpg)

mpg_suv_cty <- mpg %>% 
  filter(class == 'suv') %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty = mean(cty)) %>% 
  head(5)
mpg_suv_cty

ggplot(data = mpg_suv_cty, aes(x = reorder(manufacturer, - mean_cty), y = mean_cty))+ geom_col()

mpg_suv_hwy <- mpg %>% 
  filter(class == 'suv') %>% 
  group_by(manufacturer) %>% 
  summarise(mean_hwy = mean(hwy)) %>% 
  head(5)
mpg_suv_hwy

ggplot(data = mpg_suv_hwy, aes(x = reorder(manufacturer, - mean_hwy), y = mean_hwy))+ geom_col()

# 선 그래프 - 시간에 따라 달라지는 데이터
' 데이터를 선으로 표현한 그래프
시계열 그래프: 일정 시간 간격을 두고 나열된 시계열 데이터를
표현한 그래프, 환율, 주가지수등 경제 지표가 시간에 따라 어떻게 변하는지
표현할 때 사용한다.'

# 시계열 그래프 만들기
ggplot(data = economics, aes(x = date, y = unemploy)) + geom_line()

# psavert 저축률 : 시간에 따라 어떻게 변해왔는지 확인
ggplot(data = economics, aes(x = date, y = psavert)) + geom_line()

# 상자 그림 만들기
'집단 간의 분포 차이 표현하기'
ggplot(data = mpg, aes(x = drv, y = hwy)) + geom_boxplot()


' 
1. 산점도
: ggplot(data = dataset, aes(x = x, y = y)) + geom_point()
범위 지정 xlim(n,n) x축 / ylim(n,n) y축

2. 막대 그래프
1단계: 평균표 만들기
2단계: 그래프 생성, 크기순 정렬
ggplot(data = dataset, aes(x = x, y = y)) + geom_col()

2-1) 빈도 막대 그래프
ggplot(data = dataset, aes(x = x)) + geom_bar()
reorder(x, -y) 내림차순 정렬

3. 선 그래프
ggplot(data = dataset, aes(x = x, y = y)) + geom_line()

4. 상자 그래프
ggplot(data = dataset, aes(x = x, y = y)) + geom_boxplot()
'

# 한국인의 삶을 파악하라! / 데이터 분석 간단하게 표현하기

' 
데이터 분석 준비
1. 패키지 준비.
'
install.packages("foreign")
library(foreign)# spss 파일 불러오기
library(dplyr) # 전처리
library(ggplot2) # 시각화
library(readxl) # 엑셀파일불러오기

' 
foreign 패키지: 
우리가 사용 할 복지 데이터는 통계 분석 소프트웨어인
spss 전용 파일로 되어있다. foreign 패키지를 사용하면
spss , sas, stata등 다양한 통계분석 소프트웨어의 파일을
불러 올 수 있다.
'

'
2. 데이터 준비하기
데이터 불러오기
'
raw_welfare <- read.spss(file = "C:/Users/admin/Documents/resource/R_resource/Koweps_hpc10_2015_beta1.sav",
                         to.data.frame = T)
raw_welfare
table(is.na(raw_welfare$h10_g4))
table(is.na(raw_welfare$h10_reg7))
new_raw_welfare <- raw_welfare

head(new_raw_welfare)

welfare <- rename(raw_welfare,
                  gender = h10_g3,
                  birth = h10_g4,
                  married = h10_g10,
                  religion = h10_g11,
                  code_jobs = h10_eco9,
                  income = p1002_8aq1,
                  code_region = h10_reg7)
welfare$gender

'
1. 성별에 따라 월급이 다를까?
 - 변수 검토 및 전처리
 성별/ 월급
 
 - 변수 간 관계 분석
 성별, 월급 평균표 만들기
 그래프 만들기

'
'
성별 변수 검토 및 전처리
'
class(welfare$gender)

table(welfare$gender)

welfare$gender <- ifelse(welfare$gender == 1, "남자", "여자")
table(welfare$gender)
qplot(welfare$gender)

'월급 전처리'

class(welfare$income)
table(welfare$income)
table(is.na(welfare$income))

welfare$income <- ifelse(welfare$income == 9999 | welfare$income == 0, NA, welfare$income)
table(welfare$income)
qplot(welfare$income) +
  xlim(0,1000)

summary(welfare$income)
table(is.na(welfare$income))

# 성별 월급 평균표 만들기
gender_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(gender) %>% 
  summarise(mean_income = mean(income))
gender_income

ggplot(data = gender_income, aes(x = gender, y = mean_income)) +
  geom_col()
