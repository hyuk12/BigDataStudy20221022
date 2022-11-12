# 한국 복지 패널 데이터 분석 프로젝트

install.packages("foreign")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("readxl")
library(foreign)# spss 파일 불러오기
library(dplyr) # 전처리
library(ggplot2) # 시각화
library(readxl) # 엑셀파일불러오기

## 데이터 불러오기
raw_welfare <- read.spss(file = "C:/Users/admin/Documents/resource/R_resource/Koweps_hpc10_2015_beta1.sav",
                         to.data.frame = T)

## 복사본 만들기
welfare <- raw_welfare

## 데이터 검토하기
head(welfare)
dim(welfare)
str(welfare)
summary(welfare)
' 검토 결과: 전체를 파악하기 힘들기 때문에 변수명을 바꿔주고 분석에 활용할
변수를 파악하는 과정이 필요하다'

## 변수명 바꾸기
welfare <- rename(welfare,
                  gender = h10_g3,
                  birth = h10_g4,
                  married = h10_g10,
                  religion = h10_g11,
                  code_job = h10_eco9,
                  income = p1002_8aq1,
                  code_region = h10_reg7)
welfare$gender

'
데이터 분석 절차
1. 변수 검토 및 전처리
이상치 정제, 파생변수생성, 전처리는 분석에 활용할 변수에 각각 실시
2. 변수 간 관계분석
변수간 관계를 파악 -> 그래프 그리기
'

# 성별에 따른 월급차이 

# 변수검토
class(welfare$gender)
table(welfare$gender) # 빈도 출력

# 이상치 확인

welfare$gender <- ifelse(welfare$gender == 9, NA,
                         ifelse(welfare$gender == 1, "남자", "여자"))
table(welfare$gender)
qplot(welfare$gender)

# 월급 변수 검토
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

# 나이와 월급의 관계 - 몇살에 월급이 가장 많을까
class(welfare$birth)
table(welfare$birth)

summary(welfare$birth)
qplot(welfare$birth)
' 다양한 연령대를 대상으로 조사를 해보았다. '

## 전처리
# 이상치 확인
summary(welfare$birth)

# 결측치 확인
table(is.na(welfare$birth))

# 이상치 결측 처리(이상치가 발견된 경우에만 실행)
welfare$birth <- ifelse(welfare$birth == 9999, NA, welfare$birth)

# 파생 변수 생성
'2015년도 진행한 조사라 2015 - 태어난연도를 뺀후 +1을 해서 age라는 변수를 생성'
welfare$age <- 2015 - welfare$birth + 1
summary(welfare$age)
qplot(welfare$age)

#나이와 월급관계 분석
age_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income = mean(income))

head(age_income)
tail(age_income)
ggplot(data = age_income, aes(x = age, y = mean_income)) + geom_line()

# 연령대에 따른 월급차이

# 변수 검토
welfare <- welfare %>%
  mutate(age_g = ifelse(age < 30 , "young", 
                        ifelse(age < 60 , "middle","old")))
table(welfare$age_g)
qplot(welfare$age_g)

age_g_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age_g) %>% 
  summarise(mean_income = mean(income))

age_g_income

ggplot(age_g_income, aes(x = age_g, y = mean_income)) + geom_col()
'ggplot은 막대 변수의 알파벳 순으로 정렬하도록 기본값이 설정되어 있다.'
ggplot(age_g_income, aes(x = age_g, y = mean_income)) + geom_col() +
  scale_x_discrete(limits = c('young', 'middle', 'old'))
# c 함수에 범주를 직접 지정해준다.

' 중년 층은 280만원 정도의 월급을 받는걸 알아 볼 수 있다. '

# 연령대 및 성별 월급 차이 분석
gender_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age_g, gender) %>% 
  summarise(mean_income = mean(income))

gender_income
ggplot(data = gender_income, aes(x = age_g, y = mean_income, fill = gender)) +
  geom_col(position = 'dodge') + # 막대 분리
  scale_x_discrete(limits = c('young', 'middle', 'old'))

'fill 막대가 성별에 따라 다른 색으로 표현되게 하기 위한 추가 부분
그런데 출력을 보니 각 성별의 월급이 한번에 표현되어 있어 차이를 비교할 때는
적합하지 않다. 그래서 position = "dodge" 옵션을 추가해서 분리 시켜주었다.
' 

