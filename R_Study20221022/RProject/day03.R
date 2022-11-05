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
exam <- read.csv("C:/Users/admin/Documents/BigDataStudy20221022/resource/bigdata_R/csv_exam.csv")
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
