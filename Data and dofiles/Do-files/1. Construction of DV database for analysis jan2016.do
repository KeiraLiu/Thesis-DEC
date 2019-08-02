/******************************************************************************************************************
*** WFP PROJECT: Ecuador       								 													***
*** 																											***

*** This do-file was created to construct dataset for IPV analysis. 											***
*** It uses de-identified raw data from baseline and follow-up, combines section T (IPV module) with
*** individual data for women responding to the IPV section, and creates control variables.
***																												***
*** BY Melissa Hidrobo         		 									 										***
*** Creating database for DV analysis that is de-identified for AEJ												***
*** 																											***
*** 																											***		
******************************************************************************************************************/

clear all
set mem 100m
set more off
tempfile el_temp
tempfile bl_temp
				
global BHHOLD   "D:\Melissa Hidrobo\WFP\Ecuador\Paper 2- DV\Quant analysis\Drafts\AEJ submission\Data and dofiles\Data\Baseline"
global FHHOLD   "D:\Melissa Hidrobo\WFP\Ecuador\Paper 2- DV\Quant analysis\Drafts\AEJ submission\Data and dofiles\Data\Follow-up"
global OTHER	"D:\Melissa Hidrobo\WFP\Ecuador\Paper 2- DV\Quant analysis\Drafts\AEJ submission\Data and dofiles\Data\Other"

***************************1. Follow-up data ************************************

