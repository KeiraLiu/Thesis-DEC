/**********************************************************************
*** WFP PROJECT: Ecuador       								 			***
*** DV analysis	for AEJ paper      		 						 		***
*** 																	***
***	This do-file creates variables, tables, and graphs for AEJ paper	***
*** 																	***
***	BY Melissa Hidrobo                 									***
*** 																	***	
***********************************************************************/
clear all
set mem 100m
set more off

global DATA  "D:\Melissa Hidrobo\WFP\Ecuador\Paper 2- DV\Quant analysis\Drafts\AEJ submission\Data and dofiles\Data"
global TABLES "D:\Melissa Hidrobo\WFP\Ecuador\Paper 2- DV\Quant analysis\Drafts\AEJ submission\Data and dofiles\Tables"
global GRAPHS "D:\Melissa Hidrobo\WFP\Ecuador\Paper 2- DV\Quant analysis\Drafts\AEJ submission\Data and dofiles\Graphs"


use "$DATA\DV_baseline_followup", clear


******************************1. Cleaning and Creating indicators***********************************

*there are 17 obs with ids that do not match from baseline to followup. 
	tab diffid if bl_t10~=. & el_t10~=.
	list a01  bl_b04 bl_id0t el_idsecc_t  el_b04 if diffid==1 & bl_t10~=. & el_t10~=.

*creating treatment indicators
	rename bl_p_treat p_treat
	label var p_treat "Pooled Treatment"
	rename bl_modalidad Treatment
	tab Treatment, g(treat)

* creating in relationship indicator
	g bl_inrelat=bl_b06==2|bl_b06==3 if bl_b06~=.
	g el_inrelat=el_b06==2|el_b06==3 if el_b06~=.

**creating count of same women administered IPV from baseline and follow-up**

	*households with female head or spouse
	tab p_treat if bl_tnohaymujer==1 & (bl_b03==1 | bl_b03==2)
	
	*baseline sample (women in relationship 15-69 yrs and spouse or head)
	tab p_treat if bl_inrelat==1  & bl_b04<70 & bl_tnohaymujer==1 & (bl_b03==1 | bl_b03==2)

	*baseline administered ipv
	tab p_treat if bl_tb==1 & bl_inrelat==1  & bl_b04<70 & bl_tnohaymujer==1 & (bl_b03==1 | bl_b03==2)
	tab bl_tb if bl_inrelat==1  & bl_b04<70 & bl_tnohaymujer==1 & (bl_b03==1 | bl_b03==2)

	*follow-up
	tab p_treat if el_a23<4& bl_tb==1 & bl_inrelat==1 & bl_b04<70 & diffid==0 &  el_tnohaymujer==1 & (bl_b03==1 | bl_b03==2)

	*adminstered ipv and same women
	tab p_treat if el_a23<4& el_tb==1 &  bl_tb==1 & bl_inrelat==1 & bl_b04<70 & diffid==0 & (bl_b03==1 | bl_b03==2)
	tab el_tb if el_a23<4& bl_tb==1 & bl_inrelat==1 & bl_b04<70 & diffid==0 & (bl_b03==1 | bl_b03==2)
	
	*of those not administ IPV at endline, what percent were no longer in relationship?
	tab el_inrelat if el_tb==2 & el_a23<4& bl_tb==1 & bl_inrelat==1 & bl_b04<70 & diffid==0 & (bl_b03==1 | bl_b03==2)


*recoding province var
	recode bl_a02 (2=0)
	label var bl_a02 "Carchi"

****creating DV indicators****
	*cleaning indicators for last 6 months of violence
	forvalues n=10/28{
		replace el_t`n'b=0 if el_t`n'b==. & el_t`n'==0 
		}

	tabstat el_t10-el_t28b el_t19-el_t18b, s(min max n)

	forvalues n=10/23{
		replace bl_t`n'b=0 if bl_t`n'b==. & bl_t`n'==0 
		}
		
	*FU 6 month indicators 
	g el_physical= el_t15b==1| el_t16b==1 | el_t17b==1 | el_t18b==1 | el_t19b==1 | ///
		el_t20b==1 | el_t21b==1 |el_t22b==1 | el_t23b==1 if el_t15b~=.
		label var el_physical "Physical and sexual violence"
	egen el_nphysical=rowtotal(el_t15b el_t16b el_t17b el_t18b el_t19b el_t20b el_t21b el_t22b el_t23b) if el_t15b~=.
		label var el_nphysical "Number of physical or sexual violence acts (0-9)"	
	g el_mphysical= el_t15b==1| el_t16b==1 if el_t15b~=.
		label var el_mphysical "Moderate physical"
	g el_sphysical=  el_t17b==1 | el_t18b==1 | el_t19b==1 | el_t20b==1 | el_t21b==1  if el_t17b~=.
		label var el_sphysical "Severe physical"	
	g el_control=el_t10b==1| el_t11b==1 | el_t25b==1 | el_t26b==1  if el_t10b~=.
		label var el_control "Controlling behaviors"
	g el_emotional=el_t12b==1 | el_t13b==1 | el_t14b==1 | el_t24b==1 | el_t27b==1 | el_t28b==1 if el_t12b~=.
		label var el_emotional "Emotional violence"
	egen el_ncontrol=rowtotal(el_t10b el_t11b el_t25b el_t26b)  if el_t10b~=.
		label var el_ncontrol "Number of controlling behaviors (0-4)"
	egen el_nemotional=rowtotal(el_t12b el_t13b el_t14b el_t24b el_t27b el_t28b) if el_t12b~=.
		label var el_nemotional "Number of emotional violence acts (0-6)"

	*Basline 6 month indicator
	g bl_control=bl_t10b==1| bl_t11b==1  if bl_t10b~=.
		label var bl_control "Controlling behaviors"
	g bl_emotional=bl_t12b==1 | bl_t13b==1 | bl_t14b==1 if bl_t12b~=.
		label var bl_emotional "Emotional violence"
	egen bl_ncontrol=rowtotal(bl_t10b bl_t11b)  if bl_t10b~=.
		label var bl_ncontrol "Number of controlling behaviors (0-2)"
	egen bl_nemotional=rowtotal(bl_t12b bl_t13b bl_t14b) if bl_t12b~=.
		label var bl_nemotional "Number of emotional violence acts (0-3)"
	g bl_physical= bl_t15b==1 | bl_t16b==1 | bl_t17b==1 | bl_t18b==1 | bl_t19b==1 | bl_t20b==1 | ///
		bl_t21b==1  |bl_t22b==1 | bl_t23b==1 if bl_t15b~=.
		label var bl_physical "Physical and or sexual violence"
	egen bl_nphysical=rowtotal(bl_t15b bl_t16b bl_t17b bl_t18b bl_t19b bl_t20b bl_t21b bl_t22b bl_t23b) if bl_t15b~=.
		label var bl_nphysical "Number of physical or sexual violence acts"	
	g bl_mphysical= bl_t15b==1| bl_t16b==1 if bl_t15b~=.
		label var bl_mphysical "Baseline moderate physical violence"
	g bl_sphysical= bl_t17b==1 | bl_t18b==1 | bl_t19b==1 | bl_t20b==1 | bl_t21b==1  if bl_t15b~=.
		label var bl_sphysical "Baseline severe physical violence"	

	*Baseline Lifetime violence
	g bl_lcontrol=bl_t10==1| bl_t11==1  if bl_t10~=.
		label var bl_lcontrol "Lifetime controlling"
	g bl_lemotional=bl_t12==1 | bl_t13==1 | bl_t14==1 if bl_t12~=.
		label var bl_lemotional "Lifetime emotional"
	g bl_lphysical= bl_t15==1 | bl_t16==1 | bl_t17==1 | bl_t18==1 | bl_t19==1 | bl_t20==1 | bl_t21==1 if bl_t15~=.
		label var bl_lphysical "Lifetime physical"	
	g bl_lsexual=bl_t22==1 | bl_t23==1 if bl_t22~=.
		label var bl_lsexual "Lifetime sexual"
	g bl_lany= bl_lemotional==1| bl_lphysical==1| bl_lsexual==1 if bl_lphysical~=.		
		label var bl_lany "Lifetime any violence"
	g bl_lphysex= bl_lphysical==1| bl_lsexual==1 if bl_lphysical~=.		
		label var bl_lphysex "Lifetime physical and or sexual violence"

	*labels
	foreach t in el bl{
		label var `t'_t10b "Accused you of being unfaithful"
		label var `t'_t11b "Tried to limit your contact with your family"
		label var `t'_t12b "Humiliated or insulted you"
		label var `t'_t13b "Threatened to leave you"
		label var `t'_t14b "Threatened to take away your children"
		label var `t'_t15b "Pushed you or shook you or threw something at you"
		label var `t'_t16b "Slapped you or twisted your arm"
		label var `t'_t17b "Hit you with his fist or something else that could hurt you"
		label var `t'_t18b "Kicked you or dragged you"
		label var `t'_t19b "Tried to choke or burn you"
		label var `t'_t20b "Attacked you with a gun knife or other weapon"
		label var `t'_t21b "Threatened you with a gun knife or other weapon"
		label var `t'_t22b "Physically forced you to have sexual intercourse"
		label var `t'_t23b "Forced you to do something sexual that you found degrading"
	}
		label var el_t24b "Threatened to hurt you or someone you care about"
		label var el_t25b "Tried to limit your contact with friends"
		label var el_t26b "Wanted to know where you were at all times"
		label var el_t27b "Ignored you or was indifferent towards you"
		label var el_t28b "Humiliated or insulted you in front of others"
	