' 초년에는 월급 차이가 크지 않다
  중년에는 월급 차이가 크게 벌어지고 남성이 여성보다 약 160만원 가량 더 받는다
  그것이 노년 까지 이어진다 노년에는 남성이 여성보다 약 90만원 가량  더 받는다.
  분석 결과 남성의 경우 노년과 초년 간 월급차이가 크지 않다고 볼수 있고
  노년이 초년보다 적은 월급을 받는 현상은 여성한테만 나타나고 있다.
  또한 초년보다 중년이 더 많은 월급을 받는 현상도 주로 남성에서 나타나고 있다.
'
# 나이 및 성별 월급 차이 분석
' 연령대로 구분하지 않고 나이 및 성별 월급 평균표를 작성하자'

gender_age <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age, gender) %>% 
  summarise(mean_income = mean(income))
gender_age

# 그래프 만들기
ggplot(data = gender_age, aes(x = age, y = mean_income, col = gender)) +
  geom_line() +
  scale_x_discrete(limits = c('young', 'middle', 'old'))
         
'col =  : 성별에 따라 선이 다르게 표현되게 할 때 추가'

# 직업별 월급 차이

class(welfare$code_jobs)
table(welfare$code_jobs)

# 전처리 - 코드북에 직종 코드 엑셀 시트를 불러오기 - 자동화

list_jobs = read_excel('C:/Users/admin/Documents/resource/R_resource/Koweps_Codebook.xlsx', col_names = T, sheet = 2)

head(list_jobs)
dim(list_jobs)
str(welfare)
'code_jobs변수를 기준으로 결합'

welfare <- left_join(welfare, list_jobs, id = 'code_job')

welfare %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job, job) %>% 
  head(10)

# 직업별 월급 차이 분석
job_income <- welfare %>% 
  filter(!is.na(income) & !is.na(job)) %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income))
head(job_income)

# 상위 10개
top10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10)
  
top10

# 그래프 만들기
ggplot(data = top10, aes(x = reorder(job, mean_income), y = mean_income)) +
  geom_col() +
  coord_flip()
'coord_flip(): 막대그래프를 90도 회전 , reorder(): 오름차순'

# 성별 직업 빈도 분석
'성 평등이 상식적인 세상이 되었지만, 여전히 성별에 따른 직업을 갖는 경향이 있다.'

# 남성 - 빈도 상위 탑10
job_male <- welfare %>% 
  filter(!is.na(job) & gender == '남자') %>% 
  group_by(job) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  head(10)
job_male

# 여성 - 빈도 상위 탑10
job_female <- welfare %>% 
  filter(!is.na(job) & gender == '여자') %>% 
  group_by(job) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  head(10)
job_female

# 종교 유무에 따른 이혼율 - 종교가 있으면 이혼을 덜 할까?

class(welfare$religion)
table(welfare$religion)

#전처리 종교 유무에 이름부여
welfare$religion <- ifelse(welfare$religion == 1, 'yes', "no")
table(welfare$religion)
qplot(welfare$religion)

# 혼인 상태 변수 검토 및 전처리
class(welfare$married)
table(welfare$married)

# 파생 변수 생성 - 이혼 여부
welfare$group_married <- ifelse(welfare$married == 1, 'married',
                                ifelse(welfare$married == 3, 'divorce', NA))
table(welfare$group_married)
table(is.na(welfare$group_married))
qplot(welfare$group_married)

# 표만들기
religion_married <- welfare %>% 
  filter(!is.na(group_married)) %>% 
  group_by(religion, group_married) %>% 
  summarise(n = n()) %>% 
  mutate(tot_group = sum(n),
         pct = round((n/tot_group) * 100, 1)) # round 반올림 
religion_married

# 이혼율 표 만들기
' 이혼 추출 '
divorce <- religion_married %>% 
  filter(group_married == 'divorce') %>% 
  select(religion, pct)
divorce

ggplot(data = divorce , aes(x = religion, y = pct)) +
  geom_col()
'종교가 없는 사람의 이혼율이 종교가 있는 사람의 아혼율 보다 높다'

# 종교 유무에 따른 이혼율이 연령대 별로 다른가?

' 연령대 별 이혼율 표 만들기 '
ageg_married <- welfare %>% 
  filter(!is.na(group_married)) %>% 
  group_by(age_g, group_married) %>% 
  summarise(n = n()) %>% 
  mutate(tot_group = sum(n),
         pct = round(n/tot_group*100, 1))
ageg_married

#연령대별 이혼율 그래프 - 초년생 제외, 이혼 추출
ageg_divorce <- ageg_married %>% 
  filter(age_g != 'young' & group_married == 'divorce') %>% 
  select(age_g, pct)
ageg_divorce

ggplot(data = ageg_divorce, aes(x = age_g, y = pct)) +
  geom_col()

