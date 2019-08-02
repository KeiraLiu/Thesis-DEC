***************************************************************************
*			Title: WINGS Analysis : SSM
*			This .do produces the exact tables reported in the SSM paper.
*****************************************************************************

///////////////
// 1.0 SETUP //
///////////////

	// 1.0 DIRECTORIES
					
			clear
			clear matrix 
			clear mata
			set maxvar 8000
			set more off  
			set mem 300m
			
		// SET PERSONAL DIRECTORY
			*gl WINGS "** SET ROOT DIRECTORY HERE **" 
			gl WINGS "*INSERT WORKING DIRECTORY HERE*"
			
		// SET OUTPUT DIRECTORY
			cd "$WINGS/Output"	
			
		// OPEN DATASET
			use "$WINGS/Data/WINGSAnalysis_prepped_jan2015.dta"

	// 1.1 VARIABLE CONSTRUCTION FOR PER PROTOCOL ANALYSIS
						
			gen IPcomplier_p2_Wplus = 0 if sample_p2==1
			replace IPcomplier_p2_Wplus = 1 if assigned_p2_Wplus==0 & treated_p2_Wplus==0
			replace IPcomplier_p2_Wplus = 1 if assigned_p2_Wplus==1 & treated_p2_Wplus==1 & partner_relation==1
		
		
		foreach var in physicalhealth_bas {
				local lab : var label `var' 
				qui sum `var', d
				gen `var'_z = (`var'-r(mean))/r(sd)
				la var `var'_z "`lab' (z-score)"
				gen A_`var'_z = `var'_z * (assigned_p1 == 1)
			}
		
		
	// 1.2 SET ANALYSIS GLOBALS

		gl D "age_bas female hhsize_bas partner_bas onlyearner_bas biochildren_bas nonacholi_bas"
		gl DH_main "age_bas female partner_bas attainment_dup_p1e hiv_bas"
		gl D_midline "partner_p1e_imp"
		gl H "stillenrolled_bas attainment_dup_p1e writingskills_bas speakengl_bas trainlength_bas stddigitrecall"
		gl H_midline "enrolled_p1e_imp"
		gl E "pettybiz_dum_bas dugo1_hrs7d_p99_bas duge1_hrs7d_p99_bas casual_hrs7d_p99_bas  brew_hrs7d_p99_bas buy_hrs7d_p99_bas others_hrs7d_p99_bas chores_hrs7d_p99_bas zero_employment_bas"
		gl E_midline "pettybiz_dum_p1e_imp biznow_p1e_imp igastart_p1e_imp total_hrs7d_s2p99_p1e_imp agri_hrs7d_s2p99_p1e_imp nonagri_hrs7d_s2p99_p1e_imp chores_hrs7d_p99_p1e_imp zero_employment_p1e_imp main_agricultural_p1e_imp"
		gl K "wealthindex_all_bas cashtotal4w_basp99_1000 otherhh_earnings_bas savingsgroup_bas savings_basp99_1000 currloans_basp99_1000 creditaccess15_bas creditaccess100_bas"
		gl K_main "wealthindex_all_bas cashtotal4w_basp99_1000 savingsgroup_bas savings_basp99_1000 currloans_basp99_1000 creditaccess15_bas creditaccess100_bas"
		gl K_midline "wealthindex_all_p1e_imp cashtotal4w_p1ep99_r_imp consaggpercap2_z_p1e_imp savingsgroup_p1e_imp savings_p1ep99_r_imp currloans_p1ep99_r_imp perceivedcreditaccess_p1e_imp"
		gl F "hhsupport_z_bas commparticipation_z_bas decision_making_z_bas physemo_abuse_z_bas neighborsupport_z_bas groupsin_bas comm_maltreat_bas decision_making_z_bas womens_rights_z_bas relatedchief_bas"
		gl F_main "comm_maltreat_bas relatedchief_bas"
		gl F_midline "comm_particip_z_p1e_imp neighborsupport_z_p1e_imp decision_making_z_p1e_imp purchase_autonomyv2_z_p1e_imp socialsupport_z_p1e_imp womens_rights_z_p1e_imp groupsin_p1e_imp"
		gl H2 "healthindex_bas hiv_bas APAI_Ravg_bas"
		gl H_midline "healthindex_p1e_imp APAI_Ravg_p1e_imp"
		gl W "war_exper_bas_z recruited_bas carriedgun_bas forciblymarried_bas borechild_bas"
		gl W_main "war_exper_bas_z recruited_bas carriedgun_bas forciblymarried_bas"
		gl P "risk_aversion_bas patience_zscore"
		gl P_midline "patience_ibm_p1e_z_imp"
		gl V "vilpopulation c_np_educ2 siteid_sample_p1 remoteness pricelevel rentland_sq camp ngo_total c_vending_p99 c_kiosk_p99 c_shops_p99 c_tailoring_p99 c_hotel_p99 c_othercommarket distancetocapital district1" 
		gl V_main "vilpopulation distancetocapital matatu vilmarket c_shops_p99 ngo_total"
		gl extra "matatu closepriwalk nomobile payphonewalk health2walk vilmarket nextmarketwalk rentland"
		gl interactions "A_age_bas A_hhsize_bas A_partner_bas A_biochildren_bas A_nonacholi_bas A_stillenrolled_bas A_attainment_dup_p1e A_writingskills_bas A_speakengl_bas A_trainlength_bas A_stddigitrecall A_total_hrs7d_s2p99_bas A_animalo1_hrs7d_p99_bas A_dugo_hrs7d_p99_bas A_duge1_hrs7d_p99_bas A_leje_hrs7d_p99_bas A_brew_hrs7d_p99_bas A_buy_hrs7d_p99_bas A_others_hrs7d_p99_bas A_chores_hrs7d_p99_bas A_zero_employment_bas A_main_agricultural_bas A_wealthindex_all_bas A_cashtotal4w_basp99_1000 A_otherhh_earnings_bas A_savingsgroup_bas A_savings_basp99_1000 A_loan_basp99_1000 A_creditaccess15_bas A_creditaccess100_bas A_hhsupport_z_bas A_commparticipation_z_bas A_neighborsupport_z_bas A_comm_maltreat_bas A_dom_violence_z_p1e A_decision_making_z_bas A_women_rights_z_bas A_relatedchief_bas A_physicalhealth_bas A_hiv_bas A_APAI_Ravg_bas A_war_exper_bas_z A_recruited_bas A_carriedgun_bas A_forciblymarried_bas A_borechild_bas A_risk_aversion_bas A_patience_zscore"
	 
		gl controls_main "$D $H $E $K $F $H2 $W $P $V"
		gl controls_basic "$D $H $E $K $H2 $W $P $V"
		gl spillovers "D_T_bar_4_b50 D_T_4_b50"
		gl extra "matatu closepriwalk nomobile payphonewalk health2walk vilmarket nextmarketwalk rentland"
		gl controls_midline "$D_midline $E_midline $K_midline $F_midline $H_midline $P_midline "  
		
		gl controls_table2 "$DH_main $E $K_main $F_main $W_main $V_main"
		gl outcomes_table3 "employ_occ_index_z_p1e igastart_p1e biznow_p1e nonagri_hrs7d_s2p99_p1e incomeindex_p1e total_profit4w_r_s2p99_p1e wealthindex_all_p1e consaggpercap2_z_p1e womens_rights_z_p1e purchase_autonomyv2_z_p1e partrelskillindex2_z_p1e physemo_abuse_z_p1e marital_control_z_p1e"
		gl outcomes_table4 "incomeindex_p1e total_profit4w_r_s2p99_p1e wealthindex_all_p1e consaggpercap2_z_p1e igastart_p1e biznow_p1e chores_hrs7d_p99_p1e"
		gl outcomes_table5 "employ_occ_index_z_p2e igastart_p2e biznow_p2e nonagri_hrs7d_s2p99_p2e incomeindex_p2e total_profit4w_r_s2p99_p2e wealthindex_all_p2e consaggpercap2_z_p2e womens_rights_z_p2e purchase_autonomyv2_z_p2e partrelskillindex2_z_p2e partsupportindex_z_p2e partfamsupport_z_p2e partbizsupport_z_p2e physemo_abuse_z_p2e marital_control_z_p2e"
	
	// 1.3 SET RUN STYLE
		/* Set $exit as "exit" if you want to run 
		graphs 1 at a time. Set to "" if you want 
		to run continuously. */
		gl exit = ""

	$exit
		
		