**control variables - women level
	*edu
	g bl_edu_sec=bl_b09>3 if bl_b09~=.
	label var bl_edu_sec "Some secondary education or higher"
	g el_edu_sec=el_b09>3 if el_b09~=.
	label var el_edu_sec "Some secondary education or higher"
	*age
	gen diffage=el_b04-bl_b04
	label var bl_b04 "Age"
	label var el_b04 "Age"
	*nationality
	g bl_colom=bl_b08==2 if bl_b08~=.
	label var bl_colom "Colombian"
	g colomb= el_b08f1==2 if  el_b08f1~=.
	replace colomb=bl_colom if colomb==.
	label var colomb "Born in Colombia"
	*marital status
	g bl_married=bl_b06==3 if bl_b06~=.
	label var bl_married "Married"
	*ethnicity
	g bl_indig=bl_b07==2 if bl_b07~=.
	label var bl_indig "Indigenous"
	g bl_black=bl_b07==3  | bl_b07==5 if bl_b07~=.
	label var bl_black "Afro-Ecuadorian"
	*head of household
	g bl_head=bl_b03==1 if bl_b03~=.
	label var bl_head "Head of household"

	*women owns house
	g houseownership=1 if bl_e12==1 & bl_b03==1
	  replace houseownership=1 if bl_e12==2 & bl_b03==2
	  replace houseownership=2 if bl_e12==1 & bl_b03==2
	  replace houseownership=2 if bl_e12==2 & bl_b03==1
	  replace houseownership=3 if bl_e12==4
	  replace houseownership=4 if bl_e12==3 | bl_e12==5 | bl_e12==6
	  replace houseownership=5 if bl_e12==7 | bl_e12==8 | bl_e12==9
	label define own 1 "Women owns household" ///
					2 " Husband owns household" ///
					3 "Husband and wife own household" ///
					4 "Other ownership" ///
					5 "Other non-ownership (rent, borrowed)"  
	label value houseownership own
	label var houseownership "Ownership status of house"
	
	g ownhouse=houseownership==1 if houseownership~=.
	label var ownhouse "Sole owner of house"
	
**control variables - household level 
	*children
	label var  bl_nchildren0t5 "Number of children 0-5 years in household"
	label var  bl_nchildren6t14 "Number of children 6-15 years in household"
	*assets
	xtile bl_asset_cat=bl_asset_index, nq(4)
	label var bl_asset_cat "Wealth quartile"
	label var bl_asset_index "Asset index"
	tab bl_asset_cat, g(wealth)
	label var wealth1 "Wealth index: 1st quartile"
	label var wealth2 "Wealth index: 2nd quartile"
	label var wealth3 "Wealth index: 3rd quartile"
	label var wealth4 "Wealth index: 4th quartile"
	*house
	g norooms=bl_e06==0 if bl_e06~=.
	label var norooms "House does not have rooms exclusively for sleeping"
	