#연령대, 종교유무, 결혼 상태별 비율표
' 연령대, 종교유무, 결혼 상태별로 집단을 나눠서 빈도를 구하고
각집단 전체 빈도로 나눠서 pct를 구한다. 그런 다음 이혼에 해당하는 값만 추출해 연령대 및
종교 유무별 이혼율 표를 만들겠다.'

ageg_religion_married <- welfare %>% 
  filter(!is.na(group_married) & age_g != 'young') %>% 
  group_by(age_g, religion, group_married) %>% 
  summarise(n = n()) %>% 
  mutate(tot_group = sum(n)) %>% 
  mutate(pct = round(n/tot_group*100, 1))

ageg_religion_married

# 표만들기 연령대 및 종교 유무에 따른 이혼율 표
df_divorce <- ageg_religion_married %>% 
  filter(group_married == 'divorce') %>% 
  select(age_g, religion, pct)
df_divorce

# 연령대 및 종교 유무에 따른 그래프 만들기
ggplot(data = df_divorce, aes(x = age_g, y = pct, fill = religion)) +
  geom_col(position = 'dodge')

' 중년층은 종교의 유무에 따라 이혼률이 연관이 있다. 
노년층은 미미하다.'

# 지역별 연령대 비율 - 노인 인구가 제일 많은 지역은 어디일까?

'변수 검토'
class(welfare$code_region)
table(welfare$code_region)

# 전처리
'지역 코드 목록 만들기'
list_region <- data.frame(code_region = c(1:7),
                          region = c("서울", 
                                     "수도권(인천/경기)",
                                     "부산/경남/울산",
                                     "대구/경북",
                                     "대전,충남",
                                     "강원/충북",
                                     "광주/전남/전북/제주도"))
list_region

# 지역명 변수
welfare <- left_join(welfare, list_region, by = 'code_region')

welfare %>% 
  select(code_region, region) %>% 
  head

# 지역별 연령대 비율 분석

region_ageg <- welfare %>% 
  group_by(region, age_g) %>% 
  summarise(n=n()) %>% 
  mutate(tot_group = sum(n)) %>% 
  mutate(pct = round(n/tot_group*100, 2))
region_ageg

# 그래프 만들기
ggplot(data = region_ageg, aes(x = region, y = pct, fill = age_g)) +
  geom_col() +
  coord_flip()

# 노년층 비율 높은 순으로 막대 정렬 - 내림차순
list_order_old <- region_ageg %>% 
  filter(age_g == 'old') %>% 
  arrange(pct)
list_order_old

# 지역명 순서 변수 만들기
order <- list_order_old$region
order

ggplot(data = region_ageg, aes(x = region, y = pct, fill=age_g )) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limit = order)

# 연령대 순으로 막대 색깔 나열하기

class(region_ageg$age_g)
levels(region_ageg$age_g)

'factor() 를 이용해서 age_g 변수를 factor 타입으로 변환하고,
level 파라미터를 이용해서 순서를 지정해준다.'

region_ageg$age_g <- factor(region_ageg$age_g,
                            levels = c('old', 'middle', 'young'))
class(region_ageg$age_g)
levels(region_ageg$age_g)

ggplot(data = region_ageg, aes(x = region, y = pct, fill = age_g)) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = order)

'
텍스트 마이닝: 문자로 된 데이터에서 가치 있는 정보를 얻어내는 분석 기법

1. 문장을 구성하는 어절들이 어떤 품사로 되어 있는지 파악
-> 형태소 분석
2. 단어가 얼마나 많이 등장했는지를 파악
-> sns나 검색 log , 웹 사이트에 올라온 글 분석 가능
'

# 텍스트 마이닝 준비 과정
'KoNLP , rJava'
install.packages('rJava')
install.packages('memoise')
install.packages("multilinguer")
install.packages('KoNLP')

install.packages('https://cran.r-project.org/src/contrib/Archive/KoNLP/KoNLP_0.80.2.tar.gz', 
                 repos = NULL,
                 type = 'source',
                 INSTALL_opts = c('--no-lock'))

# 패키지 로드
library(KoNLP)

library(rJava)
library(memoise)

library(multilinguer)
install_jdk()

install.packages(c('stringr', 'hash', 'tau', 'Sejong', 'RSQLite', 'devtools'), type = "binary")

install.packages("remotes")
remotes::install_github('haven-jeon/KoNLP', upgrade = "never", INSTALL_opts=c("--no-multiarch"))
devtools::install_github('haven-jeon/NIADic/NIADic', build_vignettes = TRUE)

library(dplyr)