**1.1. creating dataset at individual IPV respondent level 
use "$FHHOLD\UPDATED2_secc_a_t05.dta"

	*merging with individual level variables of section b and d
	rename idsecc_t id1a
	sort a01 id1a
	merge 1:1 a01 id1a using "$FHHOLD\UPDATED2_secc_b_d.dta"

	drop if _merge==2 
	list a01 if _merge==1 & t0==1
	list a01 b1f1 b04  if b1f1==3 & _merge==3  & t0~=. 
	rename b9f1 b09f1
	rename b8f1 b08f1
	rename t0 tnohaymujer
	rename id1a idsecc_t

	drop _merge

	*recoding/renaming IPV variables
	foreach var in t10 t24 t25 t26 t27 t28 {
		rename `var'a `var'
		}
	foreach var of varlist t10-t28b t19-t18b{
		recode `var' 2=0
		}
		
	*saving
	sort a01
	save `el_temp', replace


**1.2 follow-up husband variables. Husband is either household head or spouse
	use "$FHHOLD\UPDATED2_secc_b_d.dta", clear
	keep  a01 id1a  b1f1 b02 b03 b04 b09 b9f1 d*
	
	foreach var in b1f1 b02 b03 b04 b09 b9f1 d* {
		rename `var' `var'_1
	}
	
	*relationship with head, sex and ethnicity come from baseline
	sort a01 id1a
	merge 1:1 a01 id1a using "$BHHOLD\UPDATED_secc_b_d.dta"
	drop if id1a==0
	tab _merge	
			
	gen hedu=b09_1 if b03_1==1 & b02_1==1
	replace hedu=b09_1 if b03==1 & b02==1 & hedu==.
	bysort a01: egen mhead_edu=max(hedu)
	label var mhead_edu "Male head's edu level"

	gen sedu=b09_1 if b03_1==2 & b02_1==1
	replace sedu=b09_1 if b03==2 & b02==1 & sedu==.
	bysort a01: egen mspouse_edu=max(sedu)
	label var mspouse_edu "Male spouse's edu level"
	drop hedu sedu

	gen hedu=b9f1 if b03_1==1 & b02_1==1
	replace hedu=b9f1 if b03==1 & b02==1 & hedu==.
	bysort a01: egen mhead_edyrs=max(hedu)
	label var mhead_edyrs "Male head's years of edu"
	
	gen sedu=b9f1 if b03_1==2 & b02_1==1
	replace sedu=b9f1 if b03==2 & b02==1 & sedu==.
	bysort a01: egen mspouse_edyrs=max(sedu)
	label var mspouse_edyrs "Male spouse's years of edu"

	gen hage=b04_1 if b03_1==1 & b02_1==1
	replace hage=b04_1 if b03==1 & b02==1 & hage==.
	bysort a01: egen mhead_age=max(hage)
	label var mhead_age "Male head's age"
	
	gen sage=b04_1 if b03_1==2 & b02_1==1
	replace sage=b04_1 if b03==2 & b02==1 & sage==.
	bysort a01: egen mspouse_age=max(sage)
	label var mspouse_age "Male spouse's age"

	forvalues n=1/4 {
		gen hjobd`n'=d0`n'_1 if 		b03_1==1 & b02_1==1
		replace hjobd`n'=d0`n'_1  if    b03==1   & b02==1 & hjobd`n'==.
		bysort a01: egen mhead_empl`n'=max(hjobd`n')
		
		gen sjobd`n'=d0`n'_1 if			b03_1==2 & b02_1==1
		replace sjobd`n'=d0`n'_1  if 	b03==2   & b02==1 & sjobd`n'==.
		bysort a01: egen mspouse_empl`n'=max(sjobd`n')
}
	label var mhead_empl1 "Male head worked in agriculture on family land"
	label var mspouse_empl1 "Male spouse worked in agriculture on family land"
	label var mhead_empl2 "Male head worked in agriculture, salaried"
	label var mspouse_empl2 "Male spouse worked in agriculture, salaried"
	label var mhead_empl3 "Male head worked in non-agriculture, salaried labor"
	label var mspouse_empl3 "Male spouse worked in non-agriculture, salaried labor"
	label var mhead_empl4 "Male head worked in independent, non-agr labor"
	label var mspouse_empl4 "Male spouse worked in indepdent, non-agr labor"
	
	replace d05_1=5 if d05_1==. & d01_1==2 & d02_1==2 & d03_1==2 & d04_1==2
	label define job 1 "Agricultura en tierra dispone de este h" ///
				2 " Trabajo agrícola con sueldo o salario" ///
				3 "Trabajo no agrícola, con sueldo o salario" ///
				4 "Trabajo por cuenta propia, no agrícola" ///
				5 "Not employed"
	label value d05_1 job

	gen hjob=d05_1 if 	   b03_1==1 & b02_1==1
	replace hjob=d05_1  if b03==1   & b02==1 & hjob==.
	bysort a01: egen mhead_empl=max(hjob)
	label var mhead_empl "Male head's employment"
	label value mhead_empl job
	
	gen sjob=d05_1 if 	   b03_1==2 & b02_1==1
	replace sjob=d05_1  if b03==2   & b02==1 & sjob==.
	bysort a01: egen mspouse_empl=max(sjob)
	label var mspouse_empl "Male spouse's employment"
	label value mspouse_empl job

	gen hhrworked=d06_1 if 		b03_1==1 & b02_1==1
	replace hhrworked=d06_1  if b03==1   & b02==1 & hhrworked==.
	bysort a01: egen mhead_hrworked=max(hhrworked)
	label var mhead_hrworked "Male head, hours worked"

	gen shrworked=d06_1 if 		b03_1==2 & b02_1==1
	replace shrworked=d06_1  if b03==2   & b02==1 & shrworked==.
	bysort a01: egen mspouse_hrworked=max(shrworked)
	label var mspouse_hrworked "Male spouse, hours worked"

	gen hjob1=d08_1 if 		b03_1==1 & b02_1==1
	replace hjob1=d08_1  if b03==1   & b02==1 & hjob1==.
	bysort a01: egen mhead_empls=max(hjob1)
	label var mhead_empls "Male head's monthly salary - primary employment"
	
	gen sjob1=d08_1 if		b03_1==2 & b02_1==1
	replace sjob1=d08_1  if b03==2   & b02==1 & sjob1==.
	bysort a01: egen mspouse_empls=max(sjob1)
	label var mspouse_empls "Male spouse's monthly salary - primary employment"

	gen hjob2=d09_1 if		b03_1==1 & b02_1==1
	replace hjob2=d09_1  if b03==1   & b02==1 & hjob2==.
	bysort a01: egen mhead_noempl=max(hjob2)
	label var mhead_noempl "Male head, why not employed"
	
	gen sjob2=d09_1 if 		b03_1==2 & b02_1==1
	replace sjob2=d09_1  if b03==2   & b02==1 & sjob2==.
	bysort a01: egen mspouse_noempl=max(sjob2)
	label var mspouse_noempl "Male spouse, why not employed"

	gen hdomlabor=d10_1 if 		b03_1==1 & b02_1==1
	replace hdomlabor=d10_1  if b03==1   & b02==1 & hdomlabor==.
	bysort a01: egen mhead_domlabor=max(hdomlabor)
	label var mhead_domlabor "Male head, domestic labor"

	gen sdomlabor=d10_1 if 		b03_1==2 & b02_1==1
	replace sdomlabor=d10_1  if b03==2   & b02==1 & sdomlabor==.
	bysort a01: egen mspouse_domlabor=max(sdomlabor)
	label var mspouse_domlabor "Male spouse, domestic labor"
	
	gen hdomlaborhr=d11_1 if 		b03_1==1 & b02_1==1
	replace hdomlaborhr=d11_1  if	b03==1   & b02==1 & hdomlaborhr==.
	bysort a01: egen mhead_domlaborhr=max(hdomlaborhr)
	label var mhead_domlaborhr "Male head, hours spent a day on domestic labor"

	gen sdomlaborhr=d11_1 if 		b03_1==2 & b02_1==1
	replace sdomlaborhr=d11_1  if 	b03==2   & b02==1 & sdomlaborhr==.
	bysort a01: egen mspouse_domlaborhr=max(sdomlaborhr)
	label var mspouse_domlaborhr "Male spouse, hours spent a day on domestic labor"

	egen tag=tag(a01)
	keep if tag==1
	keep a01 mhead* mspouse*
	order a01 
	merge m:1 a01 using `el_temp'
	drop _merge
	
	*organizing
	order a01  a* b* d* idsecc_t tnohaymujer  t*  

	*creating duplicate id variable
	g id=idsecc_t
	label var id "Duplicate id from section T"
	

**1.3 saving temp el dataset and preparing for baseline merge
	order a01 id a* b* d* 
	
	*renaming  to el for endline
	foreach var of varlist *{
		rename `var' el_`var'
		}

	rename el_a01 a01
	
	sort a01
	save `el_temp', replace
	
	
***************************2. Creating Baseline IPV data************************
******************************************************************************

**2.1. creating dataset at individual IPV respondent level 
	use "$BHHOLD\UPDATED_secc_a_e_t05.dta", clear
	rename id0m id1a
	
	*merging with individual level variables of section b and d
	merge 1:1 a01 id1a using  "$BHHOLD\UPDATED_secc_b_d.dta", keepus(b* d*)
	drop if id1a==0
	
	tab  b02 if  t0~=2  & _merge~=2
	list a01 b02 t0 if b02==1 & t0~=2 & _merge~=2

	drop if _merge==2
	drop _merge 

	*adding no employment option for d05
	replace d05=5 if d05==. & d01==2 & d02==2 & d03==2 & d04==2

	*recoding/renaming IPV variables
	rename t0 tnohaymujer
	rename t10a t10
	tabstat t10-t23b, s(min max)
	
	foreach var of varlist t10-t23b{
		recode `var' 2=0
		}
		
	order a01  a* b* d* id1a t*
	
	sort a01
	save `bl_temp', replace

**2.2 merging in baseline male head and male spouse variables and control variables
	use "$BHHOLD\UPDATED_secc_b_d.dta", clear

	*male edu and job 
		gen hedu=b09 if b03==1 & b02==1
		bysort a01: egen mhead_edu=max(hedu)
		label var mhead_edu "Male head's edu level"
		gen sedu=b09 if b03==2 & b02==1
		bysort a01: egen mspouse_edu=max(sedu)
		label var mspouse_edu "Male spouse's edu level"

		gen hage=b04 if b03==1 & b02==1
		bysort a01: egen mhead_age=max(hage)
		label var mhead_age "Male head's age"
		gen sage=b04 if b03==2 & b02==1
		bysort a01: egen mspouse_age=max(sage)
		label var mspouse_age "Male spouse's age"

		forvalues n=1/4 {
			gen hjobd`n'=d0`n' if 		b03==1 & b02==1
			bysort a01: egen mhead_empl`n'=max(hjobd`n')
			
			gen sjobd`n'=d0`n' if			b03==2 & b02==1
			bysort a01: egen mspouse_empl`n'=max(sjobd`n')
	}
		label var mhead_empl1 "Male head worked in agriculture on family land"
		label var mspouse_empl1 "Male spouse worked in agriculture on family land"
		label var mhead_empl2 "Male head worked in agriculture, salaried"
		label var mspouse_empl2 "Male spouse worked in agriculture, salaried"
		label var mhead_empl3 "Male head worked in non-agriculture, salaried labor"
		label var mspouse_empl3 "Male spouse worked in non-agriculture, salaried labor"
		label var mhead_empl4 "Male head worked in independent, non-agr labor"
		label var mspouse_empl4 "Male spouse worked in indepdent, non-agr labor"
		
		
		replace d05=5 if d05==. & d01==2 & d02==2 & d03==2 & d04==2
		label define job 1 "Agricultura en tierra dispone de este h" ///
						2 " Trabajo agrícola con sueldo o salario" ///
						3 "Trabajo no agrícola, con sueldo o salario" ///
						4 "Trabajo por cuenta propia, no agrícola" ///
						5 "Not employed"
		label value d05 job

		gen hjob=d05 if b03==1 & b02==1
		bysort a01: egen mhead_empl=max(hjob)
		label var mhead_empl "Male head's employment"
		label value mhead_empl job
		gen sjob=d05 if b03==2 & b02==1
		bysort a01: egen mspouse_empl=max(sjob)
		label var mspouse_empl "Male spouse's employment"
		label value mspouse_empl job

		gen hhrworked=d06 if b03==1 & b02==1
		bysort a01: egen mhead_hrworked=max(hhrworked)
		label var mhead_hrworked "Male head, hours worked"
		gen shrworked=d06 if b03==2 & b02==1
		bysort a01: egen mspouse_hrworked=max(shrworked)
		label var mspouse_hrworked "Male spouse, hours worked"

		gen hjob1=d08 if b03==1 & b02==1
		bysort a01: egen mhead_empls=max(hjob1)
		label var mhead_empls "Male head's monthly salary - primary employment"
		gen sjob1=d08 if b03==2 & b02==1
		bysort a01: egen mspouse_empls=max(sjob1)
		label var mspouse_empls "Male spouse's monthly salary - primary employment"

		gen hjob2=d09 if b03==1 & b02==1
		bysort a01: egen mhead_noempl=max(hjob2)
		label var mhead_noempl "Male head, why not employed"
		gen sjob2=d09 if b03==2 & b02==1
		bysort a01: egen mspouse_noempl=max(sjob2)
		label var mspouse_noempl "Male spouse, why not employed"

		gen hdomlabor=d10 if b03==1 & b02==1
		bysort a01: egen mhead_domlabor=max(hdomlabor)
		label var mhead_domlabor "Male head, domestic labor"
		gen sdomlabor=d10 if b03==2 & b02==1
		bysort a01: egen mspouse_domlabor=max(sdomlabor)
		label var mspouse_domlabor "Male spouse, domestic labor"

		gen hdomlaborhr=d11 if b03==1 & b02==1
		bysort a01: egen mhead_domlaborhr=max(hdomlaborhr)
		label var mhead_domlaborhr "Male head, hours spent per day on domestic labor"
		gen sdomlaborhr=d11 if b03==2 & b02==1
		bysort a01: egen mspouse_domlaborhr=max(sdomlaborhr)
		label var mspouse_domlaborhr "Male spouse, hours spent per day on domestic labor"

	*control variables 
		*children 
		g children0t5=b04<6 
		bysort a01: egen nchildren0t5=total(children0t5)
		label var nchildren0t5 "Number of children 0-5 years"
		
		g children6t14=b04>=6 & b04<15
		bysort a01: egen nchildren6t14=total(children6t14)
		label var nchildren6t14 "Number of children 6-14 years"
	
	*merging
	keep if id1a==1
	keep a01 mhead* mspouse* nchildren*
	
	sort a01
	merge 1:1 a01 using `bl_temp'
	drop _merge
	
	rename id1a id0m
	g id=id0m
	label var id "Duplicate id from section T"
	

**2.3 Saving temp bl dataset and preparing for merge 

	order a01 id a* b* d* e* id0m t* 
	
	foreach var of varlist *{
		rename `var' bl_`var'
		}

	rename bl_a01 a01
	
	sort a01 
	save `bl_temp', replace	
	
*********************3.Creating dataset for analysis*********************************************************
	

**3.1 Merging in follow-up with baseline
	sort a01
	merge 1:1 a01  using `el_temp'
	drop _merge

	*renaming dv variables at baseline
	rename bl_id0m bl_id0t
	label var bl_id0t "Informante ID-Seccion T"
	
	*recoding tnohaymujer
	replace bl_tnohaymujer=1 if bl_tb==1 & bl_t10~=.

	*looking at matches across rounds of individual responding to IPV module
	egen diffid=diff(bl_id0t el_idsecc_t)
	tab diffid 
	tab diffid if bl_t05~=. & el_t05~=. /*not merging for DM*/ 
	tab diffid if bl_t10~=. & el_t10~=. /*not merging for IPV*/ 
		
	list a01  bl_id0t el_idsecc_t bl_b04 el_b04 if diffid==1 &  bl_t05~=. & el_t05~=.