** hh consumption	**
	foreach t in bl el {
	rename  `t'_fneh_totcons_pc  `t'_totcons_pc
	} 
		
	*changing to monthly and creating logs, aggregates
	foreach t in bl el {
	foreach cons in totcons nfcons  {
		replace `t'_`cons'_pc=`t'_`cons'_pc*(365/12)
		g `t'_log`cons'_pc=ln(1+`t'_`cons'_pc)
		}
	}
	label var bl_totcons_pc "Value of total consumption per capita (USD), monthly"
	label var bl_nfcons_pc "Value of nonfood consumption per capita (USD), monthly"

	*changing to monthly and creating logs, clothes
	foreach t in bl el {
	forvalues n=12/14{
		replace `t'_nfcons_pc_`n'=`t'_nfcons_pc_`n'*(365/12)
		replace `t'_nfcons_pc_`n'=. if `t'_nfcons_pc==.
		g `t'_lognfcons_pc_`n'=ln(1+`t'_nfcons_pc_`n') 
		label var `t'_nfcons_pc_`n' "Monthly per capita consumption(USD): ."
		label var `t'_lognfcons_pc_`n' "Log monthly per capita consumption(USD): ."
	}
	}
	
	*creating adult clothes
	foreach t in bl el{
		g `t'_nfcons_pc_adultc=`t'_nfcons_pc_12+`t'_nfcons_pc_13
		g `t'_lognfcons_pc_adultc=ln(1+`t'_nfcons_pc_adultc) 
		label var `t'_nfcons_pc_adultc "Monthly per capita consumption(USD): adult clothes"
		label var `t'_lognfcons_pc_adultc "Log monthly per capita consumption(USD): adult clothes"
		}
	
	*creating indicator for purchase
	foreach t in bl el {
	foreach n in adultc 14{
		g `t'_dnfcons_pc_`n'=`t'_nfcons_pc_`n'>0 if `t'_nfcons_pc_`n'~=.
		}
		}
		

	*shares using total exp (food+nonfood+edu+health) and nonfood expenditures
	foreach t in bl el{
		
		*child clothes shares over total exp
		g `t'_share_pc_14= `t'_nfcons_pc_14/`t'_totcons_pc	
		
		*adult clothing share over total exp
		g `t'_share_pc_adultc= `t'_nfcons_pc_adultc/`t'_totcons_pc	
	
	
		*clothing share over total nonfood
		foreach var in  adultc 14{
			g `t'_nfshare_pc_`var'= `t'_nfcons_pc_`var'/`t'_nfcons_pc	
		}
	}

** partner variables **
	g bl_partn_edu=bl_mhead_edu if bl_b03==2
	replace bl_partn_edu=bl_mspouse_edu if bl_b03==1
	replace bl_partn_edu=el_mhead_edu if bl_b03==2 & bl_partn_edu==.
	replace bl_partn_edu=el_mspouse_edu if bl_b03==1 & bl_partn_edu==.
	label var bl_partn_edu "Partner's edu"

	g bl_partn_sedu=bl_partn_edu>=4 & bl_partn_edu<9 if bl_partn_edu~=.
	label var bl_partn_sedu "Partner has some secondary education or higher"

	g bl_partn_age=bl_mhead_age if bl_b03==2
	replace bl_partn_age=bl_mspouse_age if bl_b03==1
	replace bl_partn_age=el_mhead_age-1 if bl_b03==2 & bl_partn_age==.
	replace bl_partn_age=el_mspouse_age-1 if bl_b03==1 & bl_partn_age==.
	label var bl_partn_age "Partner's age"

	foreach t in el bl {
		g `t'_partn_empl=`t'_mhead_empl if bl_b03==2
		replace `t'_partn_empl=`t'_mspouse_empl if bl_b03==1
		label var `t'_partn_empl "Partner's employment"
		
		g `t'_partn_dempl=`t'_partn_empl~=5 if `t'_partn_empl~=.
		label var `t'_partn_dempl "Partner worked in the last 6 months"

		forvalues n=1/4{
			g `t'_partn_empl`n'=`t'_mhead_empl`n' if bl_b03==2
			replace `t'_partn_empl`n'=`t'_mspouse_empl`n' if bl_b03==1
			recode `t'_partn_empl`n' (2=0)
			}
		label var `t'_partn_empl1 "Partner worked in agriculture on family land"
		label var `t'_partn_empl2 "Partner worked in agriculture, salaried"
		label var `t'_partn_empl3 "Partner worked in non-agriculture, salaried labor"
		label var `t'_partn_empl4 "Partner worked in independent, non-agr labor"
		
		g `t'_partn_hrworked=`t'_mhead_hrworked if bl_b03==2
		replace `t'_partn_hrworked=`t'_mspouse_hrworked if bl_b03==1
		replace `t'_partn_hrworked=0 if `t'_partn_dempl==0
		label var `t'_partn_hrworked "Partner's hours worked in a typical week"
		
		g `t'_partn_domlabor=`t'_mhead_domlabor if bl_b03==2
		replace `t'_partn_domlabor=`t'_mspouse_domlabor if bl_b03==1
		recode `t'_partn_domlabor (2=0)
		label var `t'_partn_domlabor "Partner engaged in domestic labor in last 2 weeks"
		
		g `t'_partn_domlaborhr=`t'_mhead_domlaborhr if bl_b03==2
		replace `t'_partn_domlaborhr=`t'_mspouse_domlaborhr if bl_b03==1
		replace `t'_partn_domlaborhr=0 if `t'_partn_domlabor==2
		label var `t'_partn_domlaborhr "Partner's hours in domestic labor in a typical day"
		
	}
	
	*one endline spouse is new to household 
	foreach var in empl hrworked domlabor domlaborhr {
		replace el_partn_`var' =el_mspouse_`var' if a01== 430153
	}
	replace el_partn_dempl=1 if el_partn_empl~=5 &  a01== 430153
	
	
** women  work variables **
	foreach t in el bl {
	
	recode `t'_d01 `t'_d02 `t'_d03 `t'_d04 (2=0)
	label var `t'_d01 "Worked in agriculture on family land"
	label var `t'_d02 "Worked in agriculture, salaried labor"
	label var `t'_d03 "Worked in non-agriculture, salaried labor"
	label var `t'_d04 "Worked independent, non-agriculture labor"
	
	g `t'_dempl=`t'_d05~=5 if `t'_d05~=.
	label var `t'_dempl "Worked in the last 6 months"

	g `t'_hr_worked=`t'_d06 
	replace `t'_hr_worked=0 if `t'_d05==5 & `t'_hr_worked==.
	label var `t'_hr_worked "Hours worked in a typical week"
	
	g `t'_domlaborhr=`t'_d11
	replace `t'_domlaborhr=0 if `t'_d10==2 & `t'_d11==.
	label var `t'_domlaborhr "Hours worked in domestic labor in a typical day"
	
	recode `t'_d10 el_d10 (2=0)
	label var `t'_d10 "Engaged in domestic labor in last 2 weeks"
	}
	
*attrition and sample analysis indicators
	g eligible=bl_inrelat==1  & bl_b04<70 & bl_tnohaymujer==1 & (bl_b03==1 | bl_b03==2)
	label var eligible "Households with eligible women at baseline"
	
	g foranalysis= bl_tb==1 & el_tb==1 & diffid==0 & eligible==1
	label var foranalysis "Households with eligible women administered IPV at baseline and follow-up"
	g foranalysis_inv=foranalysis==0 if foranalysis~=.


*Lee bounds:calculating lower and upper bounds for Lee bounds below. Using only sample of eligible women
	
	*calculating p 
	sum foranalysis if p_treat==0 & eligible==1
		g obsC=r(mean) in 1/1
	sum foranalysis if p_treat==1 & eligible==1
		g obsT=r(mean) in 1/1
	g p=abs((obsT-obsC)/obsT)
	
	*by treatment arm
	forvalues n=1/3{
		sum foranalysis if Treatment==`n' & eligible==1
		g obsT_`n'=r(mean) in 1/1
		g p_`n'=abs((obsT_`n'-obsC)/obsT_`n')
		}
	
	foreach var in el_control el_emotional el_mphysical el_sphysical el_physical{
		*calculating trimmed area on lower tail in order to generate an upper bound
		egen rank_`var'=rank(`var') if p_treat==1 & eligible==1, unique
		local i=p
		local i1=`i'*100
		egen  upct_`var' = pctile(rank_`var') if `var'~=. & p_treat==1 & eligible==1, p(`i1')
		g utrim_`var'=rank_`var'<upct_`var' if p_treat==1 & `var'~=. & eligible==1

		*calculating trimmed area in upper tail in order to generate lower bound
		local i2=(100-`i1')
		egen lpct_`var' = pctile(rank_`var') if `var'~=. & p_treat==1 & eligible==1, p(`i2')
		g ltrim_`var'=rank_`var'>=lpct_`var' if p_treat==1 & `var'~=. & eligible==1
	}
	
	*by treatment arm
	foreach var in  el_control el_emotional el_mphysical el_sphysical el_physical{
		forvalues n=1/3{
		*calculating trimmed area on lower tail in order to generate an upper bound
		egen rank_`var'_`n'=rank(`var') if Treatment==`n', unique
		local i=p_`n'
		local i1=`i'*100
		egen  upct_`var'_`n' = pctile(rank_`var'_`n') if `var'~=. & Treatment==`n', p(`i1')
		g utrim_`var'_`n'=rank_`var'_`n'<upct_`var'_`n' if Treatment==`n'& `var'~=.

		*calculating trimmed area in upper tail in order to generate lower bound
		local i2=(100-`i1')
		egen lpct_`var'_`n' = pctile(rank_`var'_`n') if `var'~=. & Treatment==`n', p(`i2')
		g ltrim_`var'_`n'=rank_`var'_`n'>=lpct_`var'_`n' if Treatment==`n' & `var'~=.
	}
	}


***************************** 2. Means	and attrition	 *************************


global descript bl_head colomb bl_b04 bl_edu_sec bl_married bl_indig bl_black bl_dempl ownhouse  ///
	bl_partn_sedu bl_partn_age bl_partn_dempl bl_partn_hrworked  ///
	 bl_nchildren0t5 bl_nchildren6t14  bl_totcons_pc norooms   ///
	 bl_lphysex bl_control bl_emotional bl_physical 
	

*Table 1: balance pooled treatment and control

	*attrition-pooled treatment
	outreg, clear
	mean foranalysis_inv  if eligible==1
		matrix n=e(_N)
		matrix m0=e(b)
	mean foranalysis_inv  if eligible==1, over(p_treat) vce(cluster bl_a05)
		matrix m1=e(b)
	test[foranalysis_inv]control=[foranalysis_inv]treated
		matrix p=r(p)
	matrix attrit=n, m0, m1, p
	matrix rownames attrit="Attrition rate"
	
	*balance
	foreach var in $descript {
		
		mean `var' if `var'~=. &  foranalysis==1
		matrix n`var'=e(_N)
		matrix m0`var'=e(b)
		mean `var'  if `var'~=. &  foranalysis==1, over(p_treat) vce(cluster bl_a05)
		matrix m1`var'=e(b)
		test[`var']control=[`var']treated
		matrix p`var'=r(p)
		matrix `var'=n`var', m0`var', m1`var', p`var'
		matrix rownames `var'=`var'
		}
	matrix  balance=attrit\ bl_head \colomb\ bl_b04 \bl_edu_sec \bl_married \ ///
		bl_indig\ bl_black \bl_dempl \ ownhouse \ ///
		bl_partn_sedu\ bl_partn_age \bl_partn_dempl \bl_partn_hrworked\  ///
		bl_nchildren0t5 \bl_nchildren6t14 \ bl_totcons_pc\  norooms \ ///
		bl_lphysex \bl_control \bl_emotional \bl_physical 

	
	*joint test: regression of all
		regr p_treat $descript if foranalysis==1, vce(clu bl_a05)
			testparm $descript
			matrix pa=r(p)
			
		matrix m=.,.,.,.,pa
		matrix rownames m="P-value from joint F-test" 
		matrix M=balance\m
	
	frmttable using "$TABLES\Analysis", replace statmat(M) sdec(0, 2, 2, 2 ,2)  ///
		title(Table 1: Baseline means by intervention arm)   coljust(l;c)  ///
		ctitles("" ,N, All, Control, Treatment, P-value of diff.) varl ///
		basefont(fs10) titlfont(fs11 b) landscape ///
		note("P-values are reported from Wald tests on the equality of means of Treatment and Control for each variable." ///
		"Standard errors are clustered at the cluster level")

*Appendix Table: balance by treatment arms
	outreg, clear
	clear matrix
	
	*attrition by arms
	outreg, clear
	mean foranalysis_inv  if foranalysis_inv~=. & eligible==1, over(Treatment) vce(cluster bl_a05)
			matrix m=e(b)
	reg foranalysis_inv treat2-treat4 if eligible==1 , vce(cluster bl_a05)
		forvalues n=2/4{
			test treat`n'
			matrix p`n'=r(p)
		}
		test treat2=treat3
		matrix p5=r(p)
		test treat2=treat4
		matrix p6=r(p)
		test treat3=treat4
		matrix p7=r(p)
		
		matrix a=m,p2,p3,p4,p5,p6,p7
		matrix rownames a="Attrition rates" 
	
	*Balance
	foreach var in $descript {
		
		mean `var'  if `var'~=. & foranalysis==1, over(Treatment) vce(cluster bl_a05)
			matrix m`var'=e(b)
		reg `var' treat2-treat4 if foranalysis==1 , vce(cluster bl_a05)
		forvalues n=2/4{
			test treat`n'
			matrix p`n'`var'=r(p)
		}
		test treat2=treat3
		matrix p5`var'=r(p)
		test treat2=treat4
		matrix p6`var'=r(p)
		test treat3=treat4
		matrix p7`var'=r(p)
		
		matrix z`var'= m`var',p2`var', p3`var', p4`var', p5`var', p6`var', p7`var'
		matrix rownames z`var'=`var'
		}
	matrix  balance=a\zbl_head \zcolomb\ zbl_b04 \zbl_edu_sec \zbl_married \ ///
		zbl_indig\ zbl_black \zbl_dempl \ zownhouse \  ///
		zbl_partn_sedu\ zbl_partn_age \zbl_partn_dempl \zbl_partn_hrworked\  ///
		zbl_nchildren0t5 \zbl_nchildren6t14 \ zbl_totcons_pc\  znorooms \  ///
		zbl_lphysex \zbl_control \zbl_emotional \zbl_physical 
	
	*regressions of all variables on treatment
	forvalues n=2/4{
	regr treat`n' $descript if foranalysis==1, vce(clu bl_a05)
		testparm $descript
		matrix pa`n'=r(p)
		}

	matrix m=.,.,.,.,pa2,pa3,pa4,.,.,.
	matrix rownames m="P-value from joint F-test" 
	matrix M=balance\m

	frmttable using "$TABLES\Analysis", addtable statmat(M) sdec(2, 2, 2, 2 ,2)  ///
		title(Appendix Table: Baseline means by intervention arm) varl  coljust(l;c)  ///
		ctitles("" ,Means, "", "","" ,"P-value of diff.",\ "","Control", Food, Cash, Voucher, ///
		"Food -Control", "Cash -Control", "Voucher -Control" "Food -Cash","Food -Voucher","Cash -Voucher") ///
		basefont(fs9) titlfont(fs10 b) colwidth(42 5 8 8 8 8 8 8 8 8 8 8) mult(1,2,4;1,6,6) ///
		note("P-values are reported from Wald tests on the equality of means of control and each treatment for each variable." ///
		"Standard errors are clustered at the cluster level") pretext("\page")


*Appendix table on attrition analysis on control var
	outreg, clear
	foreach var in $descript {
		
		mean `var'  if p_treat==0 & eligible==1, over(foranalysis) vce(cluster bl_a05)
			matrix m1`var'=e(b)
		test[`var']0=[`var']1
			matrix p1`var'=r(p)
		
		mean `var'  if p_treat==1 & eligible==1, over(foranalysis) vce(cluster bl_a05)
			matrix m2`var'=e(b)
		test[`var']0=[`var']1
			matrix p2`var'=r(p)
		
		estpost ttest `var' if foranalysis==0 & eligible==1, by(p_treat)
			matrix d`var'=e(b)
		mean `var' if foranalysis==0 & eligible==1, over(p_treat) vce(cluster bl_a05)
		test[`var']control=[`var']treated
			matrix p3`var'=r(p)
		matrix m`var'=m1`var',  p1`var', m2`var', p2`var',d`var',p3`var'
		matrix rownames m`var'=`var'
		}
		
	matrix  balance=mbl_head \mcolomb\ mbl_b04 \mbl_edu_sec \mbl_married \ ///
		mbl_indig\ mbl_black \mbl_dempl \ mownhouse \  ///
		mbl_partn_sedu\ mbl_partn_age \mbl_partn_dempl \mbl_partn_hrworked\  ///
		mbl_nchildren0t5 \mbl_nchildren6t14 \ mbl_totcons_pc\ mnorooms \ ///
		mbl_lphysex \mbl_control \mbl_emotional \mbl_physical 

	frmttable using "$TABLES\Analysis", addtable statmat(balance) sdec(2)  ///
		title(Appendix Table: Attrition analysis by baseline characteristics)   coljust(l;c)  ///
		ctitles("", Control,"","", Treatment, "","", Difference,""\"" ,Attrited, "In study", P-value, ///
		Attrited, "In study", P-value, "Col(1)-Col(4)", "P-value"\"",(1),(2),(3),(4),(5),(6),(7),(8)) ///
		basefont(fs9) titlfont(fs10 b) varl mult(1,2,3;1,5,3;1,8,2) colwidth(30 9 9 9 9 9 9 9 9) ///
		note("P-values are reported from Wald tests on the equality of means of Treatment and Control for each variable." ///
		"Standard errors are clustered at the cluster level") pretext("\page")


***autocorrelations
pwcorr bl_emotional bl_control bl_physical el_emotional el_control el_physical


************************* 3. Regressions for Tables in Main text *************************************
/*sample for analysis: Females who responded to DV who are <70yrs*/

drop if foranalysis==0

global controls bl_head colomb bl_married bl_indig bl_black bl_b04 bl_edu_sec bl_dempl ownhouse ///
	bl_partn_sedu bl_partn_age  bl_nchildren0t5 bl_nchildren6t14 wealth2-wealth4 bl_a02

*Table 2:regression on pooled treatment
	outreg, clear
		local lab: var label el_control
		mean el_control if el_control~=. & p_treat==0 , cl(bl_a05)
		outreg, merge  bdec(2) se nostars  rtitle(`lab') noautosumm stats(b)
		
		probit el_control p_treat, cl(bl_a05)
		margin,dydx(*)
		outreg, merge  bdec(2) se starlevels(10 5 1) mar keep(p_treat) noautosumm rtitle(`lab')
			
		probit el_control p_treat bl_control bl_a02 , cl(bl_a05) 
		margin,dydx(*)
		outreg, merge  bdec(2) se starlevels(10 5 1) mar keep(p_treat) noautosumm rtitle(`lab')
			
		xi: probit el_control p_treat bl_control $controls, cl(bl_a05) 
		margin,dydx(*)
		outreg, merge  bdec(2) se starlevels(10 5 1) mar keep(p_treat) noautosumm rtitle(`lab')

		foreach var in emotional physical{
			local lab: var label el_`var'
	
			mean el_`var' if el_`var'~=. & p_treat==0, cl(bl_a05)
			outreg, clear(table`var')
			outreg, store(table`var') bdec(2) se nostars noautosumm stats(b) rtitle(`lab')
			
			probit el_`var' p_treat  , cl(bl_a05)
			margin,dydx(*)
			outreg, merge(table`var') bdec(2) se starlevels(10 5 1) mar keep(p_treat)  noautosumm  rtitle(`lab')
			
			probit el_`var' p_treat bl_`var' bl_a02 , cl(bl_a05)
			margin,dydx(*)
			outreg, merge(table`var') bdec(2) se starlevels(10 5 1) mar keep(p_treat)  noautosumm  rtitle(`lab')
			
			xi: probit el_`var' p_treat bl_`var' $controls, cl(bl_a05) 
			margin,dydx(*)
			outreg, merge(table`var') bdec(2) se starlevels(10 5 1) mar keep(p_treat)  noautosumm  rtitle(`lab')
			
			outreg, replay append(table`var')
		}
		outreg using "$TABLES\Analysis", replay addtable bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
			title("Table 2: Impact of pooled treatment on IPV measures") colwidth(35 9 9 9 9 ) ///
			basefont(fs10) titlfont(fs11 b) hlines(1{0};1{0};{0}1;1{0}1) hlstyle(s;d;s;s) mar  ///
			note("Standard errors in parenthesis clustered at the cluster level.  * p<0.1 ** p<0.05; *** p<0.01") ///
			ctitle("", Endline Control Mean, No controls, Basic controls,  Extended controls)  pretext("\page")  

	
*Table 3 : Regression on individual outcomes
		*creating no variation baseline var which will drop out to run code
		forvalues n=24/28{
			g bl_t`n'b=1 
			}
		
		outreg, clear
		local lab: var label el_t10b
		mean el_t10b if el_t10b~=. & p_treat==0 , cl(bl_a05)
		outreg, merge  bdec(2) se nostars  rtitle(`lab') noautosumm stats(b)
		
		probit el_t10b p_treat, cl(bl_a05)
		margin,dydx(*)
		outreg, merge  bdec(2) se starlevels(10 5 1) mar keep(p_treat) noautosumm rtitle(`lab')
			
		probit el_t10b p_treat bl_t10b bl_a02 , cl(bl_a05) 
		margin,dydx(*)
		outreg, merge  bdec(2) se starlevels(10 5 1) mar keep(p_treat) noautosumm rtitle(`lab')
			
		xi: probit el_t10b p_treat bl_t10b $controls, cl(bl_a05) asis
		margin,dydx(*)
		outreg, merge  bdec(2) se starlevels(10 5 1) mar keep(p_treat) noautosumm rtitle(`lab')

		foreach var in t11b t25b t26b t12b t13b t14b t24b t27b t28b t15b t16b t17b t18b t19b t20b t21b t22b t23b{
			local lab: var label el_`var'
	
			mean el_`var' if el_`var'~=. & p_treat==0, cl(bl_a05)
			outreg, clear(table`var')
			outreg, store(table`var') bdec(2) se nostars noautosumm stats(b) rtitle(`lab')
			
			probit el_`var' p_treat  , cl(bl_a05)
			margin,dydx(*)
			outreg, merge(table`var') bdec(2) se starlevels(10 5 1) mar keep(p_treat)  noautosumm  rtitle(`lab')
			
			probit el_`var' p_treat bl_`var' bl_a02 , cl(bl_a05)
			margin,dydx(*)
			outreg, merge(table`var') bdec(2) se starlevels(10 5 1) mar keep(p_treat)  noautosumm  rtitle(`lab')
			
			xi: probit el_`var' p_treat bl_`var' $controls, cl(bl_a05) asis
			margin,dydx(*)
			outreg, merge(table`var') bdec(2) se starlevels(10 5 1) mar keep(p_treat)  noautosumm  rtitle(`lab')
			
			outreg, replay append(table`var')
		}
		outreg using "$TABLES\Analysis", replay addtable bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
			title("Table 3: Impact of pooled treatment on individual IPV indicators") colwidth(45 9 9 9 9 ) ///
			basefont(fs10) titlfont(fs11 b) hlines(1{0};1{0};{0}1;1{0}1) hlstyle(s;d;s;s) mar  ///
			note("Standard errors in parenthesis clustered at the cluster level.  * p<0.1 ** p<0.05; *** p<0.01") ///
			ctitle("", Endline Control Mean, No controls, Basic controls,  Extended controls)  pretext("\page")  

*Table 4: regression by treatment with covariates
	outreg, clear
	foreach var in control emotional physical{
		
		xi: probit el_`var' treat2-treat4  , cl(bl_a05)
			margin, dydx(*) post
			test treat2=treat4
				local p1 : display %4.2f r(p)
			test treat3=treat4
				local p2 : display %4.2f r(p)
			test treat2=treat3
				local p3 : display %4.2f r(p)
			outreg, merge keep(treat2-treat4) varlabels  bdec(2) se starlevels(10 5 1)  ///
				addrows("P-value: Food=Voucher", "`p1'" \"P-value: Cash=Voucher",  ///
				"`p2'" \ "P-value: Food=Cash",  "`p3'" )
		
		xi: probit el_`var' treat2-treat4 bl_`var' bl_a02, cl(bl_a05)
			margin, dydx(*) post
			test treat2=treat4
				local p1 : display %4.2f r(p)
			test treat3=treat4
				local p2 : display %4.2f r(p)
			test treat2=treat3
				local p3 : display %4.2f r(p)
			outreg, merge keep(treat2-treat4) varlabels  bdec(2) se starlevels(10 5 1)  ///
				addrows("P-value: Food=Voucher", "`p1'" \"P-value: Cash=Voucher",  ///
				"`p2'" \ "P-value: Food=Cash",  "`p3'" )
		
		xi: probit el_`var' treat2-treat4 $controls bl_`var' , cl(bl_a05)
			margin, dydx(*) post
			test treat2=treat4
				local p1 : display %4.2f r(p)
			test treat3=treat4
				local p2 : display %4.2f r(p)
			test treat2=treat3
				local p3 : display %4.2f r(p)
			outreg, merge keep(treat2-treat4) varlabels  bdec(2) se starlevels(10 5 1)  ///
				addrows("P-value: Food=Voucher", "`p1'" \"P-value: Cash=Voucher",  ///
				"`p2'" \ "P-value: Food=Cash",  "`p3'") 
	}
	outreg using "$TABLES\Analysis", replay addtable bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
		title("Table 4: Impact of treatment modalities on IPV measures") ///
		basefont(fs10) titlfont(fs11 b) hlines(1{0};1{0};0;{0}1) hlstyle(s;d;;s)  ///
		note("Standard errors in parenthesis clustered at the cluster level.  * p<0.1 ** p<0.05; *** p<0.01.") /// 
		colwidth(25 9 9 9 9 9 9 9 9 9) ctitle("", Controlling,"","", Emotional,"","", Physical or Sexual,"",""\ ///
		"", No controls, Basic controls, Extended controls,No controls, Basic controls, Extended controls, ///
		No controls, Basic controls, Extended controls) mult(1,2,3;1,5,3;1,8,3) pretext("\page")


*Table 5: nonfood expenditures:  adult cloths, child cloths

	*regressions
	outreg, clear
	foreach n in adultc 14{
		
		sum el_dnfcons_pc_`n' if p_treat==0 
		local MF : display %4.2f r(mean)
		xi: probit el_dnfcons_pc_`n' p_treat $controls bl_dnfcons_pc_`n' , cl(bl_a05)
		margin, dydx(*) 
		outreg, merge varlabels  bdec(2) se starlevels(10 5 1) keep(p_treat)  mar   /// 
		addrows("Mean of control group at endline",`MF'\"Basic controls","X"\"Extended controls", "X")
		
		*tobits	
		foreach var in  lognfcons_pc_`n' nfshare_pc_`n' share_pc_`n'{
		
		sum el_`var' if p_treat==0 
		local MF : display %4.2f r(mean)
		xi: tobit el_`var' p_treat $controls bl_`var' , cl(bl_a05) ll
		outreg, merge varlabels  bdec(2) se starlevels(10 5 1) keep(p_treat)   /// 
		addrows("Mean of control group at endline",`MF'\"Basic controls","X"\"Extended controls", "X")
	}
	}
	outreg using "$TABLES\Analysis", replay addtable bdec(2) se starlevels(10 5 1) coljust(l;c) hlstyle(s;d;;s) ///
		title("Table 5: Impact of pooled treatment on clothing expenditures: ``n''") colwidth(50 8 8 8 8 8 8 8 8 8) ///
		basefont(fs10) titlfont(fs11 b) hlines(1{0};1{0};0;{0}1) pretext("\page") ///
		note("Standard errors in parenthesis clustered at the cluster level.  * p<0.1 ** p<0.05; *** p<0.01") ///
		ctitle("","Adult clothes and shoes","","","", "Child clothes and shoes", ///
		"","","" \ "", "=1 if purchased","Log expenditures", "Expenditure shares over non-food", "Expenditure shares over total" ///
		"=1 if purchased","Log expenditures", "Expenditure shares over non-food", "Expenditure shares over total") ///
		multic(1,2,4;1,6,4)
	
*Table 6 Employment table
	*female labor
	outreg, clear
	foreach var in  d01 d02 d03 d04 dempl d10 {
		*probit
		sum el_`var' if p_treat==0 
		local MF : display %4.2f r(mean)
		xi: probit el_`var' p_treat bl_`var'  $controls , cl(bl_a05) asis
		margin, dydx(*) 
		outreg, merge varlabels bdec(2) se starlevels(10 5 1) mar  ///
		keep(p_treat) addrows("Mean of control group at endline",`MF'\"Basic controls","X"\"Extended controls", "X")
	
	}
		*reg
		sum el_domlaborhr if p_treat==0 
		local MF : display %4.2f r(mean)
		xi: reg el_domlaborhr p_treat bl_domlaborhr  $controls , cl(bl_a05)
		outreg, merge varlabels bdec(2) se starlevels(10 5 1)   ///
		keep(p_treat) addrows("Mean of control group at endline",`MF'\"Basic controls","X"\"Extended controls", "X")
		
	outreg using "$TABLES\Analysis", replay addtable bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
		title("Table 6: Impact of pooled treatment on female employment") colwidth(25 9 9 9 9 9 9 9 9 9) ///
		basefont(fs10) titlfont(fs11 b) hlines(1{0};1{0};0;{0}1) mar hlstyle(s;d;;s) ///
		note("Standard errors in parenthesis clustered at the cluster level.  * p<0.1 ** p<0.05; *** p<0.01") ///
		pretext("\page") landscape 
	
	*partner labor
	outreg, clear
	foreach var in partn_empl1 partn_empl2 partn_empl3 partn_empl4 partn_dempl  {
		*probit
		sum el_`var' if p_treat==0 
		local MF : display %4.2f r(mean)
		xi: probit el_`var' p_treat bl_`var'  $controls , cl(bl_a05) asis
		margin, dydx(*) 
		outreg, merge varlabels bdec(2) se starlevels(10 5 1) mar  ///
		keep(p_treat) addrows("Mean of control group at endline",`MF'\"Basic controls","X"\"Extended controls", "X")
	
	}
		*reg
		sum el_partn_hrworked if p_treat==0 
		local MF : display %4.2f r(mean)
		xi: reg el_partn_hrworked p_treat bl_partn_hrworked  $controls , cl(bl_a05) 
		outreg, merge varlabels bdec(2) se starlevels(10 5 1)   ///
		keep(p_treat) addrows("Mean of control group at endline",`MF'\"Basic controls","X"\"Extended controls", "X")
		*probit
		sum el_partn_domlabor  if p_treat==0 
		local MF : display %4.2f r(mean)
		xi: probit el_partn_domlabor  p_treat bl_partn_domlabor  $controls , cl(bl_a05)
		margin, dydx(*) 
		outreg, merge varlabels bdec(2) se starlevels(10 5 1) mar  ///
		keep(p_treat) addrows("Mean of control group at endline",`MF'\"Basic controls","X"\"Extended controls", "X")
		
	outreg using "$TABLES\Analysis", replay addtable bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
		title("Table 6: Impact of pooled treatment on partner's employment") colwidth(25 9 9 9 9 9 9 9 9 9) ///
		basefont(fs10) titlfont(fs11 b) hlines(1{0};1{0};0;{0}1) mar hlstyle(s;d;;s) ///
		note("Standard errors in parenthesis clustered at the cluster level.  * p<0.1 ** p<0.05; *** p<0.01") ///
		pretext("\page") landscape 

********************************   4. Graphs   ********************************
	
	*engel curves
	twoway (lpoly bl_share_pc_adultc bl_logtotcons_pc) ///
		(lpoly bl_share_pc_14 bl_logtotcons_pc, lpattern(shortdash) lwidth(thick) ), ///
		ylabel(0(.02).1) xtitle(Ln value of total consumption (pc)) ytitle(Share of consumption on clothes) ///
		title("Engel Curve, baseline")subtit("Value of total consumption") ///
		legend(lab(1 "Adult") lab(2 "Child") ) 
	graph export "$GRAPHS\ENGEL CURVE nonfood share baseline.png", replace
	png2rtf using "$GRAPHS\Engle_curves_lpoly.doc", graph($GRAPHS\ENGEL CURVE nonfood share baseline.png) replace

	twoway (lpoly bl_nfshare_pc_adultc bl_lognfcons_pc) ///
		(lpoly bl_nfshare_pc_14 bl_lognfcons_pc, lpattern(shortdash) lwidth(thick) ), ///
		ylabel(0(.05).25) xtitle(Ln value of non food consumption (pc)) ytitle(Share of consumption on clothes) ///
		title("Engel Curve, baseline") subtit("Value of non-food consumption") ///
		legend(lab(1 "Adult")  lab(2 "Child") ) 
	graph export "$GRAPHS\ENGEL CURVE total share baseline.png", replace
	png2rtf using "$GRAPHS\Engle_curves_lpoly.doc", graph($GRAPHS\ENGEL CURVE total share baseline.png) append
	


*****************	5. Online Appendix tables	***********************************

****robust to linear probability models
	*simple regression on pooled
	outreg, clear
	foreach var in control emotional physical{
		
		xi:reg el_`var' p_treat , cl(bl_a05)
		sum el_`var' if p_treat==0 
		local MF : display %4.2f r(mean)
		outreg, merge varlabels bdec(2) se starlevels(10 5 1)  ///
		keep(p_treat) addrows("Mean of control group at endline",`MF')
		
		xi:reg el_`var' p_treat bl_`var' bl_a02 , cl(bl_a05)
		sum el_`var' if p_treat==0 
		local MF : display %4.2f r(mean)
		outreg, merge varlabels bdec(2) se starlevels(10 5 1)  ///
		keep(p_treat) addrows("Mean of control group at endline",`MF'\"Basic controls","X")
		
		xi: reg el_`var' p_treat bl_`var'  $controls , cl(bl_a05)
		sum el_`var' if p_treat==0 
		local MF : display %4.2f r(mean)
		outreg, merge varlabels bdec(2) se starlevels(10 5 1)   ///
		keep(p_treat) addrows("Mean of control group at endline",`MF'\"Basic controls","X"\"Extended controls", "X")
	}
	outreg using "$TABLES\Analysis", replay addtable bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
		title("Online appendix Table: Impact of pooled treatment on IPV measures, linear probability models") colwidth(25 9 9 9 9 9 9 9 9 9) ///
		basefont(fs10) titlfont(fs11 b) hlines(1{0};1{0};0;{0}1) mar hlstyle(s;d;;s) ///
		note("Standard errors in parenthesis clustered at the cluster level.  * p<0.1 ** p<0.05; *** p<0.01") ///
		ctitle("", Controlling,"","", Emotional,"","", Physical or Sexual,"","") ///
		mult(1,2,3;1,5,3;1,8,3) pretext("\page") landscape 

	*regression by treatment arm
	outreg, clear
	foreach var in control emotional physical{
		
		xi: reg el_`var' treat2-treat4  , cl(bl_a05)
			test treat2=treat4
				local p1 : display %4.2f r(p)
			test treat3=treat4
				local p2 : display %4.2f r(p)
			test treat2=treat3
				local p3 : display %4.2f r(p)
			outreg, merge keep(treat2-treat4) varlabels  bdec(2) se starlevels(10 5 1)  ///
				addrows("P-value: Food=Voucher", "`p1'" \"P-value: Cash=Voucher",  ///
				"`p2'" \ "P-value: Food=Cash",  "`p3'" )
		
		xi: reg el_`var' treat2-treat4 bl_`var' bl_a02, cl(bl_a05)
			test treat2=treat4
				local p1 : display %4.2f r(p)
			test treat3=treat4
				local p2 : display %4.2f r(p)
			test treat2=treat3
				local p3 : display %4.2f r(p)
			outreg, merge keep(treat2-treat4) varlabels  bdec(2) se starlevels(10 5 1)  ///
				addrows("P-value: Food=Voucher", "`p1'" \"P-value: Cash=Voucher",  ///
				"`p2'" \ "P-value: Food=Cash",  "`p3'" \"Basic controls","X")
		
		xi: reg el_`var' treat2-treat4 $controls bl_`var' , cl(bl_a05)
			test treat2=treat4
				local p1 : display %4.2f r(p)
			test treat3=treat4
				local p2 : display %4.2f r(p)
			test treat2=treat3
				local p3 : display %4.2f r(p)
			outreg, merge keep(treat2-treat4) varlabels  bdec(2) se starlevels(10 5 1)  ///
				addrows("P-value: Food=Voucher", "`p1'" \"P-value: Cash=Voucher",  ///
				"`p2'" \ "P-value: Food=Cash",  "`p3'"\"Basic controls","X" ///
				\"Extended controls", "X") 
	}
	outreg using "$TABLES\Analysis", replay addtable bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
		title("Online appendix Table: Impact of treatment modalities on IPV measures,linear probability models") ///
		basefont(fs10) titlfont(fs11 b) hlines(1{0};1{0};0;{0}1) hlstyle(s;d;;s)  ///
		note("Standard errors in parenthesis clustered at the cluster level.  * p<0.1 ** p<0.05; *** p<0.01.") /// 
		colwidth(25 9 9 9 9 9 9 9 9 9) ctitle("", Controlling,"","", Emotional,"","", Physical or Sexual,"","") ///
		mult(1,2,3;1,5,3;1,8,3) pretext("\page")


** Lee bounds,calculating upper and lower bound by running regressions on trimmed means **
	*pooled treatment
	outreg, clear
	foreach var in control emotional physical {
			sum  el_`var' if p_treat==0 
			local M : display %4.2f r(mean)
		xi: probit el_`var' p_treat bl_`var' $controls   , cl(bl_a05)
			margin,dydx(*)
			xi:outreg, merge varlabels bdec(2) se starlevels(10 5 1) mar keep(p_treat) ///
			summstat(N \r2_p) summtitle("N"\"Pseudo R2") addrows("Mean of control group at endline", "`M'") 
		
			sum  el_`var' if p_treat==0 &  utrim_el_`var'~=1 
			local M : display %4.2f r(mean)
		xi: probit el_`var' p_treat bl_`var' $controls  if utrim_el_`var'~=1, cl(bl_a05)
			margin,dydx(*)
			xi:outreg, merge varlabels bdec(2) se starlevels(10 5 1) mar  keep(p_treat) ///
			summstat(N \r2_p) summtitle("N"\"Pseudo R2") addrows("Mean of control group at endline", "`M'") 
			
			sum  el_`var' if p_treat==0 & ltrim_el_`var'~=1 
			local M : display %4.2f r(mean)
		xi: probit el_`var' p_treat bl_`var' $controls   if ltrim_el_`var'~=1, cl(bl_a05)
			margin,dydx(*)
			xi:outreg, merge varlabels bdec(2) se starlevels(10 5 1) mar  keep(p_treat) ///
			summstat(N \r2_p) summtitle("N"\"Pseudo R2") addrows("Mean of control group at endline", "`M'") 
		}
		
	outreg using "$TABLES\Analysis", replay addtable bdec(2) se starlevels(10 5 1) hlstyle(s;d;;s) ///
		title("Online appendix Table: Lee bounds") basefont(fs10 roman) titlfont(fs11 roman b)   ///
		coljust(l;c) colwidth(24 9 9 9 9 9 9 9 9 9 ) landscape pretext("\page") hlines(1{0};1{0};0;{0}1) ///
		note("Standard errors in parenthesis clustered at the cluster level.  * p<0.1 ** p<0.05; *** p<0.01." ///
		"All estimations control for baseline outcome variable and province.") ///
		ctitle("", "Controlling","","","Emotional","","","Physical or sexual","",""\ ///
		"",Beta, Upper, Lower , Beta, Upper, Lower ,Beta, Upper, Lower) ///
		 multicol(1,2,3; 1,5,3;1,8,3) 

	*by treatment arms
	outreg, clear
	foreach var in control emotional physical {
		xi: probit el_`var' treat2-treat4 bl_`var' $controls  , cl(bl_a05)
			margin,dydx(*) post
			test treat2=treat4
			local p1 : display %4.2f r(p)
			test treat3=treat4
			local p2 : display %4.2f r(p)
			test treat2=treat3
			local p3 : display %4.2f r(p)
			xi:outreg, merge varlabels bdec(2) se blankrows keep(treat2-treat4) starlevels(10 5 1) ///
			addrows("P-value: Food=Voucher", "`p1'" \"P-value: Cash=Voucher", "`p2'"\"P-value: Food=Cash", "`p3'" )  
		
		xi: probit el_`var' treat2-treat4 bl_`var' $controls  if utrim_el_`var'_1~=1 & utrim_el_`var'_2~=1 ///
			& utrim_el_`var'_3~=1, cl(bl_a05)
			margin,dydx(*) post
			test treat2=treat4
			local p1 : display %4.2f r(p)
			test treat3=treat4
			local p2 : display %4.2f r(p)
			test treat2=treat3
			local p3 : display %4.2f r(p)
			xi:outreg, merge varlabels bdec(2) se blankrows keep(treat2-treat4) starlevels(10 5 1) ///
			addrows("P-value: Food=Voucher", "`p1'" \"P-value: Cash=Voucher", "`p2'"\"P-value: Food=Cash", "`p3'" )  
		
			
		xi: probit el_`var' treat2-treat4 bl_`var' $controls if ltrim_el_`var'_1~=1 & ltrim_el_`var'_2~=1 ///
			& ltrim_el_`var'_3~=1, cl(bl_a05)
			margin,dydx(*) post
			test treat2=treat4
			local p1 : display %4.2f r(p)
			test treat3=treat4
			local p2 : display %4.2f r(p)
			test treat2=treat3
			local p3 : display %4.2f r(p)
			xi:outreg, merge varlabels bdec(2) se blankrows keep(treat2-treat4) starlevels(10 5 1) ///
			addrows("P-value: Food=Voucher", "`p1'" \"P-value: Cash=Voucher", "`p2'"\"P-value: Food=Cash", "`p3'" )  
		}
		
	outreg using "$TABLES\Analysis", replay addtable bdec(2) se starlevels(10 5 1) hlstyle(s;d;;s) ///
		title("Online appendix Table: Lee bounds") basefont(fs10 roman) titlfont(fs11 roman b)   ///
		coljust(l;c) colwidth(24 9 9 9 9 9 9 9 9 9 ) landscape pretext("\page") hlines(1{0};1{0};0;1{0}1) ///
		note("Standard errors in parenthesis clustered at the cluster level.  * p<0.1 ** p<0.05; *** p<0.01." ///
		"All estimations control for baseline outcome variable and province.") ///
		ctitle("", "Controlling","","","Emotional","","","Physical or sexual","",""\ ///
		"",Beta, Upper, Lower , Beta, Upper, Lower ,Beta, Upper, Lower) ///
		 multicol(1,2,3; 1,5,3;1,8,3) 




