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
