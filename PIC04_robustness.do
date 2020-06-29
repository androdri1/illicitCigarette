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
matrix drop _all
foreach t22 in -0.1 -0.075 -0.05 -0.025 0 0.025 0.05 0.075 0.1 { 
	* ............................
	* Price cuts for tertiles according to the city and year
	glo lev116 250 200   300 201 201
	glo lev117 300 300.1 400 285 241
	glo lev216 400 300   400 400 300.1
	glo lev217 500 400.1 500 500 400

	forval i=1(1)5 {
		use "$dropbox\Contrabando\Baseline\derived\base_completa16_17AB.dta", clear
		recode m3p25a (11001=1 "Bogotá")(5001=2 "Medellín")(13001=3 "Cartagena")(76001=4 "Cali")(54001=5 "Cucuta"),g(ciudad)

		loc lev116 : word `i' of $lev116
		loc lev117 : word `i' of $lev117
		loc lev216 : word `i' of $lev216
		loc lev217 : word `i' of $lev217
		
		loc lev116 = `lev116'*(1+`t22') 
		loc lev117 = `lev117'*(1+`t22') 
			
		keep if ciudad == `i'
		glo controls=" c.m1p02x c.m1p02x#c.m1p02x m1p03 i.m3p18"

		gen 	pcigBands_90CIU = 1 if (year==2016 & pcigOR<85)                          | (year==2017 & pcigOR<132.05)
		replace pcigBands_90CIU = 2 if (year==2016 & pcigOR>=85 & pcigOR<`lev116')       | (year==2017 & pcigOR>=132.05 & pcigOR<`lev117')
		replace pcigBands_90CIU = 3 if (year==2016 & pcigOR>=`lev116' & pcigOR<`lev216') | (year==2017 & pcigOR>=`lev117' & pcigOR<`lev217')
		replace pcigBands_90CIU = 4 if (year==2016 & pcigOR>=`lev216')                   | (year==2017 & pcigOR>=`lev217')

		tempfile base`i'
		save `base`i''
	}

	* ............................
	tempfile filo
	foreach i in  1 2 3 4 {
		append using `base`i'' 
		sort ID0
		save `filo', replace 
	}

	recode pcigBands_90CIU (1/2=1 "1st tertile (+ below cut-off)")(3=2 "2nd tertile")(4=3 "3rd tertile"), g(pcigBands_allCIU)
	tab pcigBands_allCIU, gen(d_pcig)
		
	* Diff in Diff (individuos , zonas FE)
	svyset ID0 [pw=fex]
	label var I_time "Year = 2017"

	glo controls=" c.m1p02x c.m1p02x#c.m1p02x m1p03 i.m3p18 i.m3p19"  // Edad, edad al cuadrado, género y nivel educativo

	* Run the regressions ......................................................
	eststo clear

	eststo: svy: reg contrab c.I_time#c.d_pcig1 c.I_time#c.d_pcig2  d_pcig1 d_pcig2 I_time $controls i.id_zona
	sca b_interc2 = _b[c.I_time#c.d_pcig1]
	sca se_interc2= _se[c.I_time#c.d_pcig1]	

	eststo: svy: reg contrab c.I_time#c.d_pcig1  d_pcig1 I_time $controls i.id_zona
	sca b_interc4 = _b[c.I_time#c.d_pcig1]
	sca se_interc4= _se[c.I_time#c.d_pcig1]	
	mat results=nullmat(results) \ [`t22',b_interc2, se_interc2,b_interc4, se_interc4]
			
	*esttab, se  keep( c.I_time#c.d_pcig1 c.I_time#c.d_pcig2 ) ///
	*		 scalars(N r2 ymeano1 ymeano2 ) star(* .1 ** .05 *** .01) 
	* tab pcigBands_90CIU ciudad

}

clear
svmat results


rename results1 t22 
rename results2 b_interc2
rename results3 se_interc2
rename results4 b_interc4
rename results5 se_interc4

replace t22=100+t22*100
lab var t22 "Lower tertile threshold (% main estimate)" 

gen se_upinter= b_interc4+se_interc4*1.645
gen se_lowinter= b_interc4-se_interc4*1.645
lab var se_upinter "Upper 90% CI"
lab var se_lowinter "Lower 90% CI"
lab var b_interc4 "Tertile 1 PIC relative increase ({&eta}{sub:1})"

tw (rcap se_upinter se_lowinter t22)(scatter b_interc4 t22), ///
	 yline(0, lp(solid) lwidth(thick) ) ///
	 yline(0.0379, lp(dash) lwidth(thick)) ///
	 xline(100 , lwidth(thick)) ///
	 legend() scheme(Plotplainblind) 
	 
 