**3.2 Merging in asset index 
	sort a01 
	merge 1:1 a01 using "$OTHER\asset_index.dta"
	
	rename b_asset_index bl_asset_index
			
	drop if _merge~=3
	drop _merge

	sort a01 
	tempfile temp
	save `temp', replace
	
**3.3 merging and reshaping non-food consumption
	use "$OTHER\nonfood consumpt.dta", clear
	
	*renaming
	foreach var in el bl  {
		rename v_n_cons_pc_`var' `var'_nfcons_pc_
	}

	reshape wide  el_nfcons_pc_  bl_nfcons_pc_ , i(a01) j(nfood_group)
		
	*labels
	foreach t in el bl {
		
		label var `t'_nfcons_pc_12 "Per capita per day consumption (USD): Men's clothes"
		label var `t'_nfcons_pc_13 "Per capita per day consumption (USD): Women's clothes"
		label var `t'_nfcons_pc_14 "Per capita per day consumption (USD): Child's clothes"

		}
		
	sort a01
	merge 1:1 a01 using `temp'
	drop _merge

**3.3 merging hh consumption
	merge 1:1 a01 using "$OTHER\total consumpt.dta"

	*renaming
	foreach t in el bl {
		rename v_fneh_cons_pc_`t' `t'_fneh_totcons_pc
		rename v_n_cons_pc_`t' `t'_nfcons_pc
		}
		
	drop _merge


**3.4 preparing to save dataset


	sort a01
	order a01 bl_id bl_a* bl_b* bl_d* bl_e* bl_id0t bl_t*  bl_mh* bl_ms* bl* el_id el_a* el_b* el_d* el_idsecc_t el_t* el_mh* el_ms*
	
	save "D:\Melissa Hidrobo\WFP\Ecuador\Paper 2- DV\Quant analysis\Drafts\AEJ submission\Data and dofiles\Data\DV_baseline_followup", replace

