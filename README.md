# CLIMATEREADY 'Thermal Comfort Survey Amid Heatwaves' Dataset

This repository gives you access to the CLIMATEREADY survey dataset containing thermal comfort votes during the 2021 and 2022 heatwave periods in Pamplona, Spain, as well as other relevant parameters self-reported by surveyees (e.g. occupant characteristics and behaviour, key building/dwelling characteristics, sleep problems, heat-related symptoms), used as case study for the research paper [Exploring indoor thermal comfort and its causes and consequences amid heatwaves in a Southern European city—An unsupervised learning approach](http://dx.doi.org/10.2139/ssrn.4861515) [`SSRN preprint`]. 

This dataset is part of the [CLIMATEREADY research project](https://experience.arcgis.com/experience/a85fb262378b49dc87381261a2e53c91). The aim of this project is the assessment of the adaptability of residential dwellings in Spain to the global warming, promoting passive measures in the design and use of the buildings to get an adequate indoor environment in summer conditions, minimising and quantifying overheating risks and with the minimum cooling.



## Column names and description

| *parameter* | *description* |
| --------------- | --------------- |
| `ID` | Unique dwelling identifier [integer]  |
| `Timestamp` | Data collection timestamp [dd/mm/yyy hh:mm]  |
| `Date` | Data collection date [YYMMDD]  |
| `Hour` | Data collection hour [hh]  |
| `hw_True` | Hot weather condition indicator [boolean, True = 1]  |
| `meanTout` | Mean outdoor temperature [ºC, float]  |
| `ThermostatTemp` | Thermostat temperature setting [ºC, float]  |
| `TSen_day` | Temperature sensation during the day, on the ASHRAE scale [-3 (cold) to +3 (hot), integer]  |
| `TSen_night` | Temperature sensation during the night, on the ASHRAE scale [-3 (cold) to +3 (hot), integer]  |
| `TSatisf_day` | Temperature satisfaction during the day, on the ASHRAE scale [-3 (highly unsatisfied) to +3 (highly satisfied), integer]  |
| `TSatisf_night` | Temperature satisfaction during the night, on the ASHRAE scale [-3 (highly unsatisfied) to +3 (highly satisfied), integer]  |
| `TPref_day` | Temperature preference during the day, on the ASHRAE scale [-1 (prefer cooler) to +1 (prefer warmer), integer]  |
| `TPref_night` | Temperature preference during the night, on the ASHRAE scale [-1 (prefer cooler) to +1 (prefer warmer, integer)]  |
| `Gender` | Respondent gender [boolean, Woman = 1]  |
| `Age` | Respondent age [integer]  |
| `NatVent_night` | Nighttime natural ventilation usage [boolean, True = 1]  |
| `UsesCoolingAlternatives` | Use of alternative cooling (e.g. portable fans) [boolean, True = 1]  |
| `Hour_7_14h_True` | Activity indicator from 7 AM to 2 PM [boolean, True = 1]  |
| `Hour_14_21h_True` | Activity indicator from 2 PM to 9 PM [boolean, True = 1]  |
| `Hour_21_7h_True` | Activity indicator from 9 PM to 7 AM [boolean, True = 1]  |
| `ShadingDevices_No` | No use of shading devices [boolean, True = 1]  |
| `ShadingDevices_WhenDirectSun` | Use shading devices when in direct sun [boolean, True = 1]  |
| `ShadingDevices_AllAfternoon` | Use shading devices all afternoon [boolean, True = 1]  |
| `ShadingDevices_AllMorning` | Use shading devices all morning [boolean, True = 1]  |
| `ShadingDevices_AllDay` | Use shading devices all day [boolean, True = 1]  |
| `NatVent_day_ToutCool` | Use natural ventilation during the day when outside is cooler [boolean, True = 1]  |
| `NatVent_day_Anytime` | Use natural ventilation during the day at any time [boolean, True = 1]  |
| `NatVent_day_No` | No daytime natural ventilation [boolean, True = 1]  |
| `hasAC_No` | No air conditioning [boolean, True = 1]  |
| `hasAC_DormOrLiving` | Air conditioning in dormitory or living area [boolean, True = 1]  |
| `hasAC_DormAndLiving` | Air conditioning in both dormitory and living area [boolean, True = 1]  |
| `hasAC_AllRooms` | Air conditioning in all rooms [boolean, True = 1]  |
| `HouseholdSize` | Number of people in household [integer, True = 1]  |
| `is_31001` | Is in postal code 31001 [boolean, True = 1]  |
| `is_31002` | Is in postal code 31002 [boolean, True = 1]  |
| `is_31003` | Is in postal code 31003 [boolean, True = 1]  |
| `is_31004` | Is in postal code 31004 [boolean, True = 1]  |
| `is_31005` | Is in postal code 31005 [boolean, True = 1]  |
| `is_31006` | Is in postal code 31006 [boolean, True = 1]  |
| `is_31007` | Is in postal code 31007 [boolean, True = 1]  |
| `is_31008` | Is in postal code 31008 [boolean, True = 1]  |
| `is_31009` | Is in postal code 31009 [boolean, True = 1]  |
| `is_31010` | Is in postal code 31010 [boolean, True = 1]  |
| `is_31011` | Is in postal code 31011 [boolean, True = 1]  |
| `is_31012` | Is in postal code 31012 [boolean, True = 1]  |
| `is_31013` | Is in postal code 31013 [boolean, True = 1]  |
| `is_31014` | Is in postal code 31014 [boolean, True = 1]  |
| `is_31015` | Is in postal code 31015 [boolean, True = 1]  |
| `is_31016` | Is in postal code 31016 [boolean, True = 1]  |
| `isNot_pamplona` | Is not in Pamplona [boolean, True = 1]  |
| `before_1980` | Building built before 1980 [boolean, True = 1]  |
| `between_1980_2006` | Building built between 1980 and 2006 [boolean, True = 1]  |
| `after_2007` | Building built after 2007 [boolean, True = 1]  |
| `dwelling_OldTown` | Located in old town [boolean, True = 1]  |
| `dwelling_Block` | Located in a block [boolean, True = 1]  |
| `dwelling_Tower` | Located in a tower [boolean, True = 1]  |
| `dwelling_Detached` | Single-family dwelling [boolean, True = 1]  |
| `dwelling_Other` | Other types of dwelling [boolean, True = 1]  |
| `Rehab_No` | No retrofitting, or only structural or accessibility retrofitting [boolean, True = 1]  |
| `Rehab_Yes` | Energy retrofitting: wall and/or roof insulation, window replacement [boolean, True = 1]  |
| `Income_below1500` | Monthly income below 1500 [boolean, True = 1]  |
| `Income_between_1500_3500` | Monthly income between 1500 and 3500 [boolean, True = 1]  |
| `Income_above_3500` | Monthly income above 3500 [boolean, True = 1]  |
| `Occ_NormallyAtHome` | Normally at home [boolean, True = 1]  |
| `Occ_NotAlwaysAtHome` | Not always at home [boolean, True = 1]  |
| `SrfcArea_below90` | Surface area below 90 sqm [boolean, True = 1]  |
| `Storey_UpperFloor` | Upper floor dwelling [boolean, True = 1]  |
| `Storey_NotApartment` | Not an apartment but a single-family dwelling [boolean], True = 1  |
| `numOrient_1` | Dwelling has only one orientation [boolean, True = 1]  |
| `numOrient_above2` | Dwelling has more than two orientations [boolean, True = 1]  |
| `LivRoom_SrfcAreaWindow_below2` | Living room window surface area below 2 sqm [boolean, True = 1]  |
| `LivRoom_SrfcAreaWindow_above2` | Living room window surface area above 2 sqm [boolean, True = 1]  |
| `Bedroom_SrfcAreaWindow_below2` | Bedroom window surface area below 2 sqm [boolean, True = 1]  |
| `Bedroom_SrfcAreaWindow_above2` | Bedroom window surface area above 2 sqm [boolean, True = 1]  |
| `AC_Installed_Yes` | Dwelling has air conditioning installed [boolean, True = 1]  |
| `WouldYouInstallAC_Yes` | Would install AC? [boolean, True = 1]  |
| `hasCoolRoom` | Has 'cool' room (i.e. 'cool' retreat) [boolean, True = 1]  |
| `hasCoolingAlternatives` | Occupant has cooling alternatives (e.g. portable fans) [boolean, True = 1]  |
| `HeatSymptoms` | Occupant has heat symptoms during the day (e.g. dizziness or low blood pressure, headache, palpitations, hyperventilation) [boolean, True = 1]  |
| `SleepingProblems` | Occupant reports having sleep problems due to heat  [boolean, True = 1]  |


## Preview HTML file
Download the `climateready.html` file, and once downloaded, open it with your default PC browser.


## Please cite us if you use this dataset
Gamero-Salinas, J., López-Hernández, D., Gonzalez-Martinez, P., Arriazu-Ramos, A., Monge-Barrio, A., & Sánchez-Ostiz, A. (2024). Exploring Indoor Thermal Comfort and its Causes and Consequences Amid Heatwaves in a Southern European City—An Unsupervised Learning Approach. Available at SSRN: https://ssrn.com/abstract=4861515 or http://dx.doi.org/10.2139/ssrn.4861515
