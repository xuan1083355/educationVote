#姓名:王宣筑  學號:A1083355  R期末project
install.packages("readxl")
library(readxl) 
library(tools)
library(tidyverse)
library(magrittr)

#設定讀取路徑
setwd(getwd())

#讀檔
tckt<-read.csv("rftckt.csv")  #公投票
area<-read.csv("rfarea.csv",fileEncoding ="UTF-8")  #中文有亂碼，故須加fileEncoding ="UTF-8"

#####萃取資料
tckt%<>%filter(prv_code>0,city_code==0,area_code==0,dept_code==0)
area%<>%filter(prv_code>0,city_code==0,area_code==0,dept_code==0)
#first:第一個合併檔(公投票+地區)
first<-area%>%select("prv_code","area_name")%>%left_join(tckt,by="prv_code")%>%select(prv_code,area_name,agree_ticket_percent)

#教育程度
edu<-read_xlsx("education2021.xlsx")
edu%<>%rename(area="02-02 臺閩地區十五歲以上人口戶籍註記教育程度 Population of 15 Years and Over by Educational Attainment in Taiwan-Fuchien Area")
edu%<>%rename(sex=2,fifteen_up_people=4,totalliterate=5,graduate_school=6,graduate_school_rate=7,university=8,university_rate=9,
               junior_college_2or3=10,junior_college_2or3_rate=11,junior_college_last2=12,junior_college_last2_rate=13,senior_high=14,senior_high_rate=15,
               senior_vocational=16,senior_vocational_rate=17,junior_high=19,junior_high_rate=20,
               junior_vocational=21,junior_vocational_rate=22,primary=23,primary_rate=24,self_study=25,illeterate=26)

#公投票檔與教育程度合併(ff)
ff<- first%>%left_join(edu,by=c("area_name"="area"))
ff%<>%mutate(graduate_school_rate=as.numeric(graduate_school)/as.numeric(fifteen_up_people),
             university_rate=as.numeric(university)/as.numeric(fifteen_up_people),
             junior_college_2or3_rate=as.numeric(junior_college_2or3)/as.numeric(fifteen_up_people),
             junior_college_last2_rate=as.numeric(junior_college_last2)/as.numeric(fifteen_up_people),
             senior_high_rate=as.numeric(senior_high)/as.numeric(fifteen_up_people),
             senior_vocational_rate=as.numeric(senior_vocational)/as.numeric(fifteen_up_people),
             junior_high_rate=as.numeric(junior_high)/as.numeric(fifteen_up_people),
             junior_vocational_rate=as.numeric(junior_vocational)/as.numeric(fifteen_up_people),
             primary_rate=as.numeric(primary)/as.numeric(fifteen_up_people),
             self_study=as.numeric(self_study)/as.numeric(fifteen_up_people),
             illeterate=as.numeric(illeterate)/as.numeric(fifteen_up_people),
             university_up=graduate_school_rate+university_rate,
             junior_rate=junior_high_rate+junior_vocational_rate,
             senior_rate=junior_college_2or3_rate+junior_college_last2_rate+senior_high_rate+senior_vocational_rate)

#資料變長
#final_draw_ff 用來繪圖的資料集
final_draw_ff<- ff%>%select(c(2:3,graduate_school_rate,university_rate,senior_rate,junior_rate,primary_rate,university_up))
final_draw_ff%<>%pivot_longer(
  col=-c(area_name,agree_ticket_percent,university_up),
  names_to = "education_level",
  values_to = "rate"
)


#整理
final_draw_ff%<>%mutate(education_level=case_when(
  .$education_level=="graduate_school_rate"~"研究所",
  .$education_level=="university_rate"~"大學",
  .$education_level=="senior_rate"~"高中/職",
  .$education_level=="junior_rate"~"國中",
  .$education_level=="primary_rate"~"國小"
))
#依照同意票數由大排到小
final_draw_ff%<>%group_by(area_name,agree_ticket_percent)%>%arrange(desc(agree_ticket_percent))

#繪圖
##1.各城市"整體"教育水準之於修憲複決同意率
final_draw_ff%>%group_by(area_name,agree_ticket_percent)%>%arrange(desc(agree_ticket_percent))%>%
  ggplot(aes(y=agree_ticket_percent,x=rate,color=education_level))+
  geom_count(position="jitter",size=4)+
  geom_hline(aes(yintercept=agree_ticket_percent),linetype="dotdash",colour="dark blue")+
  facet_grid(area_name~.)+
  labs(x="教育程度占比",
       y="修憲複決同意率",
       title="各區教育程度之於修憲複決同意率",
       color="教育程度")+
  theme_classic()+
  ylim(30,60)

##1-2.
final_draw_ff%>%group_by(area_name,agree_ticket_percent)%>%arrange(desc(agree_ticket_percent))%>%
  ggplot(aes(y=agree_ticket_percent,x=rate,color=education_level))+
  geom_count(position="jitter",size=4)+
  geom_hline(aes(yintercept=agree_ticket_percent),linetype="dotdash",colour="dark blue")+coord_polar()+
  facet_grid(area_name~.)+
  labs(x="教育程度占比",
       y="修憲複決同意率",
       title="各區教育程度之於修憲複決同意率",
       color="教育程度")+
  theme_classic()+
  ylim(30,60)

##2.教育程度與公投同意票數的摺線圖
final_draw_ff%>%
  ggplot()+
  geom_line(aes(x=agree_ticket_percent,y=rate,color=education_level))+
  labs(x="修憲複決同意率",y="教育程度占比",
       title="修憲同意率與教育程度",
       color="教育程度")+
  theme_gray()
  

###3.高等教育(大學+研究所) VS 同意票
final_draw_ff%>% 
  ggplot(aes(x=agree_ticket_percent,y=university_up))+
  geom_smooth()+
  labs(x="修憲複決同意率",
       y="教育程度大學(含)以上",
       title="大學以上教育程度VS修憲複決同意率")+
  theme_bw()