///////////////////////////////////////
//       2.0 TABLES AND FIGURES      //
///////////////////////////////////////

	// TABLE 2: Baseline descriptive statistics and test of balance 
		local i = 0
		foreach x of global controls_table2 {
			local ++i
			local var`i' "`x'"
			/* Phase 1 treatment versus control */
			qui sum `x' if assigned_p1 == 0
				local m_p1c`i' = r(mean)
				local s_p1c`i' = r(sd)
			qui sum `x' if assigned_p1 == 1
				local m_p1t`i' = r(mean)
				local s_p1t`i' = r(sd)
			qui reg `x' assigned_p1 district1 if sample_p1==1, cluster(siteid)
				qui testparm assigned_p1
				local pstat_p1`i' = r(p)
			/* Phase 2 treatment versus control */
			qui sum `x' if assigned_p2_Wplus == 0
				local m_p2c`i' = r(mean)
				local s_p2c`i' = r(sd)
			qui sum `x' if assigned_p2_Wplus == 1
				local m_p2t`i' = r(mean)
				local s_p2t`i' = r(sd)
			qui reg `x' assigned_p2_Wplus district1 if sample_p2==1, cluster(siteid)
				qui testparm assigned_p2_Wplus
				local pstat_p2`i' = r(p)
		}
	
		local I = `i'
		preserve
			clear
			set obs `I'
			foreach v in var m_p1c s_p1c m_p1t s_p1t pstat_p1 ///
			m_p2c s_p2c m_p2t s_p2t pstat_p2 {
				qui gen `v' = ""
				forv i = 1/`I' {
					qui replace `v' = "``v'`i''" in `i'
				}
				qui destring `v', replace
			}
			export excel using "ssm tables.xlsx", sheetmodify sheet("t2 raw") firstrow(var)
		 restore
	$exit
		 
		 	
	
	// TABLE 3: IMPACT OF FULL PROGRAM

		local i = 0
		foreach x of global outcomes_table3 {
			local ++i
			local var_`i' "`x'"
			/* Control Outcomes */
			qui sum `x' if sample_p1==1 & assigned_p1==0 & found_p1e == 1
			local m_p1ec_`i' = r(mean)
			local sd_p1ec_`i' = r(sd)
			}
			
		/* ITT estimates, All */		
		local i = 0	
			foreach x of global outcomes_table3 {
			local ++i
				reg `x' $controls_main $spillovers assigned_p1 if sample_p1==1 & found_p1e == 1, cluster(siteid)
					local b_all_`i' = _b[assigned_p1]
					local se_all_`i' = _se[assigned_p1]
					local p_all_`i' = 2*ttail(e(df_r),abs(_b[assigned_p1]/_se[assigned_p1]))
					local ci05_all_`i' = _b[assigned_p1] - invttail(e(df_r),0.025)*_se[assigned_p1]
					local ci95_all_`i' = _b[assigned_p1] + invttail(e(df_r),0.025)*_se[assigned_p1]
					
					/* Format Confidence Interval */
						local ci05_all_`i' = round(`ci05_all_`i'', .001)
						local ci95_all_`i' = round(`ci95_all_`i'', .001)
						
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_all_`i''",strpos("`ci`q'_all_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_all_`i' = substr("`ci`q'_all_`i''",1,strpos("`ci`q'_all_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_all_`i' = "`ci`q'_all_`i''0"
							if (strlen("`dec'")==2) local ci`q'_all_`i' = "`ci`q'_all_`i''00"
							if (strlen("`dec'")<2) local ci`q'_all_`i' = "`ci`q'_all_`i'000"
							}
						local ci_all_`i' = "`ci05_all_`i'' - `ci95_all_`i''"
					
					/* Format Standard Errors */
						local se_all_`i' = round(`se_all_`i'',.001)
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
							local dec = ""
							local dec = substr("`se_all_`i''",strpos("`se_all_`i''","."),.)
							if (strlen("`dec'")>4) local se_all_`i' = substr("`se_all_`i''",1,strpos("`se_all_`i''",".")+3)
							if (strlen("`dec'")==3) local se_all_`i' = "`se_all_`i''0"
							if (strlen("`dec'")==2) local se_all_`i' = "`se_all_`i''00"
							if (strlen("`dec'")<2) local se_all_`i' = "`se_all_`i'000"
						/* Put some brackets and asterisks on the standard errors */
							local se_all_`i' = "[`se_all_`i'']"
							if (`p_all_`i''<=.1) local se_all_`i' = "`se_all_`i''*"
							if (`p_all_`i''<=.05) local se_all_`i' = "`se_all_`i''*"
							if (`p_all_`i''<=.01) local se_all_`i' = "`se_all_`i''*"
							dis "`se_all_`i''"
			}
			
		/* ITT estimates, Women only */
		local i = 0	
			foreach x of global outcomes_table3 {
			local ++i
				reg `x' $controls_main $spillovers assigned_p1 if sample_p1==1 & female & found_p1e == 1, cluster(siteid)
					local b_f_`i' = _b[assigned_p1]
					local se_f_`i' = _se[assigned_p1]
					local p_f_`i' = 2*ttail(e(df_r),abs(_b[assigned_p1]/_se[assigned_p1]))
					local ci05_f_`i' = _b[assigned_p1] - invttail(e(df_r),0.025)*_se[assigned_p1]
					local ci95_f_`i' = _b[assigned_p1] + invttail(e(df_r),0.025)*_se[assigned_p1]
					
					/* Format Confidence Interval */
						local ci05_f_`i' = round(`ci05_f_`i'', .001)
						local ci95_f_`i' = round(`ci95_f_`i'', .001)
		
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_f_`i''",strpos("`ci`q'_f_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_f_`i' = substr("`ci`q'_f_`i''",1,strpos("`ci`q'_f_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_f_`i' = "`ci`q'_f_`i''0"
							if (strlen("`dec'")==2) local ci`q'_f_`i' = "`ci`q'_f_`i''00"
							if (strlen("`dec'")<2) local ci`q'_f_`i' = "`ci`q'_f_`i'000"
							}
							
						local ci_f_`i' = "`ci05_f_`i'' - `ci95_f_`i''"
					
					/* Format Standard Errors */
						local se_f_`i' = round(`se_f_`i'',.001)
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
							local dec = ""
							local dec = substr("`se_f_`i''",strpos("`se_f_`i''","."),.)
							if (strlen("`dec'")>4) local se_f_`i' = substr("`se_f_`i''",1,strpos("`se_f_`i''",".")+3)
							if (strlen("`dec'")==3) local se_f_`i' = "`se_f_`i''0"
							if (strlen("`dec'")==2) local se_f_`i' = "`se_f_`i''00"
							if (strlen("`dec'")<2) local se_f_`i' = "`se_f_`i'000"
						/* Put some brackets and asterisks on the standard errors */
							local se_f_`i' = "[`se_f_`i'']"
							if (`p_f_`i''<=.1) local se_f_`i' = "`se_f_`i''*"
							if (`p_f_`i''<=.05) local se_f_`i' = "`se_f_`i''*"
							if (`p_f_`i''<=.01) local se_f_`i' = "`se_f_`i''*"
							dis "`se_f_`i''"
			}
			
		/* Build table */
		local I = `i'
		preserve
			clear
			set obs `I'
			foreach v in var m_p1ec sd_p1ec b_all se_all ci_all b_f se_f ci_f {
				qui gen `v' = ""
				forv i = 1/`I' {
					qui replace `v' = "``v'_`i''" in `i' 
				}
				qui destring `v', replace
			}
			export excel using "ssm tables.xlsx", sheetmodify sheet("t3 raw") firstrow(var)
		 restore
	$exit
	
	
	
	// Table 4 - Heterogeneity - Original Version Excluding $controls_main
		
		cap qui gen A_IP_control_z_bas = assigned_p1*IP_control_z_bas
		cap qui gen A_treatwellrarelynever_bas = assigned_p1*treatwell_rarelynever_bas
		
		/* Top half: IPV */
		local i = 0	
			foreach y of global outcomes_table4 {
			local ++i
			local var_`i' "`y'"
				reg `y' $spillovers assigned_p1 IP_control_z_bas  A_IP_control_z_bas if sample_p1==1 & female==1 & partner_bas==1 & found_p1e == 1, cluster(siteid)
					local b_ipv_z_`i' = _b[assigned_p1]
					local se_ipv_z_`i' = _se[assigned_p1]
					local p_ipv_z_`i' = 2*ttail(e(df_r),abs(_b[assigned_p1]/_se[assigned_p1]))
					
					local b_ipv_x_`i' = _b[IP_control_z_bas]
					local se_ipv_x_`i' = _se[IP_control_z_bas]
					local p_ipv_x_`i' = 2*ttail(e(df_r),abs(_b[IP_control_z_bas]/_se[IP_control_z_bas]))
						
					local b_ipv_zx_`i' = _b[A_IP_control_z_bas]
					local se_ipv_zx_`i' = _se[A_IP_control_z_bas]
					local p_ipv_zx_`i' = 2*ttail(e(df_r),abs(_b[A_IP_control_z_bas]/_se[A_IP_control_z_bas]))
					local ci05_ipv_zx_`i' = _b[A_IP_control_z_bas] - invttail(e(df_r),0.025)*_se[A_IP_control_z_bas]
					local ci95_ipv_zx_`i' = _b[A_IP_control_z_bas] + invttail(e(df_r),0.025)*_se[A_IP_control_z_bas]
					
					/* Format Confidence Interval */
						local ci05_ipv_zx_`i' = round(`ci05_ipv_zx_`i'', .001)
						local ci95_ipv_zx_`i' = round(`ci95_ipv_zx_`i'', .001)
						
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_ipv_zx_`i''",strpos("`ci`q'_ipv_zx_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_ipv_zx_`i' = substr("`ci`q'_ipv_zx_`i''",1,strpos("`ci`q'_ipv_zx_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_ipv_zx_`i' = "`ci`q'_ipv_zx_`i''0"
							if (strlen("`dec'")==2) local ci`q'_ipv_zx_`i' = "`ci`q'_ipv_zx_`i''00"
							if (strlen("`dec'")<2) local ci`q'_ipv_zx_`i' = "`ci`q'_ipv_zx_`i'000"
							}
						local ci_ipv_zx_`i' = "`ci05_ipv_zx_`i'' - `ci95_ipv_zx_`i''"
					
					/* Format Standard Errors */
						foreach q in z x zx {
							local se_ipv_`q'_`i' = round(`se_ipv_`q'_`i'',.001)
							/* Occasionally the round function gives output 
							like 1.2340000000000001. Here, we truncate those outputs */
								local dec = ""
								local dec = substr("`se_ipv_`q'_`i''",strpos("`se_ipv_`q'_`i''","."),.)
								if (strlen("`dec'")>4) local se_ipv_`q'_`i' = substr("`se_ipv_`q'_`i''",1,strpos("`se_ipv_`q'_`i''",".")+3)
								if (strlen("`dec'")==3) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''0"
								if (strlen("`dec'")==2) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''00"
								if (strlen("`dec'")<2) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i'000"
							/* Put some brackets and asterisks on the standard errors */
								local se_ipv_`q'_`i' = "[`se_ipv_`q'_`i'']"
								if (`p_ipv_`q'_`i''<=.1) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''*"
								if (`p_ipv_`q'_`i''<=.05) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''*"
								if (`p_ipv_`q'_`i''<=.01) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''*"
						}
			}

 
			/* Bottom half: Treat well */
			local i = 0	
			foreach y of global outcomes_table4 {
			local ++i
				reg `y' $spillovers assigned_p1 treatwell_rarelynever_bas  A_treatwellrarelynever_bas if sample_p1==1 & female==1 & partner_bas==1 & found_p1e == 1, cluster(siteid)
					local b_well_z_`i' = _b[assigned_p1]
					local se_well_z_`i' = _se[assigned_p1]
					local p_well_z_`i' = 2*ttail(e(df_r),abs(_b[assigned_p1]/_se[assigned_p1]))
					
					local b_well_x_`i' = _b[treatwell_rarelynever_bas]
					local se_well_x_`i' = _se[treatwell_rarelynever_bas]
					local p_well_x_`i' = 2*ttail(e(df_r),abs(_b[treatwell_rarelynever_bas]/_se[treatwell_rarelynever_bas]))
						
					local b_well_zx_`i' = _b[A_treatwellrarelynever_bas]
					local se_well_zx_`i' = _se[A_treatwellrarelynever_bas]
					local p_well_zx_`i' = 2*ttail(e(df_r),abs(_b[A_treatwellrarelynever_bas]/_se[A_treatwellrarelynever_bas]))
					local ci05_well_zx_`i' = _b[A_treatwellrarelynever_bas] - invttail(e(df_r),0.025)*_se[A_treatwellrarelynever_bas]
					local ci95_well_zx_`i' = _b[A_treatwellrarelynever_bas] + invttail(e(df_r),0.025)*_se[A_treatwellrarelynever_bas]
					
					/* Format Confidence Interval */
						local ci05_well_zx_`i' = round(`ci05_well_zx_`i'', .001)
						local ci95_well_zx_`i' = round(`ci95_well_zx_`i'', .001)
						
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_well_zx_`i''",strpos("`ci`q'_well_zx_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_well_zx_`i' = substr("`ci`q'_well_zx_`i''",1,strpos("`ci`q'_well_zx_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_well_zx_`i' = "`ci`q'_well_zx_`i''0"
							if (strlen("`dec'")==2) local ci`q'_well_zx_`i' = "`ci`q'_well_zx_`i''00"
							if (strlen("`dec'")<2) local ci`q'_well_zx_`i' = "`ci`q'_well_zx_`i'000"
							}
						local ci_well_zx_`i' = "`ci05_well_zx_`i'' - `ci95_well_zx_`i''"
					
					/* Format Standard Errors */
						foreach q in z x zx {
							local se_well_`q'_`i' = round(`se_well_`q'_`i'',.001)
							/* Occasionally the round function gives output 
							like 1.2340000000000001. Here, we truncate those outputs */
								local dec = ""
								local dec = substr("`se_well_`q'_`i''",strpos("`se_well_`q'_`i''","."),.)
								if (strlen("`dec'")>4) local se_well_`q'_`i' = substr("`se_well_`q'_`i''",1,strpos("`se_well_`q'_`i''",".")+3)
								if (strlen("`dec'")==3) local se_well_`q'_`i' = "`se_well_`q'_`i''0"
								if (strlen("`dec'")==2) local se_well_`q'_`i' = "`se_well_`q'_`i''00"
								if (strlen("`dec'")<2) local se_well_`q'_`i' = "`se_well_`q'_`i'000"
							/* Put some brackets and asterisks on the standard errors */
								local se_well_`q'_`i' = "[`se_well_`q'_`i'']"
								if (`p_well_`q'_`i''<=.1) local se_well_`q'_`i' = "`se_well_`q'_`i''*"
								if (`p_well_`q'_`i''<=.05) local se_well_`q'_`i' = "`se_well_`q'_`i''*"
								if (`p_well_`q'_`i''<=.01) local se_well_`q'_`i' = "`se_well_`q'_`i''*"
						}
			}

		/* Build table */
		local I = `i'
		preserve
			clear
			set obs `I'
			foreach v in var b_ipv_z se_ipv_z b_ipv_x se_ipv_x b_ipv_zx se_ipv_zx ci_ipv_zx ///
						     b_well_z se_well_z b_well_x se_well_x b_well_zx se_well_zx ci_well_zx {
				qui gen `v' = ""
				forv i = 1/`I' {
					qui replace `v' = "``v'_`i''" in `i' 
				}
				qui destring `v', replace
			}
			export excel using "ssm tables.xlsx", sheetmodify sheet("t4 raw") firstrow(var)
		 restore
	$exit

// Table 4 - Heterogeneity -  Version Including $controls_main
		
		cap qui gen A_IP_control_z_bas = assigned_p1*IP_control_z_bas
		cap qui gen A_treatwellrarelynever_bas = assigned_p1*treatwell_rarelynever_bas
		
		/* Top half: IPV */
		local i = 0	
			foreach y of global outcomes_table4 {
			local ++i
			local var_`i' "`y'"
				reg `y' $controls_main $spillovers assigned_p1 IP_control_z_bas  A_IP_control_z_bas if sample_p1==1 & female==1 & partner_bas==1 & found_p1e == 1, cluster(siteid)
					local b_ipv_z_`i' = _b[assigned_p1]
					local se_ipv_z_`i' = _se[assigned_p1]
					local p_ipv_z_`i' = 2*ttail(e(df_r),abs(_b[assigned_p1]/_se[assigned_p1]))
					
					local b_ipv_x_`i' = _b[IP_control_z_bas]
					local se_ipv_x_`i' = _se[IP_control_z_bas]
					local p_ipv_x_`i' = 2*ttail(e(df_r),abs(_b[IP_control_z_bas]/_se[IP_control_z_bas]))
						
					local b_ipv_zx_`i' = _b[A_IP_control_z_bas]
					local se_ipv_zx_`i' = _se[A_IP_control_z_bas]
					local p_ipv_zx_`i' = 2*ttail(e(df_r),abs(_b[A_IP_control_z_bas]/_se[A_IP_control_z_bas]))
					local ci05_ipv_zx_`i' = _b[A_IP_control_z_bas] - invttail(e(df_r),0.025)*_se[A_IP_control_z_bas]
					local ci95_ipv_zx_`i' = _b[A_IP_control_z_bas] + invttail(e(df_r),0.025)*_se[A_IP_control_z_bas]
					
					/* Format Confidence Interval */
						local ci05_ipv_zx_`i' = round(`ci05_ipv_zx_`i'', .001)
						local ci95_ipv_zx_`i' = round(`ci95_ipv_zx_`i'', .001)
						
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_ipv_zx_`i''",strpos("`ci`q'_ipv_zx_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_ipv_zx_`i' = substr("`ci`q'_ipv_zx_`i''",1,strpos("`ci`q'_ipv_zx_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_ipv_zx_`i' = "`ci`q'_ipv_zx_`i''0"
							if (strlen("`dec'")==2) local ci`q'_ipv_zx_`i' = "`ci`q'_ipv_zx_`i''00"
							if (strlen("`dec'")<2) local ci`q'_ipv_zx_`i' = "`ci`q'_ipv_zx_`i'000"
							}
						local ci_ipv_zx_`i' = "`ci05_ipv_zx_`i'' - `ci95_ipv_zx_`i''"
					
					/* Format Standard Errors */
						foreach q in z x zx {
							local se_ipv_`q'_`i' = round(`se_ipv_`q'_`i'',.001)
							/* Occasionally the round function gives output 
							like 1.2340000000000001. Here, we truncate those outputs */
								local dec = ""
								local dec = substr("`se_ipv_`q'_`i''",strpos("`se_ipv_`q'_`i''","."),.)
								if (strlen("`dec'")>4) local se_ipv_`q'_`i' = substr("`se_ipv_`q'_`i''",1,strpos("`se_ipv_`q'_`i''",".")+3)
								if (strlen("`dec'")==3) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''0"
								if (strlen("`dec'")==2) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''00"
								if (strlen("`dec'")<2) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i'000"
							/* Put some brackets and asterisks on the standard errors */
								local se_ipv_`q'_`i' = "[`se_ipv_`q'_`i'']"
								if (`p_ipv_`q'_`i''<=.1) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''*"
								if (`p_ipv_`q'_`i''<=.05) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''*"
								if (`p_ipv_`q'_`i''<=.01) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''*"
						}
			}

 
			/* Bottom half: Treat well */
			local i = 0	
			foreach y of global outcomes_table4 {
			local ++i
				reg `y' $controls_main $spillovers assigned_p1 treatwell_rarelynever_bas  A_treatwellrarelynever_bas if sample_p1==1 & female==1 & partner_bas==1 & found_p1e == 1, cluster(siteid)
					local b_well_z_`i' = _b[assigned_p1]
					local se_well_z_`i' = _se[assigned_p1]
					local p_well_z_`i' = 2*ttail(e(df_r),abs(_b[assigned_p1]/_se[assigned_p1]))
					
					local b_well_x_`i' = _b[treatwell_rarelynever_bas]
					local se_well_x_`i' = _se[treatwell_rarelynever_bas]
					local p_well_x_`i' = 2*ttail(e(df_r),abs(_b[treatwell_rarelynever_bas]/_se[treatwell_rarelynever_bas]))
						
					local b_well_zx_`i' = _b[A_treatwellrarelynever_bas]
					local se_well_zx_`i' = _se[A_treatwellrarelynever_bas]
					local p_well_zx_`i' = 2*ttail(e(df_r),abs(_b[A_treatwellrarelynever_bas]/_se[A_treatwellrarelynever_bas]))
					local ci05_well_zx_`i' = _b[A_treatwellrarelynever_bas] - invttail(e(df_r),0.025)*_se[A_treatwellrarelynever_bas]
					local ci95_well_zx_`i' = _b[A_treatwellrarelynever_bas] + invttail(e(df_r),0.025)*_se[A_treatwellrarelynever_bas]
					
					/* Format Confidence Interval */
						local ci05_well_zx_`i' = round(`ci05_well_zx_`i'', .001)
						local ci95_well_zx_`i' = round(`ci95_well_zx_`i'', .001)
						
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_well_zx_`i''",strpos("`ci`q'_well_zx_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_well_zx_`i' = substr("`ci`q'_well_zx_`i''",1,strpos("`ci`q'_well_zx_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_well_zx_`i' = "`ci`q'_well_zx_`i''0"
							if (strlen("`dec'")==2) local ci`q'_well_zx_`i' = "`ci`q'_well_zx_`i''00"
							if (strlen("`dec'")<2) local ci`q'_well_zx_`i' = "`ci`q'_well_zx_`i'000"
							}
						local ci_well_zx_`i' = "`ci05_well_zx_`i'' - `ci95_well_zx_`i''"
					
					/* Format Standard Errors */
						foreach q in z x zx {
							local se_well_`q'_`i' = round(`se_well_`q'_`i'',.001)
							/* Occasionally the round function gives output 
							like 1.2340000000000001. Here, we truncate those outputs */
								local dec = ""
								local dec = substr("`se_well_`q'_`i''",strpos("`se_well_`q'_`i''","."),.)
								if (strlen("`dec'")>4) local se_well_`q'_`i' = substr("`se_well_`q'_`i''",1,strpos("`se_well_`q'_`i''",".")+3)
								if (strlen("`dec'")==3) local se_well_`q'_`i' = "`se_well_`q'_`i''0"
								if (strlen("`dec'")==2) local se_well_`q'_`i' = "`se_well_`q'_`i''00"
								if (strlen("`dec'")<2) local se_well_`q'_`i' = "`se_well_`q'_`i'000"
							/* Put some brackets and asterisks on the standard errors */
								local se_well_`q'_`i' = "[`se_well_`q'_`i'']"
								if (`p_well_`q'_`i''<=.1) local se_well_`q'_`i' = "`se_well_`q'_`i''*"
								if (`p_well_`q'_`i''<=.05) local se_well_`q'_`i' = "`se_well_`q'_`i''*"
								if (`p_well_`q'_`i''<=.01) local se_well_`q'_`i' = "`se_well_`q'_`i''*"
						}
			}

		/* Build table */
		local I = `i'
		preserve
			clear
			set obs `I'
			foreach v in var b_ipv_z se_ipv_z b_ipv_x se_ipv_x b_ipv_zx se_ipv_zx ci_ipv_zx ///
						     b_well_z se_well_z b_well_x se_well_x b_well_zx se_well_zx ci_well_zx {
				qui gen `v' = ""
				forv i = 1/`I' {
					qui replace `v' = "``v'_`i''" in `i' 
				}
				qui destring `v', replace
			}
			export excel using "ssm tables.xlsx", sheetmodify sheet("t4 raw ctrl") firstrow(var)
		 restore
	$exit

		 
	// TABLE 5: IMPACT OF W+ PROGRAM

		local i = 0
		foreach x of global outcomes_table5 {
			local ++i
			local var_`i' "`x'"
			/* Control Outcomes */
			qui sum `x' if sample_p2==1 & assigned_p2_Wplus ==0 & female==1 & found_p2e == 1
			local m_p1ec_`i' = r(mean)
			local sd_p1ec_`i' = r(sd)
			}
			
		/* ITT estimates, All women */		
		local i = 0	
			foreach x of global outcomes_table5 {
			local ++i
				reg `x' $controls_main $controls_midline $spillovers assigned_p2_Wplus if sample_p2==1 & female==1 & found_p2e == 1, cluster(siteid)
					local b_all_`i' = _b[assigned_p2_Wplus]
					local se_all_`i' = _se[assigned_p2_Wplus]
					local p_all_`i' = 2*ttail(e(df_r),abs(_b[assigned_p2_Wplus]/_se[assigned_p2_Wplus]))
					local ci05_all_`i' = _b[assigned_p2_Wplus] - invttail(e(df_r),0.025)*_se[assigned_p2_Wplus]
					local ci95_all_`i' = _b[assigned_p2_Wplus] + invttail(e(df_r),0.025)*_se[assigned_p2_Wplus]
					
					/* Format Confidence Interval */
						local ci05_all_`i' = round(`ci05_all_`i'', .001)
						local ci95_all_`i' = round(`ci95_all_`i'', .001)
						
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_all_`i''",strpos("`ci`q'_all_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_all_`i' = substr("`ci`q'_all_`i''",1,strpos("`ci`q'_all_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_all_`i' = "`ci`q'_all_`i''0"
							if (strlen("`dec'")==2) local ci`q'_all_`i' = "`ci`q'_all_`i''00"
							if (strlen("`dec'")<2) local ci`q'_all_`i' = "`ci`q'_all_`i'000"
							}
						local ci_all_`i' = "`ci05_all_`i'' - `ci95_all_`i''"
					
					/* Format Standard Errors */
						local se_all_`i' = round(`se_all_`i'',.001)
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
							local dec = ""
							local dec = substr("`se_all_`i''",strpos("`se_all_`i''","."),.)
							if (strlen("`dec'")>4) local se_all_`i' = substr("`se_all_`i''",1,strpos("`se_all_`i''",".")+3)
							if (strlen("`dec'")==3) local se_all_`i' = "`se_all_`i''0"
							if (strlen("`dec'")==2) local se_all_`i' = "`se_all_`i''00"
							if (strlen("`dec'")<2) local se_all_`i' = "`se_all_`i'000"
						/* Put some brackets and asterisks on the standard errors */
							local se_all_`i' = "[`se_all_`i'']"
							if (`p_all_`i''<=.1) local se_all_`i' = "`se_all_`i''*"
							if (`p_all_`i''<=.05) local se_all_`i' = "`se_all_`i''*"
							if (`p_all_`i''<=.01) local se_all_`i' = "`se_all_`i''*"
							dis "`se_all_`i''"
			}

		/* ITT estimates, female with partner */
		local i = 0	
			foreach x of global outcomes_table5 {
			local ++i
				reg `x' $controls_main $controls_midline $spillovers assigned_p2_Wplus if sample_p2==1 & female==1 & partner_p1e==1 & found_p2e==1, cluster(siteid)
					local b_fp_`i' = _b[assigned_p2_Wplus]
					local se_fp_`i' = _se[assigned_p2_Wplus]
					local p_fp_`i' = 2*ttail(e(df_r),abs(_b[assigned_p2_Wplus]/_se[assigned_p2_Wplus]))
					local ci05_fp_`i' = _b[assigned_p2_Wplus] - invttail(e(df_r),0.025)*_se[assigned_p2_Wplus]
					local ci95_fp_`i' = _b[assigned_p2_Wplus] + invttail(e(df_r),0.025)*_se[assigned_p2_Wplus]
					
					/* Format Confidence Interval */
						local ci05_fp_`i' = round(`ci05_fp_`i'', .001)
						local ci95_fp_`i' = round(`ci95_fp_`i'', .001)
		
					/* Occasionally the round function gives output 
					like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_fp_`i''",strpos("`ci`q'_fp_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_fp_`i' = substr("`ci`q'_fp_`i''",1,strpos("`ci`q'_fp_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_fp_`i' = "`ci`q'_fp_`i''0"
							if (strlen("`dec'")==2) local ci`q'_fp_`i' = "`ci`q'_fp_`i''00"
							if (strlen("`dec'")<2) local ci`q'_fp_`i' = "`ci`q'_fp_`i'000"
							}
							
						local ci_fp_`i' = "`ci05_fp_`i'' - `ci95_fp_`i''"
					
					/* Format Standard Errors */
						local se_fp_`i' = round(`se_fp_`i'',.001)
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
							local dec = ""
							local dec = substr("`se_fp_`i''",strpos("`se_fp_`i''","."),.)
							if (strlen("`dec'")>4) local se_fp_`i' = substr("`se_fp_`i''",1,strpos("`se_fp_`i''",".")+3)
							if (strlen("`dec'")==3) local se_fp_`i' = "`se_fp_`i''0"
							if (strlen("`dec'")==2) local se_fp_`i' = "`se_fp_`i''00"
							if (strlen("`dec'")<2) local se_fp_`i' = "`se_fp_`i'000"
						/* Put some brackets and asterisks on the standard errors */
							local se_fp_`i' = "[`se_fp_`i'']"
							if (`p_fp_`i''<=.1) local se_fp_`i' = "`se_fp_`i''*"
							if (`p_fp_`i''<=.05) local se_fp_`i' = "`se_fp_`i''*"
							if (`p_fp_`i''<=.01) local se_fp_`i' = "`se_fp_`i''*"
			}
			
		/* Build table */
		local I = `i'
		preserve
			clear
			set obs `I'
			foreach v in var m_p1ec sd_p1ec b_all se_all ci_all b_fp se_fp ci_fp {
				qui gen `v' = ""
				forv i = 1/`I' {
					qui replace `v' = "``v'_`i''" in `i' 
				}
				qui destring `v', replace
			}
			export excel using "ssm tables.xlsx", sheetmodify sheet("t5 raw") firstrow(var)
		 restore
	$exit
		 
		 
		 
/* Part 2: NEW DATA/CONTROLS FROM ECON PAPER */	
//////////////
// 1.0 SETUP //
///////////////

	// 1.0 DIRECTORIES
					
			clear
			clear matrix 
			clear mata
			set maxvar 8000
			set more off  
			set mem 300m
	
		// SET PERSONAL DIRECTORY
			*gl WINGS "** SET ROOT DIRECTORY HERE **" 
			gl WINGS "*INSERT WORKING DIRECTORY HERE*"

		// SET OUTPUT DIRECTORY
			cd "$WINGS/Output"	
			
		// OPEN DATASET
			use "$WINGS/Data/WINGSAnalysis_prepped_final.dta"

	// 1.1 VARIABLE CONSTRUCTION FOR PER PROTOCOL ANALYSIS
						
			gen IPcomplier_p2_Wplus = 0 if sample_p2==1
			replace IPcomplier_p2_Wplus = 1 if assigned_p2_Wplus==0 & treated_p2_Wplus==0
			replace IPcomplier_p2_Wplus = 1 if assigned_p2_Wplus==1 & treated_p2_Wplus==1 & partner_relation==1
		
		
		foreach var in physicalhealth_bas {
				local lab : var label `var' 
				qui sum `var', d
				gen `var'_z = (`var'-r(mean))/r(sd)
				la var `var'_z "`lab' (z-score)"
				gen A_`var'_z = `var'_z * (assigned_p1 == 1)
			}
		 
		 
	// 1.2 SET ANALYSIS GLOBALS

	// BASELINE CONTROLS
		gl D "age_bas female hhsize_bas partner_bas onlyearner_bas biochildren_bas nonacholi_bas"
		gl DH_main "age_bas female partner_bas attainment_dup_p1e hiv_bas"
		gl D_midline "partner_p1e_imp"
		gl H "stillenrolled_bas attainment_dup_p1e writingskills_bas speakengl_bas trainlength_bas stddigitrecall"
		gl H_midline "stillenrolled_p1e_imp"
		gl E "pettybiz_dum_bas dugo1_hrs7d_p99_bas duge1_hrs7d_p99_bas casual_hrs7d_p99_bas  brew_hrs7d_p99_bas buy_hrs7d_p99_bas others_hrs7d_p99_bas chores_hrs7d_p99_bas zero_employment_bas"
		gl E_midline "pettybiz_dum_p1e_imp biznow_p1e_imp igastart_p1e_imp total_hrs7d_s2p99_p1e_imp agri_hrs7d_s2p99_p1e_imp nonagri_hrs7d_s2p99_p1e_imp chores_hrs7d_p99_p1e_imp zero_employment_p1e_imp main_agricultural_p1e_imp"
		gl K "wealthindex_all_bas cashtotal4w_basp99_1000 otherhh_earnings_bas savingsgroup_bas savings_basp99_1000 currloans_basp99_1000 creditaccess15_bas creditaccess100_bas"
		gl K_main "wealthindex_all_bas cashtotal4w_basp99_1000 savingsgroup_bas savings_basp99_1000 currloans_basp99_1000 creditaccess15_bas creditaccess100_bas"
		gl K_midline "wealthindex_all_p1e_imp cashtotal4w_p1ep99_r_imp consaggpercap2_z_p1e_imp savingsgroup_p1e_imp savings_p1ep99_r_imp currloans_p1ep99_r_imp perceivedcreditaccess_p1e_imp"
		gl F "hhsupport_z_bas commparticipation_z_bas neighborsupport_z_bas groupsin_bas comm_maltreat_bas physemo_abuse_z_bas decision_making_z_bas womens_rights_z_bas relatedchief_bas"
		gl F_main "comm_maltreat_bas relatedchief_bas"
		gl F_midline "comm_particip_z_p1e_imp neighborsupport_z_p1e_imp decision_making_z_p1e_imp purchase_autonomyv2_z_p1e_imp socialsupport_z_p1e_imp womens_rights_z_p1e_imp groupsin_p1e_imp"
		gl H2 "healthindex_bas hiv_bas APAI_R_z_bas"
		gl H_midline "healthindex_p1e_imp APAI_R_z_p1e_imp"
		gl W "war_exper_bas_z recruited_bas carriedgun_bas forciblymarried_bas borechild_bas"
		gl W_main "war_exper_bas_z recruited_bas carriedgun_bas forciblymarried_bas"
		gl P "risk_aversion_bas patience_zscore"
		gl P_midline "patience_ibm_p1e_z_imp"
		gl V "vilpopulation c_np_educ2 siteid_sample_p1 remoteness pricelevel rentland_sq camp ngo_total c_vending_p99 c_kiosk_p99 c_shops_p99 c_tailoring_p99 c_hotel_p99 c_othercommarket distancetocapital district1" 
		gl V_main "vilpopulation distancetocapital matatu vilmarket c_shops_p99 ngo_total"
		gl extra "matatu closepriwalk nomobile payphonewalk health2walk vilmarket nextmarketwalk rentland"
		gl spillovers "D_T_bar_4_b50 D_T_4_b50"
		
		gl controls_main "$D $H $E $K $F $H2 $W $P $V $spillovers"
		gl controls_A3 "district1 age_bas female partner_bas attainment_dup_p1e stillenrolled_bas agri_hrs7d_s2p99_bas nonagri_hrs7d_s2p99_bas wealthindex_all_bas cashtotal4w_basp99_1000 healthindex_bas APAI_Ravg_bas vilpopulation remoteness"
		gl controls_midline "$D_midline $E_midline $K_midline $F_midline $H_midline $P_midline "  
		gl controls_midline_A9 "$D_midline $E_midline $K_midline $F_midline $H_midline" 
		
		gl controls_table2 "$DH_main $E $K_main $F_main $W_main $V_main"
		gl outcomes_table3 "employ_occ_index_z_p1e igastart_p1e biznow_p1e nonagri_hrs7d_s2p99_p1e incomeindex_p1e total_profit4w_r_s2p99_p1e wealthindex_all_p1e consaggpercap2_z_p1e womens_rights_z_p1e purchase_autonomyv2_z_p1e partrelskillindex2_z_p1e physemo_abuse_z_p1e marital_control_z_p1e"
		gl outcomes_table4 "incomeindex_p1e total_profit4w_r_s2p99_p1e wealthindex_all_p1e consaggpercap2_z_p1e igastart_p1e biznow_p1e chores_hrs7d_p99_p1e"
		gl outcomes_table5 "employ_occ_index_z_p2e igastart_p2e biznow_p2e nonagri_hrs7d_s2p99_p2e incomeindex_p2e total_profit4w_r_s2p99_p2e wealthindex_all_p2e consaggpercap2_z_p2e womens_rights_z_p2e purchase_autonomyv2_z_p2e partrelskillindex2_z_p2e partsupportindex_z_p2e partfamsupport_z_p2e partbizsupport_z_p2e physemo_abuse_z_p2e marital_control_z_p2e"
	
	// 1.3 SET RUN STYLE
		/* Set $exit as "exit" if you want to run 
		graphs 1 at a time. Set to "" if you want 
		to run continuously. */
		gl exit = ""
		
$exit
	
///////////////////////////////////////
// 2.0 TABLES AND FIGURES //
///////////////////////////////////////

	// TABLE 2: Baseline descriptive statistics and test of balance 
		local i = 0
		foreach x of global controls_table2 {
			local ++i
			local var`i' "`x'"
			/* Phase 1 treatment versus control */
			qui sum `x' if assigned_p1 == 0
				local m_p1c`i' = r(mean)
				local s_p1c`i' = r(sd)
			qui sum `x' if assigned_p1 == 1
				local m_p1t`i' = r(mean)
				local s_p1t`i' = r(sd)
			qui reg `x' assigned_p1 district1 if sample_p1==1, cluster(siteid)
				qui testparm assigned_p1
				local pstat_p1`i' = r(p)
			/* Phase 2 treatment versus control */
			qui sum `x' if assigned_p2_Wplus == 0
				local m_p2c`i' = r(mean)
				local s_p2c`i' = r(sd)
			qui sum `x' if assigned_p2_Wplus == 1
				local m_p2t`i' = r(mean)
				local s_p2t`i' = r(sd)
			qui reg `x' assigned_p2_Wplus district1 if sample_p2==1, cluster(siteid)
				qui testparm assigned_p2_Wplus
				local pstat_p2`i' = r(p)
		}
	
		local I = `i'
		preserve
			clear
			set obs `I'
			foreach v in var m_p1c s_p1c m_p1t s_p1t pstat_p1 ///
			m_p2c s_p2c m_p2t s_p2t pstat_p2 {
				qui gen `v' = ""
				forv i = 1/`I' {
					qui replace `v' = "``v'`i''" in `i'
				}
				qui destring `v', replace
			}
			export excel using "ssm tables.xlsx", sheetmodify sheet("t2 raw new") firstrow(var)
		 restore
		 $exit
		 
		 	
	
	// TABLE 3: IMPACT OF FULL PROGRAM

		local i = 0
		foreach x of global outcomes_table3 {
			local ++i
			local var_`i' "`x'"
			/* Control Outcomes */
			qui sum `x' if sample_p1==1 & assigned_p1==0 & found_p1e == 1
			local m_p1ec_`i' = r(mean)
			local sd_p1ec_`i' = r(sd)
			}
			
		/* ITT estimates, All */		
		local i = 0	
			foreach x of global outcomes_table3 {
			local ++i
				reg `x' $controls_main $spillovers assigned_p1 if sample_p1==1 & found_p1e == 1, cluster(siteid)
					local b_all_`i' = _b[assigned_p1]
					local se_all_`i' = _se[assigned_p1]
					local p_all_`i' = 2*ttail(e(df_r),abs(_b[assigned_p1]/_se[assigned_p1]))
					local ci05_all_`i' = _b[assigned_p1] - invttail(e(df_r),0.025)*_se[assigned_p1]
					local ci95_all_`i' = _b[assigned_p1] + invttail(e(df_r),0.025)*_se[assigned_p1]
					
					/* Format Confidence Interval */
						local ci05_all_`i' = round(`ci05_all_`i'', .001)
						local ci95_all_`i' = round(`ci95_all_`i'', .001)
						
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_all_`i''",strpos("`ci`q'_all_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_all_`i' = substr("`ci`q'_all_`i''",1,strpos("`ci`q'_all_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_all_`i' = "`ci`q'_all_`i''0"
							if (strlen("`dec'")==2) local ci`q'_all_`i' = "`ci`q'_all_`i''00"
							if (strlen("`dec'")<2) local ci`q'_all_`i' = "`ci`q'_all_`i'000"
							}
						local ci_all_`i' = "`ci05_all_`i'' - `ci95_all_`i''"
					
					/* Format Standard Errors */
						local se_all_`i' = round(`se_all_`i'',.001)
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
							local dec = ""
							local dec = substr("`se_all_`i''",strpos("`se_all_`i''","."),.)
							if (strlen("`dec'")>4) local se_all_`i' = substr("`se_all_`i''",1,strpos("`se_all_`i''",".")+3)
							if (strlen("`dec'")==3) local se_all_`i' = "`se_all_`i''0"
							if (strlen("`dec'")==2) local se_all_`i' = "`se_all_`i''00"
							if (strlen("`dec'")<2) local se_all_`i' = "`se_all_`i'000"
						/* Put some brackets and asterisks on the standard errors */
							local se_all_`i' = "[`se_all_`i'']"
							if (`p_all_`i''<=.1) local se_all_`i' = "`se_all_`i''*"
							if (`p_all_`i''<=.05) local se_all_`i' = "`se_all_`i''*"
							if (`p_all_`i''<=.01) local se_all_`i' = "`se_all_`i''*"
							dis "`se_all_`i''"
			}
			
		/* ITT estimates, Women only */
		local i = 0	
			foreach x of global outcomes_table3 {
			local ++i
				reg `x' $controls_main $spillovers assigned_p1 if sample_p1==1 & female & found_p1e == 1, cluster(siteid)
					local b_f_`i' = _b[assigned_p1]
					local se_f_`i' = _se[assigned_p1]
					local p_f_`i' = 2*ttail(e(df_r),abs(_b[assigned_p1]/_se[assigned_p1]))
					local ci05_f_`i' = _b[assigned_p1] - invttail(e(df_r),0.025)*_se[assigned_p1]
					local ci95_f_`i' = _b[assigned_p1] + invttail(e(df_r),0.025)*_se[assigned_p1]
					
					/* Format Confidence Interval */
						local ci05_f_`i' = round(`ci05_f_`i'', .001)
						local ci95_f_`i' = round(`ci95_f_`i'', .001)
		
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_f_`i''",strpos("`ci`q'_f_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_f_`i' = substr("`ci`q'_f_`i''",1,strpos("`ci`q'_f_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_f_`i' = "`ci`q'_f_`i''0"
							if (strlen("`dec'")==2) local ci`q'_f_`i' = "`ci`q'_f_`i''00"
							if (strlen("`dec'")<2) local ci`q'_f_`i' = "`ci`q'_f_`i'000"
							}
							
						local ci_f_`i' = "`ci05_f_`i'' - `ci95_f_`i''"
					
					/* Format Standard Errors */
						local se_f_`i' = round(`se_f_`i'',.001)
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
							local dec = ""
							local dec = substr("`se_f_`i''",strpos("`se_f_`i''","."),.)
							if (strlen("`dec'")>4) local se_f_`i' = substr("`se_f_`i''",1,strpos("`se_f_`i''",".")+3)
							if (strlen("`dec'")==3) local se_f_`i' = "`se_f_`i''0"
							if (strlen("`dec'")==2) local se_f_`i' = "`se_f_`i''00"
							if (strlen("`dec'")<2) local se_f_`i' = "`se_f_`i'000"
						/* Put some brackets and asterisks on the standard errors */
							local se_f_`i' = "[`se_f_`i'']"
							if (`p_f_`i''<=.1) local se_f_`i' = "`se_f_`i''*"
							if (`p_f_`i''<=.05) local se_f_`i' = "`se_f_`i''*"
							if (`p_f_`i''<=.01) local se_f_`i' = "`se_f_`i''*"
							dis "`se_f_`i''"
			}
			
		/* Build table */
		local I = `i'
		preserve
			clear
			set obs `I'
			foreach v in var m_p1ec sd_p1ec b_all se_all ci_all b_f se_f ci_f {
				qui gen `v' = ""
				forv i = 1/`I' {
					qui replace `v' = "``v'_`i''" in `i' 
				}
				qui destring `v', replace
			}
			export excel using "ssm tables.xlsx", sheetmodify sheet("t3 raw new") firstrow(var)
		 restore
		 $exit
	
	
	
	// Table 4 - Heterogeneity 
		
		cap qui gen A_IP_control_z_bas = assigned_p1*IP_control_z_bas
		cap qui gen A_treatwellrarelynever_bas = assigned_p1*treatwell_rarelynever_bas
		
		/* Top half: IPV */
		local i = 0	
			foreach y of global outcomes_table4 {
			local ++i
			local var_`i' "`y'"
				reg `y' $controls_main $spillovers assigned_p1 IP_control_z_bas  A_IP_control_z_bas if sample_p1==1 & female==1 & partner_bas==1 & found_p1e == 1, cluster(siteid)
					local b_ipv_z_`i' = _b[assigned_p1]
					local se_ipv_z_`i' = _se[assigned_p1]
					local p_ipv_z_`i' = 2*ttail(e(df_r),abs(_b[assigned_p1]/_se[assigned_p1]))
					
					local b_ipv_x_`i' = _b[IP_control_z_bas]
					local se_ipv_x_`i' = _se[IP_control_z_bas]
					local p_ipv_x_`i' = 2*ttail(e(df_r),abs(_b[IP_control_z_bas]/_se[IP_control_z_bas]))
						
					local b_ipv_zx_`i' = _b[A_IP_control_z_bas]
					local se_ipv_zx_`i' = _se[A_IP_control_z_bas]
					local p_ipv_zx_`i' = 2*ttail(e(df_r),abs(_b[A_IP_control_z_bas]/_se[A_IP_control_z_bas]))
					local ci05_ipv_zx_`i' = _b[A_IP_control_z_bas] - invttail(e(df_r),0.025)*_se[A_IP_control_z_bas]
					local ci95_ipv_zx_`i' = _b[A_IP_control_z_bas] + invttail(e(df_r),0.025)*_se[A_IP_control_z_bas]
					
					/* Format Confidence Interval */
						local ci05_ipv_zx_`i' = round(`ci05_ipv_zx_`i'', .001)
						local ci95_ipv_zx_`i' = round(`ci95_ipv_zx_`i'', .001)
						
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_ipv_zx_`i''",strpos("`ci`q'_ipv_zx_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_ipv_zx_`i' = substr("`ci`q'_ipv_zx_`i''",1,strpos("`ci`q'_ipv_zx_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_ipv_zx_`i' = "`ci`q'_ipv_zx_`i''0"
							if (strlen("`dec'")==2) local ci`q'_ipv_zx_`i' = "`ci`q'_ipv_zx_`i''00"
							if (strlen("`dec'")<2) local ci`q'_ipv_zx_`i' = "`ci`q'_ipv_zx_`i'000"
							}
						local ci_ipv_zx_`i' = "`ci05_ipv_zx_`i'' - `ci95_ipv_zx_`i''"
					
					/* Format Standard Errors */
						foreach q in z x zx {
							local se_ipv_`q'_`i' = round(`se_ipv_`q'_`i'',.001)
							/* Occasionally the round function gives output 
							like 1.2340000000000001. Here, we truncate those outputs */
								local dec = ""
								local dec = substr("`se_ipv_`q'_`i''",strpos("`se_ipv_`q'_`i''","."),.)
								if (strlen("`dec'")>4) local se_ipv_`q'_`i' = substr("`se_ipv_`q'_`i''",1,strpos("`se_ipv_`q'_`i''",".")+3)
								if (strlen("`dec'")==3) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''0"
								if (strlen("`dec'")==2) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''00"
								if (strlen("`dec'")<2) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i'000"
							/* Put some brackets and asterisks on the standard errors */
								local se_ipv_`q'_`i' = "[`se_ipv_`q'_`i'']"
								if (`p_ipv_`q'_`i''<=.1) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''*"
								if (`p_ipv_`q'_`i''<=.05) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''*"
								if (`p_ipv_`q'_`i''<=.01) local se_ipv_`q'_`i' = "`se_ipv_`q'_`i''*"
						}
			}

 
			/* Bottom half: Treat well */
			local i = 0	
			foreach y of global outcomes_table4 {
			local ++i
				reg `y' $controls_main $spillovers assigned_p1 treatwell_rarelynever_bas  A_treatwellrarelynever_bas if sample_p1==1 & female==1 & partner_bas==1 & found_p1e == 1, cluster(siteid)
					local b_well_z_`i' = _b[assigned_p1]
					local se_well_z_`i' = _se[assigned_p1]
					local p_well_z_`i' = 2*ttail(e(df_r),abs(_b[assigned_p1]/_se[assigned_p1]))
					
					local b_well_x_`i' = _b[treatwell_rarelynever_bas]
					local se_well_x_`i' = _se[treatwell_rarelynever_bas]
					local p_well_x_`i' = 2*ttail(e(df_r),abs(_b[treatwell_rarelynever_bas]/_se[treatwell_rarelynever_bas]))
						
					local b_well_zx_`i' = _b[A_treatwellrarelynever_bas]
					local se_well_zx_`i' = _se[A_treatwellrarelynever_bas]
					local p_well_zx_`i' = 2*ttail(e(df_r),abs(_b[A_treatwellrarelynever_bas]/_se[A_treatwellrarelynever_bas]))
					local ci05_well_zx_`i' = _b[A_treatwellrarelynever_bas] - invttail(e(df_r),0.025)*_se[A_treatwellrarelynever_bas]
					local ci95_well_zx_`i' = _b[A_treatwellrarelynever_bas] + invttail(e(df_r),0.025)*_se[A_treatwellrarelynever_bas]
					
					/* Format Confidence Interval */
						local ci05_well_zx_`i' = round(`ci05_well_zx_`i'', .001)
						local ci95_well_zx_`i' = round(`ci95_well_zx_`i'', .001)
						
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_well_zx_`i''",strpos("`ci`q'_well_zx_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_well_zx_`i' = substr("`ci`q'_well_zx_`i''",1,strpos("`ci`q'_well_zx_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_well_zx_`i' = "`ci`q'_well_zx_`i''0"
							if (strlen("`dec'")==2) local ci`q'_well_zx_`i' = "`ci`q'_well_zx_`i''00"
							if (strlen("`dec'")<2) local ci`q'_well_zx_`i' = "`ci`q'_well_zx_`i'000"
							}
						local ci_well_zx_`i' = "`ci05_well_zx_`i'' - `ci95_well_zx_`i''"
					
					/* Format Standard Errors */
						foreach q in z x zx {
							local se_well_`q'_`i' = round(`se_well_`q'_`i'',.001)
							/* Occasionally the round function gives output 
							like 1.2340000000000001. Here, we truncate those outputs */
								local dec = ""
								local dec = substr("`se_well_`q'_`i''",strpos("`se_well_`q'_`i''","."),.)
								if (strlen("`dec'")>4) local se_well_`q'_`i' = substr("`se_well_`q'_`i''",1,strpos("`se_well_`q'_`i''",".")+3)
								if (strlen("`dec'")==3) local se_well_`q'_`i' = "`se_well_`q'_`i''0"
								if (strlen("`dec'")==2) local se_well_`q'_`i' = "`se_well_`q'_`i''00"
								if (strlen("`dec'")<2) local se_well_`q'_`i' = "`se_well_`q'_`i'000"
							/* Put some brackets and asterisks on the standard errors */
								local se_well_`q'_`i' = "[`se_well_`q'_`i'']"
								if (`p_well_`q'_`i''<=.1) local se_well_`q'_`i' = "`se_well_`q'_`i''*"
								if (`p_well_`q'_`i''<=.05) local se_well_`q'_`i' = "`se_well_`q'_`i''*"
								if (`p_well_`q'_`i''<=.01) local se_well_`q'_`i' = "`se_well_`q'_`i''*"
						}
			}

		/* Build table */
		local I = `i'
		preserve
			clear
			set obs `I'
			foreach v in var b_ipv_z se_ipv_z b_ipv_x se_ipv_x b_ipv_zx se_ipv_zx ci_ipv_zx ///
						     b_well_z se_well_z b_well_x se_well_x b_well_zx se_well_zx ci_well_zx {
				qui gen `v' = ""
				forv i = 1/`I' {
					qui replace `v' = "``v'_`i''" in `i' 
				}
				qui destring `v', replace
			}
			export excel using "ssm tables.xlsx", sheetmodify sheet("t4 raw new") firstrow(var)
		 restore
		 $exit

		
	// TABLE 5: IMPACT OF W+ PROGRAM

		local i = 0
		foreach x of global outcomes_table5 {
			local ++i
			local var_`i' "`x'"
			/* Control Outcomes */
			qui sum `x' if sample_p2==1 & assigned_p2_Wplus ==0 & female==1 & found_p2e == 1
			local m_p1ec_`i' = r(mean)
			local sd_p1ec_`i' = r(sd)
			}
			
		/* ITT estimates, All women */		
		local i = 0	
			foreach x of global outcomes_table5 {
			local ++i
				reg `x' $controls_main $controls_midline $spillovers assigned_p2_Wplus if sample_p2==1 & female==1 & found_p2e == 1, cluster(siteid)
					local b_all_`i' = _b[assigned_p2_Wplus]
					local se_all_`i' = _se[assigned_p2_Wplus]
					local p_all_`i' = 2*ttail(e(df_r),abs(_b[assigned_p2_Wplus]/_se[assigned_p2_Wplus]))
					local ci05_all_`i' = _b[assigned_p2_Wplus] - invttail(e(df_r),0.025)*_se[assigned_p2_Wplus]
					local ci95_all_`i' = _b[assigned_p2_Wplus] + invttail(e(df_r),0.025)*_se[assigned_p2_Wplus]
					
					/* Format Confidence Interval */
						local ci05_all_`i' = round(`ci05_all_`i'', .001)
						local ci95_all_`i' = round(`ci95_all_`i'', .001)
						
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_all_`i''",strpos("`ci`q'_all_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_all_`i' = substr("`ci`q'_all_`i''",1,strpos("`ci`q'_all_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_all_`i' = "`ci`q'_all_`i''0"
							if (strlen("`dec'")==2) local ci`q'_all_`i' = "`ci`q'_all_`i''00"
							if (strlen("`dec'")<2) local ci`q'_all_`i' = "`ci`q'_all_`i'000"
							}
						local ci_all_`i' = "`ci05_all_`i'' - `ci95_all_`i''"
					
					/* Format Standard Errors */
						local se_all_`i' = round(`se_all_`i'',.001)
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
							local dec = ""
							local dec = substr("`se_all_`i''",strpos("`se_all_`i''","."),.)
							if (strlen("`dec'")>4) local se_all_`i' = substr("`se_all_`i''",1,strpos("`se_all_`i''",".")+3)
							if (strlen("`dec'")==3) local se_all_`i' = "`se_all_`i''0"
							if (strlen("`dec'")==2) local se_all_`i' = "`se_all_`i''00"
							if (strlen("`dec'")<2) local se_all_`i' = "`se_all_`i'000"
						/* Put some brackets and asterisks on the standard errors */
							local se_all_`i' = "[`se_all_`i'']"
							if (`p_all_`i''<=.1) local se_all_`i' = "`se_all_`i''*"
							if (`p_all_`i''<=.05) local se_all_`i' = "`se_all_`i''*"
							if (`p_all_`i''<=.01) local se_all_`i' = "`se_all_`i''*"
							dis "`se_all_`i''"
			}

		/* ITT estimates, female with partner */
		local i = 0	
			foreach x of global outcomes_table5 {
			local ++i
				reg `x' $controls_main $controls_midline $spillovers assigned_p2_Wplus if sample_p2==1 & female==1 & partner_p1e==1 & found_p2e==1, cluster(siteid)
					local b_fp_`i' = _b[assigned_p2_Wplus]
					local se_fp_`i' = _se[assigned_p2_Wplus]
					local p_fp_`i' = 2*ttail(e(df_r),abs(_b[assigned_p2_Wplus]/_se[assigned_p2_Wplus]))
					local ci05_fp_`i' = _b[assigned_p2_Wplus] - invttail(e(df_r),0.025)*_se[assigned_p2_Wplus]
					local ci95_fp_`i' = _b[assigned_p2_Wplus] + invttail(e(df_r),0.025)*_se[assigned_p2_Wplus]
					
					/* Format Confidence Interval */
						local ci05_fp_`i' = round(`ci05_fp_`i'', .001)
						local ci95_fp_`i' = round(`ci95_fp_`i'', .001)
		
					/* Occasionally the round function gives output 
					like 1.2340000000000001. Here, we truncate those outputs */
						foreach q in 05 95 {
							local dec = ""
							local dec = substr("`ci`q'_fp_`i''",strpos("`ci`q'_fp_`i''","."),.)
							if (strlen("`dec'")>4) local ci`q'_fp_`i' = substr("`ci`q'_fp_`i''",1,strpos("`ci`q'_fp_`i''",".")+3)
							if (strlen("`dec'")==3) local ci`q'_fp_`i' = "`ci`q'_fp_`i''0"
							if (strlen("`dec'")==2) local ci`q'_fp_`i' = "`ci`q'_fp_`i''00"
							if (strlen("`dec'")<2) local ci`q'_fp_`i' = "`ci`q'_fp_`i'000"
							}
							
						local ci_fp_`i' = "`ci05_fp_`i'' - `ci95_fp_`i''"
					
					/* Format Standard Errors */
						local se_fp_`i' = round(`se_fp_`i'',.001)
						/* Occasionally the round function gives output 
						like 1.2340000000000001. Here, we truncate those outputs */
							local dec = ""
							local dec = substr("`se_fp_`i''",strpos("`se_fp_`i''","."),.)
							if (strlen("`dec'")>4) local se_fp_`i' = substr("`se_fp_`i''",1,strpos("`se_fp_`i''",".")+3)
							if (strlen("`dec'")==3) local se_fp_`i' = "`se_fp_`i''0"
							if (strlen("`dec'")==2) local se_fp_`i' = "`se_fp_`i''00"
							if (strlen("`dec'")<2) local se_fp_`i' = "`se_fp_`i'000"
						/* Put some brackets and asterisks on the standard errors */
							local se_fp_`i' = "[`se_fp_`i'']"
							if (`p_fp_`i''<=.1) local se_fp_`i' = "`se_fp_`i''*"
							if (`p_fp_`i''<=.05) local se_fp_`i' = "`se_fp_`i''*"
							if (`p_fp_`i''<=.01) local se_fp_`i' = "`se_fp_`i''*"
			}
			
		/* Build table */
		local I = `i'
		preserve
			clear
			set obs `I'
			foreach v in var m_p1ec sd_p1ec b_all se_all ci_all b_fp se_fp ci_fp {
				qui gen `v' = ""
				forv i = 1/`I' {
					qui replace `v' = "``v'_`i''" in `i' 
				}
				qui destring `v', replace
			}
			export excel using "ssm tables.xlsx", sheetmodify sheet("t5 raw new") firstrow(var)
		 restore
		 $exit
		 
