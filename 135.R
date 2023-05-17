# 필요한 패키지 설치
install.packages("httr")
install.packages("jsonlite")
install.packages("tidyverse")
# 라이브러리 로드
library(httr)
library(jsonlite)

# API 주소
url <- "https://api.finance.naver.com/siseJson.naver?symbol=005930&requestType=1&startTime=20190803&endTime=20210705&timeframe=day"

# GET 요청 보내기
response <- GET(url)

# 응답 데이터 파싱
content <- content(response, as = "text")

# JSON 데이터 추출
json_data <- gsub("'{1,2}", "\"", content)
json_data <- gsub("^.*?\\[\\[", "[[", json_data)
json_data <- gsub(",\\]", "]", json_data)

# JSON 데이터를 데이터프레임으로 변환
df <- fromJSON(json_data, simplifyDataFrame = TRUE)

df
# 결과 확인
head(df)

#--------
#함수로 
library(httr)
library(jsonlite)

get_stock_data <- function(code, start_date, end_date) {
  #API 주소생성
  url <- sprintf("https://api.finance.naver.com/siseJson.naver?symbol=%s&requestType=1&startTime=%s&endTime=%s&timeframe=day",
                 code, start_date, end_date)
  #API 요청 보내기 
  response <- GET(url)
  content <- content(response, as = "text")
  
  #json 데이터 추출 및 가공 
  json_data <- gsub("'{1,2}", "\"", content)
  json_data <- gsub("^.*?\\[\\[", "[[", json_data)
  json_data <- gsub(",\\]", "]", json_data)
  
  #데이터프레임으로 변환 
  df <- fromJSON(json_data, simplifyDataFrame = TRUE)
  
  #첫번째 행을 열 이름으로 설정 
  colnames(df) <- unlist(df[1, ])
  df <- df[-1, ]
  return(df)
}

# 삼성전자 , 20220310~20230515
code <- "005930"  # 종목 코드
start_date <- "20220310"  # 시작일
end_date <- "20230515"  # 종료일

#주식데이터 가져오기 
df <- get_stock_data(code, start_date, end_date)