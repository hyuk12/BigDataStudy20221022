# 복습

1.  데이터 준비, 패키지 준비

``` r
-   ex) mpg \<- as.data.frame(ggplot2::mpg) 데이터 불러오기
-   library(dplyr) dplyr 로드 
-   library(ggplot2) ggplot2 로드
```

2.  데이터 파악

-   head() : 앞 부분
-   View() : raw 데이터 뷰어창에서 확인
-   dim() : 차원 확인
-   str() : 속성
-   summary : 요약 통계량

3.  변수명 수정

``` r
-   ex )mpg <- rename(mpg, company = manufacture)
```

4.  파생 변수 생성

``` r
-   ex) mpg$total <- <mpg$cty + mpg$hwy)/2
-   ex) mpg$t <- ifelse(mpg$total >= 20, 'Pass', 'fail')
```

5.  빈도 확인

``` r
table(mpg$total) # 빈도표 출력
qplot(mpg$total) # 막대그래프 생성
```

## dplyr 패키지 함수 요약

1.  조건에 맞는 데이터만 추출하기

``` r
exam %>% filter(english >= 80)
```

2.  여러 조건 동시에 충족

``` r
exam %>% filter(class == 1 & math >= 50)
```

3.  여러 조건 중 하나 이상 충족

``` r
exam %>% filter(math >= 90 | engilsh >= 90)
exam %>% filter(class %in% c(1,3,5)) # 포함 연산자
```

4.  정렬

``` r
exam %>% arrange(math) # 오름차순
exam %>% arrange(desc(math)) # 내림차순
```

5.  필요한 변수만 추출

``` r
exam %>% select(math)
exam %>% select(math, science)
```

6.  함수 조합하기, 일부만 추출

``` r
exam %>%
    select(id, math) %>%
    head(10)
```

7.  파생 변수 추가, 여러 변수 한번에 추가하기

``` r
exam %>% mutate(total = math + english + science)
exam %>% mutate(total = math + english + science,
                mean = (math+ english + science)/3)
```

8.  mutate()함수에 ifelse() 적용하기

``` r
exam %>% mutate(test = ifelse(science > 60, "과학반", "일반반"))
```

9.  집단별로 요약

``` r
exam %>%
    group_by(class) %>%
    summarise(mean_math = mean(math))
```

10. 집단별로 다시 집단 나누기

``` r
exam %>%
    group_by(manufacture, drv) %>%
    summarise(mean_cty = mean(cty))
```

11. 데이터 합치기

``` r
- 가로
total <- left_join(test1, test2, by = "id") by 기준으로 합쳐라

- 세로
all <- bind_rows(group_a, group_b)
```

## 데이터 정제

1.  결측치 확인

``` r
table(is.na(df$score))
```

2.  결측치 제거

``` r
df_nomiss <- df %>% filter(!is.na(score)) 
```

3.  여러 변수를 동시에 결측치를 제거하는 방법

``` r
df_nomiss <- df %>% filter(!is.na(score) & !is.na(gender))
```

4.  함수의 결측치 제외 기능

``` r
mean(df$score, na.rm=T)
exam %>% summarise(mean_math = mean(math, na.rm=T))
```

5.  이상치 확인

``` r
table(outlier$gender)
```

6.  결측 처리

``` r
outlier$gender <- ifelse(outlier$gender == 3, NA, outlier$gender)
```

7.  boxplot으로 극단치 기준 찾기

``` r
boxplot(mpg$hwy)$stats
```

8.  극단치 결측처리

``` r
mpg$hwy <- ifelse(mpg$hwy < 12 || mpg$hwy > 37 , NA, mpg$hwy)
```
