# 修憲複決同意率與教育程度之關聯性
## 專案介紹
本專案旨在運用R語言進行數據分析，探討修憲複決同意率與教育程度之間的關聯性。

## 資料來源
1. **2022全國性公民投票計票結果**: 政府開放平台 (https://data.gov.tw/dataset/95883)
2. **15歲以上人口識字率**: 臺閩地區十五歲以上人口戶籍註記教育程度 (https://www.gender.ey.gov.tw/gecdb/Stat_Statistics_DetailData.aspx?sn=cC3K6vUAfeUlTCcfbr03CQ%40%40)

## 文件列表
- `README.md`: 專案說明文件
- `RFinalProject.R`: 主程式
- `education2021.xlsx`: 教育程度相關數據
- `rfarea.csv`: 區域數據
- `rftckt.csv`: 投票數據

## 如何使用
1. 下載此Repository
2. 使用RStudio或任何R語言環境開啟`RFinalProject.R`
3. 確保所有資料集（`education2021.xlsx`, `rfarea.csv`, `rftckt.csv`）在同一目錄下
4. 執行`RFinalProject.R`進行數據分析

## 分析結果
1. 修憲同意率與教育程度

![image](https://github.com/xuan1083355/educationVote/assets/100353401/8cfccbc5-7122-414c-93ca-c60ca6484647)

2. 高等教育程度(大學及大學以上) 之於修憲同意率  
(*註：X軸為修憲複決同意率，Y軸為高等教育程度占比)

![image](https://github.com/xuan1083355/educationVote/assets/100353401/53e6b4f8-133e-4845-8cee-c6dee5809677)

