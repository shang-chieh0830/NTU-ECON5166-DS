// Directory
global dir "/Users/weishangjie/Documents/GitHub/NTU-ECON-5166-DS/Proposal"
* 可以貼自己資料夾的路徑到dir引號裡就能跑了～


/* 

_2_30:               not sure whether it should be included in model
Accident_Category:   should not be included in model, don't know what this variable means, so I did not drop it

weather_d:           = 1 if 晴
road_defect_d:       = 1 if 無缺陷
visibility_d:        = 1 if 良好
Traffic_Signals_d:   = 1 if 號誌種類無號誌
license_d:           = 1 if 有適當之駕照
drinking:            還未轉成 0-1 dummy
drinking_d:          = 1 if 有酒精反應(3-8)

It turns out that the signs of the coefficients of these dummies can be quite weird (violate hunch), but
oftentimes, they are not statisitcally significant

*/
use "${dir}/cleaned_data.dta", clear

gen Total_Death_Injury = Number_of_Deaths + Number_of_Injuries

* 將每月的傷亡數加總
egen m_Death = total(Number_of_Deaths), by(Month)
egen m_Injuries = total(Number_of_Injuries), by(Month)
gen m_Total_Death_Injury = m_Death+m_Injuries

rename penalityNum penaltyNum

/*
When there are many occurrences in the dependent variable, don't use poisson regression, simply use OLS
*/


// GLM poisson: dependent variable (Total_Death_Injury)

poisson Total_Death_Injury penaltyNum if Year != 2023, robust

poisson Total_Death_Injury penaltyNum if Year == 2023, robust

poisson Total_Death_Injury penaltyNum , robust


poisson Total_Death_Injury penaltyNum Speed_Limit weather_d road_defect_d visibility_d Traffic_Signals_d license_d drinking_d if Year != 2023, robust


poisson Total_Death_Injury penaltyNum Speed_Limit weather_d road_defect_d visibility_d Traffic_Signals_d license_d drinking_d if Year == 2023, robust


poisson Total_Death_Injury penaltyNum  Speed_Limit  weather_d road_defect_d visibility_d Traffic_Signals_d license_d drinking_d, robust


// GLM poisson: dependent variable(m_Death)
poisson m_Death penaltyNum if Year != 2023, robust

poisson m_Death penaltyNum if Year == 2023, robust 



poisson m_Death penaltyNum, robust 



poisson m_Death penaltyNum Speed_Limit weather_d road_defect_d visibility_d Traffic_Signals_d license_d drinking_d if Year != 2023, robust


poisson m_Death penaltyNum Speed_Limit weather_d road_defect_d visibility_d Traffic_Signals_d license_d drinking_d if Year == 2023, robust


poisson m_Death penaltyNum  Speed_Limit  weather_d road_defect_d visibility_d Traffic_Signals_d license_d drinking_d, robust


// reg: dependent variable(m_Injuries)
reg m_Injuries penaltyNum if Year != 2023, robust

reg m_Injuries penaltyNum if Year == 2023, robust 

reg m_Injuries penaltyNum, robust 


reg m_Injuries penaltyNum  Speed_Limit weather_d road_defect_d visibility_d Traffic_Signals_d license_d drinking_d if Year != 2023, robust


reg m_Injuries penaltyNum  Speed_Limit weather_d road_defect_d visibility_d Traffic_Signals_d license_d drinking_d if Year == 2023, robust

reg m_Injuries penaltyNum Speed_Limit weather_d road_defect_d visibility_d Traffic_Signals_d license_d drinking_d, robust


// reg: dependent variable(m_Total_Death_Injury)


reg m_Total_Death_Injury penaltyNum if Year != 2023, robust

reg m_Total_Death_Injury penaltyNum if Year == 2023, robust 

reg m_Total_Death_Injury penaltyNum, robust 


reg m_Total_Death_Injury penaltyNum  Speed_Limit weather_d road_defect_d visibility_d Traffic_Signals_d license_d drinking_d if Year != 2023, robust


reg m_Total_Death_Injury penaltyNum  Speed_Limit weather_d road_defect_d visibility_d Traffic_Signals_d license_d drinking_d if Year == 2023, robust

reg m_Total_Death_Injury penaltyNum Speed_Limit weather_d road_defect_d visibility_d Traffic_Signals_d license_d drinking_d, robust

