********************************************************************************
		***************  ANALISIS COMPARATIVO ENTRE AÑOS  ***************
********************************************************************************

if "`c(username)'"=="paul.rodriguez" {
	glo dropbox="D:\Paul.Rodriguez\Drive\tabacoDrive"
}
if "`c(username)'"=="andro" {
	glo dropbox="C:\Users\\`c(username)'\Dropbox\tabaco\tabacoDrive" // Casa Paul
}
else {
	glo dropbox="C:\Users\\`c(username)'\Dropbox\tabacoDrive" // Susana
}

glo contrabando "$dropbox\Contrabando\Baseline\data"


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*  TABLES .....................................................................
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
use "$dropbox\Contrabando\Baseline\derived\base_completa16_17_ciudades.dta", clear

********************************************************************************
* Table 1: Descriptive statistics
if 1==1 {

	svyset ID0 [pw=fex]
	la var m1p02x 	"Age"
	recode m1p03 (1=1 "Male")(2=0 "Female"), g(m1p03_aa)
	la var m1p03_aa	"Gender (Male==1)"
	la var cons_s	"Weekly consumption"
	recode m2p09 (1/2=1 "Neighbourhood/cigar shop")(3=2 "Street vendors")(4=3 "Service station")(5=4 "Hypermarket and superstores")(6=5 "Bars and restaurants")(8=6 "Free tax zones")(10=7 "High volume sales area")(11=8 "Direct purchase")(99=.), g(m2p09_aa)
	la var m2p09_aa	"Purchasing place" 
	la var m3p25a 	"City"
	la var m3p18 	"Educational Level"
	la var m3p19 	"Occupational Status"

	la def m3p18aa 1 "Primary school or less" 2 "Secondary school" 3 "High school" 4 "Vocational educ." 5 "Undergarudate studies" 6 "Graduate studies" 
	la val m3p18 m3p18aa 
	tab m2p09_aa, g(Purchase_)
	tab m3p25a, g(City_)
	tab m3p18, g(Educat_)
	tab m3p19, g(Occup_)
	tab year, g(wave_)

	glo matchvar "m1p03_aa m1p02x cons_s Purchase_1 Purchase_2 Purchase_3 Purchase_4 Purchase_5 Purchase_6 Purchase_7 Purchase_8 City_1 City_2 City_3 City_4 City_5 Educat_1 Educat_2 Educat_3 Educat_4 Educat_5 Educat_6 Occup_1 Occup_2 Occup_3 Occup_4 Occup_5 Occup_6"

	cd "$dropbox\Contrabando\Baseline\derived\tables"
	cap texdoc close
		texdoc init Sample_balance_waves , replace force
		tex \begin{table}[H]
		tex \centering
		tex \scriptsize		
		tex \caption{Waves Sample Balance \label{tab:waves_sample_balance}}
		tex \begin{tabular}{lccccc}			
		tex \toprule
		tex 		 & \multicolumn{2}{c}{ 2016 } & \multicolumn{2}{c}{ 2017 } & Diff.  \\
		tex Variable &  Obs. & Mean &  Obs. & Mean & \emph{p-value} 	 \\
		tex \midrule
	foreach varDep in $matchvar {
		qui{
		local labelo : variable label `varDep'		
		
			sum `varDep'
			loc fmto = "%7.3f"
			if r(max)>1 loc fmto = "%7.2f"
		
			svy: mean `varDep' if (I_time==0)
			mat A=r(table)
			loc v1 : di `fmto' A[1,1]
			svy: mean `varDep' if (I_time==1)
			mat A=r(table)
			loc v0 : di `fmto' A[1,1]	
			disp "2016: `v1' , 2017: `v0'"
	
				
			svy: reg `varDep' I_time 
			loc dif : di `fmto' _b[I_time]
			loc difse : di `fmto' _se[I_time]			
			loc tbef = _b[I_time]/_se[I_time]
			loc pbef : di `fmto' 2*ttail(e(df_r),abs(`tbef'))	
			
			
			count if e(sample)==1 
			loc nreg=`r(N)'			
			count if wave_1==1 & `varDep'!=0
			loc n1=`r(N)'
			count if wave_1==0 & `varDep'!=0
			loc n0=`r(N)'
			
			local staru = ""
			if ((`pbef' < 0.1) )  local staru = "*" 
			if ((`pbef' < 0.05) ) local staru = "**" 
			if ((`pbef' < 0.01) ) local staru = "***" 
		}
			
		tex \parbox[l]{5cm}{`labelo'} & `n1' &  `v1' & `n0' & `v0' & `dif' (`pbef') \\
	}	
	tex \bottomrule
	tex \end{tabular}
	tex \end{table}
	texdoc close	
}

********************************************************************************
* Table 2: Characteristics of smokers and cigarettes according to price tertile in 2016
if 1==1 {
	cap recode m2p09 (1/2=1 "Convenience st") (3=2 "Street vendors") (4=3 "Service station")(5=4 "Hypermarket ")(6=5 "Bars and restaurants")(8=6 "Free tax zones")(10=7 "High volume sales area")(11=8 "Direct purchase")(99=.), g(m2p09_aa)
	tab m2p09_aa, gen(place_)

	* Place of purchase ............................................................
	loc t_pl1 = "Convenience st"
	loc t_pl2 = "Street vendors"
	loc t_pl4 = "Hypermarket"
	loc t_pl5 = "Bars and restaurants"
	foreach pl in 1 2 4 5 {
		loc row="  & `t_pl`pl'' "
		forval d=1(1)3 {
			qui svy: mean place_`pl' if pcigBands_allCIU==`d'  & year==2016
			mat A=r(table)
			loc row= " `row' & `: disp %5.2f A[1,1]*100 ' & [`: disp %5.2f A[5,1]*100'   `: disp %5.2f A[6,1]*100'] &  "
		}	
		disp " `row' \\"
	}

	* Brand ........................................................................
	tab t01 , gen(brand_)

	loc t_pl10= "Mustang"
	loc t_pl3 = "Boston"
	loc t_pl9 = "Marlboro"
	loc t_pl2 = "Belmont"
	loc t_pl5 = "Green"
	loc t_pl8 = "Lucky Strike"
	loc t_pl6 = "Kool"
	foreach pl in 10 9 3 8 2 5 6 {
		loc row="  & `t_pl`pl'' "
		forval d=1(1)3 {
			qui svy: mean brand_`pl' if pcigBands_allCIU==`d'  & year==2016
			mat A=r(table)
			loc row= " `row' & `: disp %5.2f A[1,1]*100 ' & [`: disp %5.2f A[5,1]*100'   `: disp %5.2f A[6,1]*100'] &  "
		}	
		disp " `row' \\"
	}

	* Other characteristics discrete ...............................................
	cap tab m3p18, g(Educat_)
	egen college = rowtotal(Educat_4 Educat_5 Educat_6) 
	cap tab m3p19, g(Occup_)

	loc t_college "College or above"
	loc t_Occup_1 "Workers"
	foreach varo in college Occup_1   {
		loc row="  & `t_`varo'' "
		forval d=1(1)3 {
			qui svy: mean `varo' if pcigBands_allCIU==`d'  & year==2016
			mat A=r(table)
			loc row= " `row' & `: disp %5.2f A[1,1]*100 ' & [`: disp %5.2f A[5,1]*100'   `: disp %5.2f A[6,1]*100'] &  "
		}	
		disp " `row' \\"
	}

	* Other characteristics continuous ............................................

	loc t_cons_s  "Consumption intensity"
	foreach varo in cons_s  {
		loc row="  & `t_`varo'' "
		forval d=1(1)3 {
			qui svy: mean `varo' if pcigBands_allCIU==`d'  & year==2016
			mat A=r(table)
			loc row= " `row' & `: disp %5.2f A[1,1] ' & [`: disp %5.2f A[5,1]'   `: disp %5.2f A[6,1]'] &  "
		}	
		disp " `row' \\"
	}

}

********************************************************************************
* Table 3: Transition matrix for the tertiles of the price distribution 2016–2017
if 1==1 {
preserve
	tab pcigBands_allCIU, gen(d_pcigCIU)
	collapse (mean) d_pcigCIU* , by(id_zona year)
	gen 	clasifCIU=1 if (d_pcigCIU1>=d_pcigCIU2 & d_pcigCIU1>=d_pcigCIU3)
	replace clasifCIU=2 if (d_pcigCIU2>d_pcigCIU1 & d_pcigCIU2>=d_pcigCIU3)
	replace clasifCIU=3 if (d_pcigCIU3>d_pcigCIU1 & d_pcigCIU3>d_pcigCIU2)

	xtset id_zona year

	forvalues k = 1/3{
		forvalues i =1/3{
			gen pcigdummyCIU`k'_`i'= 1 if (l.clasifCIU==`k' & clasifCIU==`i')
			replace pcigdummyCIU`k'_`i'=0 if pcigdummyCIU`k'_`i'==.
		}
	}
	gen lclasifCIU=l.clasifCIU
	tab lclasifCIU, gen(pcigdumCIU_2016)

	collapse (sum) pcigdummyCIU* pcigdumCIU_*

	forvalues k = 1/3{
		forvalues i = 1/3{
			cap gen mean`k'_`i'= pcigdummyCIU`k'_`i'/pcigdumCIU_2016`k'
		}
	}
	keep mean*
	list
restore
}
********************************************************************************
* Table 6: Penetration of illicit cigarettes by city (smokers)
	
svy: mean contrab if ciudad==1 & year==2016	// Bogotá
svy: mean contrab if ciudad==2 & year==2016	// Medellín
svy: mean contrab if ciudad==3 & year==2016	// Cartagena
svy: mean contrab if ciudad==4 & year==2016	// Cali
svy: mean contrab if ciudad==5 & year==2016	// Cúcuta
	
svy: mean contrab if ciudad==1 & year==2017	// Bogotá
svy: mean contrab if ciudad==2 & year==2017	// Medellín
svy: mean contrab if ciudad==3 & year==2017	// Cartagena
svy: mean contrab if ciudad==4 & year==2017	// Cali
svy: mean contrab if ciudad==5 & year==2017	// Cúcuta	
	
* ******************************************************************************	
* Table A2: Comparison of smokers’ characteristics in DEICS-Col and PSCS-2013


* ******************************************************************************
* Table A3: Comparison of smokers’ characteristics in DEICS-Col and ECV2016	
* Check PIC02_descriptivesECV.do

*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*  FIGURES .....................................................................
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
use "$dropbox\Contrabando\Baseline\derived\base_completa16_17_ciudades.dta", clear

svy: mean contrab , over(year) // 2016:3.34% y 2017:4.23%

svy: tab m2p11 year, col 	// Porcentaje de individuos que fuman suelto, cajetilla y cartón

svy: tab t02 year if (contrab==1), col
svy: tab ilegal_precio year if (contrab==1), col
svy: tab contrab year if ((m2p08==0 & m2p08a!=1 & m2p08b!=1 & m2p08c!=1 & m2p08d!=1 & m2p08e!=0)| m2p08e==1 ) & t02!=1, col
svy: tab t09 year, col

svy: tab cotas if year==2016 // 0.0099
svy: tab cotas if year==2017 // 0.0147


// *****************************************************************************
// Figure 1: Figure 1: Tax reform and cigarette price in some countries in the region
* Check PIC02_descriptivesPrices.do

// *****************************************************************************
// Figure 2: Geographic zones by city – Bogotá
* Map done in QGis with OSM layers and GPS info

// *****************************************************************************
// Figure 3: Cigarettes Price Density 
gen 	pcigGRA=pcigOR if year==2017
replace pcigGRA=pcigOR*1.0575 if year==2016
replace pcigGRA=770 if pcigGRA>=800 & pcig!=.

la var pcigGRA "Price per stick"
tw 	(hist pcigGRA if (year==2016 & pcigGRA<800), width(50) start(0) fcolor(gold)) ///
	(hist pcigGRA if (year==2017 & pcigGRA<800), width(50) start(0) fcolor(none) lcolor(black) lwidth(thick) lpattern(solid)) , ///
		xline(90, lpattern(solid) lwidth(thick)) /// // $85*(1.0575) To US: 90*(0.34/105.75)
		xline(132, lpattern(dash) lwidth(thick)) /// To US:  132.05*(0.34/105.75)
		legend(order(1 "2016" 2 "2017")) ///
		xlabel(0 100 200 300 400 500 600 700 800 "800+" )  scheme(Plotplainblind) 

// *****************************************************************************
// Figure 4: Tertiles of price distribution and penetration of illicit cigarettes

gen contrab100 = contrab*100

* Esto es para el texto del "tab" que va en la gráfica
tab pcigBands_allCIU year, col matcell(A)
loc row1="\tiny{\textbf{2016:}}"
loc row2="\tiny{\textbf{2017:}}"
forval j=1(1)2 {
	forval i=1(1)3 {
		loc p`j'`i' : disp %4.1f A[`i',`j']*100/(A[1,`j']+A[2,`j']+A[3,`j'])
	}
}	

preserve
collapse (mean) contrab100 (semean) SE=contrab100 [aweight = fex], by(pcigBands_allCIU year)
gen low=contrab100-1.96*SE
gen hig=contrab100+1.96*SE
*reshape long contrab100 low hig , i(year) j(pcigBands_allCIU) 
replace contrab100=round(contrab100,.01)
gen     x=pcigBands_allCIU*3
replace x=x+1 if year==2017

tw 	(bar contrab100 x if year==2016, barw(1)  ) ///
	(rcap low hig x   if year==2016) ///
	(bar contrab100 x if year==2017, barw(1)  ) ///
	(rcap low hig x   if year==2017) ///
	(scatter contrab100 x , msym(none) mlab(contrab100) mlabpos(12) mlabcolor(black) ) ///	
	, xlabel( 4 `""Lowest price tertile" "2016: `p11'%" "2017: `p21'%""' ///
			  7 `""Medium price tertile" "2016: `p12'%" "2017: `p22'%""' ///
			  10 `""Highest price tertile" "2016: `p13'%" "2017: `p23'%""' ) ///
	 ytitle("Penetration of Illicit Cigarettes (PIC)")   ///
	 ylabel(0 2 4 6 8 10 12) scheme(Plotplainblind) xtitle("") legend(order(1 "2016" 3 "2017"))
		
*graph export "$dropbox\Contrabando\presentacion\bar_contrabprices_C.png", as(png) replace
restore

// *****************************************************************************
// Figure 5: Robustness checks *************************************************
* See PIC05_robustness.do

// *****************************************************************************
// Figure 6: Principal reason for your choice **********************************
la def m2p15 1 "Less damage" 2 "Price" 3 "Taste"
la val m2p15 m2p15
la var m2p15 "Principal reason for your choice"

svy: tab m2p15 if year==2017
tab m2p15, gen(reason_)
preserve
collapse(mean) ca1=reason_1 ca2=reason_2 ca3=reason_3 ///
		(semean) caSE1=reason_1 caSE2=reason_2 caSE3=reason_3 ///
		(count) n=reason_3  [aweight = fex], by(contrab) 
	reshape long ca caSE , i(contrab) j(cat) 
	
	replace ca  =ca*100
	replace caSE=caSE*100
	format %2.1f ca
	
	* Intervalos de confianza
	gen caUL = ca + invttail(n-1,0.025)*caSE
	gen caLL = ca - invttail(n-1,0.025)*caSE

	* Este es el paso 2 de la trampa, el desfase tiene como objetivo: 1) crear un espacio entre categorías, 2) dejar urbano/rural lado a lado para comparar
	gen     catAd=cat*20 if contrab==1
	replace catAd=cat*20+5 if contrab==0
	
	local opt_mlabel="msize(zero) mcolor(orange) mlabcolor(black) mlabposition(12) mlabangle(horizontal) mlabgap(small) mlabs(vsmall)" 
	tw 	(bar ca catAd if contrab==1, barw(5)  ) ///
		(bar ca catAd if contrab==0, barw(5)  )  ///	
		(rcap caLL caUL catAd, lcolor(blue)) ///
		(scatter ca catAd if contrab==1, mlabel(ca) `opt_mlabel') ///
		(scatter ca catAd if contrab==0, mlabel(ca) `opt_mlabel') , /// 
		legend(row(1) order(1 "Illicit" 2 "Licit") pos(6) ) ///
		xtitle("Reason") ytitle(" ") title("Principal reason for your choice") ///
		ymtick(0(10)1) xlabel(22.5 "Less damage"  42.5 "Price"  62.5 "Taste") ///
		scheme(Plotplainblind) name(Reasons, replace)
restore
// *****************************************************************************
