* Only 2023 data are available

* Accident_Category 交通事故類別: a1:車禍當下或24小時內有人死亡; a2:有人受傷或超過24小時後死亡; a3:無人傷亡只有車損 (用不到的變數，姑且保留)
* Accident_Location 事故位置 應該用不到
* penalityNum 用不到

* create a new variable with only numeric values
gen License_Status = regexs(1) if regexm(Driver_Qualification_Status, "([0-9]+)")
gen drinking = regexs(1) if regexm(Drinking_Situation, "([0-9]+)")
gen phone = regexs(1) if regexm(Mobile_Phone, "([0-9]+)")

* Convert the new variable to numeric
destring License_Status, replace
destring drinking, replace
destring phone, replace

gen good_weather_d = ((Weather == 8) & (Month >= 1 & Month <= 6)) | ((Weather == 7) & (Month == 7 | Month == 8))

*道路類別：國道, 快速公路行人禁止, 但只有新表（7,8月）區分出快速公路
* 國道
gen freeway_d = (Road_Type==1)
* 國道，快速公路
gen noway_d = (Road_Type==1) | ((Road_Type == 3) & (Month == 7 | Month == 8))

* 路面缺陷
gen no_road_defect_d = (Road_Defects==4) 

* 障礙物
gen no_obstacle_d = ((Obstacles == 5) & (Month >= 1 & Month <= 6)) | ((Obstacles == 6) & (Month == 7 | Month == 8))

* 視距
gen good_view_d = ((Visibility == 7) & (Month >= 1 & Month <= 6)) | ((Visibility == 6) & (Month == 7 | Month == 8))

* 號誌動作
gen good_signal_d = (Signal_Operation ==1)

* 事故類型及型態: 人與汽(機)車
gen car_people_d = (inrange(Type_and_Nature_of_Accident, 1, 9))

* 當事者區分(類別): 行人
gen H01_d = (Party_Classification =="H01") 

* 駕駛資格情形
gen bad_license_d = ((inrange(License_Status, 2, 7)) & (Month >= 1 & Month <= 6)) | ((inrange(License_Status, 2, 6)) & (Month == 7 | Month == 8))

* 飲酒情形
gen drinking_d = (inrange(drinking, 3, 8))

* 手持行動電話有無使用
gen use_phone_d = (phone==2)





