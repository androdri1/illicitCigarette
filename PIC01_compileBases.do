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
********************************************************************************
* PSEUDO-PANEL COMPLETO 
********************************************************************************
if 1==0 {
/*
use "$contrabando\base_completa.dta", clear
gen year=2016

lab var m3p25c "Sitio Encuesta"

tempfile b2016_1
save `b2016_1'

import excel "$contrabando\BContrabandoCalculos.xls", sheet("BaseS") firstrow clear
destring ID0, replace 
format %04.0f ID0 
replace t02="1" if t02=="Si"
replace t02="2" if t02=="No"
replace t04="1" if t04=="Si"
replace t04="2" if t04=="No"
replace t06="1" if t06=="Si"
replace t06="2" if t06=="No"
replace t08="1" if t08=="Si"
replace t08="2" if t08=="No"
replace t09="1" if t09=="Si"
replace t09="2" if t09=="No"
destring t02 t04 t06 t08 t09, replace
la def t 2 "No" 1 "Yes"
la val t02 t
la val t04 t
la val t06 t 
la val t08 t
la val t09 t 

replace t01="1" 	if t01=="American Gold"
replace t01="2"		if t01=="Belmont"
replace t01="3"		if t01=="Boston"
replace t01="136" 	if t01=="Camel"
replace t01="52"  	if t01=="D&J"
replace t01="56"  	if t01=="Djarum"
replace t01="7"		if t01=="Fly"
replace t01="8"		if t01=="Fortuna"
replace t01="71"	if t01=="Gold Seal"
replace t01="70"	if t01=="Golden Deer"
replace t01="9"		if t01=="Green"
replace t01="75"	if t01=="Ibiza"
replace t01="76"	if t01=="Jaisalmer"
replace t01="77"	if t01=="Jet"
replace t01="12"	if t01=="Kool"
replace t01="13"	if t01=="L&M"
replace t01="14"	if t01=="Lucky Strike"
replace t01="15"	if t01=="Marlboro"
replace t01="94"	if t01=="Modern"
replace t01="137"	if t01=="Montreal"
replace t01="16"	if t01=="Mustang"
replace t01="138"	if t01=="Nat Sherman"
replace t01="17"	if t01=="Pall Mall"
replace t01="18"	if t01=="Piel Roja"
replace t01="19"	if t01=="Premier"
replace t01="21"	if t01=="Royal"
replace t01="22"	if t01=="Starlite"
replace t01="23"	if t01=="Tropical"
replace t01="150"	if t01=="Win"
destring t01, replace

keep ID0 t*
merge 1:1 ID0 using `b2016_1' 
drop _merge

tempfile b2016
save `b2016'

use "$contrabando\base_completa17.dta", clear
gen year=2017

append using `b2016' 
rename pcig pcigOR
gen 	pcig=pcigOR if year==2017
replace pcig=pcigOR*(1.0575 + 0.04)+(1400/20) if year==2016 & pcigOR>100

destring t01, replace 
la val t01 marca
la var t01 "Adjusted brand"

recode t01 (125=22)
recode m2p06 (125=22)

*replace t01 = m2p06 if year==2016
replace t01 = . if t01==999

replace fechae= evento if fechae==.
drop m0p02 fecha_e fecha_n evento m0p03 radFuma4 estudio fecha_nac puntoc puntoe
rename fechae m0p02

gen 	ingreso=.
replace ingreso=1 if m3p21=="0-690.000" | m3p22=="0-690.000" | m3p24=="0-690.000" 
replace ingreso=2 if m3p21=="690.001-1.400.000" | m3p22=="690.001-1.400.000" | m3p24=="690.001-1.400.000" 
replace ingreso=3 if m3p21=="1.400.001-2.100.000" | m3p22=="1.400.001-2.100.000" | m3p24=="1.400.001-2.100.000" 
replace ingreso=4 if m3p21=="2.100.001-2.800.000" | m3p22=="2.100.001-2.800.000" | m3p24=="2.100.001-2.800.000" 
replace ingreso=5 if m3p21=="2.800.001-3.400.000" | m3p22=="2.800.001-3.400.000" | m3p24=="2.800.001-3.400.000" 
replace ingreso=6 if m3p21=="3.400.001-4.100.000" | m3p22=="3.400.001-4.100.000" | m3p24=="3.400.001-4.100.000" 
replace ingreso=7 if m3p21=="Mas de 4.100.000" | m3p22=="Mas de 4.100.000" | m3p24=="Mas de 4.100.000" 
replace ingreso=. if m3p21=="99" | m3p22=="No sabe/No responde" | m3p24=="No sabe/No responde" 

la def ingreso 1 "690.000 or less" 2 "690.000 - 1.400.000" 3 "1.400.000 - 2.100.000" 4 "2.100.000 - 2.800.000" 5 "2.800.000 - 3.400.000" 6 "3.400.000 - 4.100.000" 7 "4.100.000 or more"
la val ingreso ingreso

la def m3p19 1 "Working" 2 "Looking for a job" 3 "Retired" 4 "Student" 5 "Housekeeper" 6 "Permanently unable to work" 7 " "
la val m3p19 m3p19 
replace m3p19=. if m3p19==7

drop m3p21 m3p22 m3p24

sort ID0 year

save "$dropbox\Contrabando\Baseline\derived\base_completa16_17.dta", replace 
*save "$dropbox\Contrabando\Baseline\derived\base_completa16_17_2.dta", replace 
*save "$contrabando\base_completa16_17.dta", replace 
*/
}


// *****************************************************************************
use "$dropbox\Contrabando\Baseline\derived\base_completa16_17.dta", clear

la var t02 "Contraband_brand"
la var t04 "Contraband_pack price"
la var t06 "Contraband_stick price"

duplicates tag ID0, g(dup)
drop dup
xtset ID0 year 
gen I_time  = (year==2017) & !mi(year)

*Usando fex_2017
	gen 	fex_a=fex if year==2017
	bys ID0: egen	fex_2017=max(fex_a)
	drop fex_a

svyset ID0 [pw=fex], strata(m3p25a)

drop contrab 
gen 	contrab=.
replace contrab=0 if t09==2 
replace contrab=1 if t09==1 
gen DEICS_col=1

svy: mean contrab , over(year)
recode m1p03 (2=0)
la def sexo 1 "Masculino" 0 "Femenino"
la val m1p03 sexo 


recode t02 (2=0) if t02!=. 
recode t04 (2=0) if t04!=. 
recode t06 (2=0) if t06!=.
recode t08 (2=0) if t08!=.

recode t09 (2=0) if t09!=.

gen 	ilegal_precio=0 if t04!=. | t06!=. | t08!=. 
replace ilegal_precio=1 if t04==1 | t06==1 | t08==1 

// Sin Factores de Expansion
bys year: tab t02 if contrab==1
bys year: tab ilegal_precio if t02!=1, m
bys year: tab contrab if ((m2p08==0 & m2p08a!=1 & m2p08b!=1 & m2p08c!=1 & m2p08d!=1 & m2p08e!=0)| m2p08e==1 ) & t02!=1

svy: tab t02 year if (contrab==1), col
svy: tab ilegal_precio year if (contrab==1), col
svy: tab contrab year if ((m2p08==0 & m2p08a!=1 & m2p08b!=1 & m2p08c!=1 & m2p08d!=1 & m2p08e!=0)| m2p08e==1 ) & t02!=1, col
svy: tab t09 year, col

replace cons_s=ceil(cons_s)

** Factores de expansion como frecuencias (cuidado con enteros) 

foreach i in 2016 2017{
gen smoker_fex_total`i'=1*fex if year==`i'
gen smoker_fex_contrab`i'=1*fex if (contrab==1 & year==`i')
egen total`i'=total(smoker_fex_total`i')
egen total_contrab`i'=total(smoker_fex_contrab`i')
gen penet`i'=total_contrab`i'/total`i'
}
*
gen 	penet=penet2016 if year==2016
replace penet=penet2017 if year==2017

foreach i in 2016 2017{
	gen cons_s_fex_total`i'=cons_s*fex if year==`i'
	gen cons_s_fex_contrab`i'=cons_s*fex if (contrab==1 & year==`i')
	egen total_cig`i'=total(cons_s_fex_total`i')
	egen total_cig_contrab`i'=total(cons_s_fex_contrab`i')
	gen penet_cig`i'=total_cig_contrab`i'/total_cig`i'
}
*
gen 	penet_cig=penet_cig2016 if year==2016
replace penet_cig=penet_cig2017 if year==2017

/*
Packs of 20 cigarettes with a price lower than
COP$1700 in 2016 and COP$2641 in 2017, and sticks with
a price lower than COP$100 in 2016 and COP$132 in 2017
(COP$150 because COP$50 is the smallest denomination in
Colombia’s currency system). >>> 2016:85 y  2017:132.05 */ 

// Si sacamos los precios por debajo de los cortes de contrabando 
gen  	pcigAA = pcigOR 
replace pcigAA = . if pcigOR<132.05 & year==2017
replace pcigAA = . if pcigOR<85 & year==2016

gen 	cotas=0 if pcigOR!=.
replace cotas=1 if (pcigOR<85 & year==2016)
replace cotas=1 if (pcigOR<132.05 & year==2017)
  
save "$dropbox\Contrabando\Baseline\derived\base_completa16_17AB.dta", replace


// *****************************************************************************
** City level datsets: the objective is to classify price-groups according to  
** each city price distribution


	use "$dropbox\Contrabando\Baseline\derived\base_completa16_17AB.dta", clear
	recode m3p25a (11001=1 "Bogotá")(5001=2 "Medellín")(13001=3 "Cartagena")(76001=4 "Cali")(54001=5 "Cucuta"),g(ciudad)
	
	keep if ciudad == 1
	*gen I_time  = (year==2017) & !mi(year)
	glo controls=" c.m1p02x c.m1p02x#c.m1p02x m1p03 i.m3p18"

		centile pcigAA if year==2016, centile(33.33333333) //250 
		centile pcigAA if year==2017, centile(33.33333333) //300
		centile pcigAA if year==2016, centile(66.66666666) //400 
		centile pcigAA if year==2017, centile(66.66666666) //500
	
		gen 	pcigBands_90CIU = 1 if (year==2016 & pcigOR<85) | (year==2017 & pcigOR<132.05)
		replace pcigBands_90CIU = 2 if (year==2016 & pcigOR>=85 & pcigOR<250) | (year==2017 & pcigOR>=132.05 & pcigOR<300)
		replace pcigBands_90CIU = 3 if (year==2016 & pcigOR>=250 & pcigOR<400) | (year==2017 & pcigOR>=300 & pcigOR<500)
		replace pcigBands_90CIU = 4 if (year==2016 & pcigOR>=400) | (year==2017 & pcigOR>=500)

		svyset ID0 [pw=fex]
		svy: tab pcigBands_90CIU year, col

	
	tempfile base_1
	save `base_1'

* ............................
	
	use "$dropbox\Contrabando\Baseline\derived\base_completa16_17AB.dta", clear
	recode m3p25a (11001=1 "Bogotá")(5001=2 "Medellín")(13001=3 "Cartagena")(76001=4 "Cali")(54001=5 "Cucuta"),g(ciudad)
	keep if ciudad == 2
	glo controls=" c.m1p02x c.m1p02x#c.m1p02x m1p03 i.m3p18"

		centile pcigAA if year==2016, centile(33.33333333) //200 
		centile pcigAA if year==2017, centile(33.33333333) //300 -- 301
		centile pcigAA if year==2016, centile(66.66666666) //300 
		centile pcigAA if year==2017, centile(66.66666666) //400
			
		gen 	pcigBands_90CIU = 1 if (year==2016 & pcigOR<85) | (year==2017 & pcigOR<132.05)
		replace pcigBands_90CIU = 2 if (year==2016 & pcigOR>=85 & pcigOR<200) | (year==2017 & pcigOR>=132.05 & pcigOR<300.1)
		replace pcigBands_90CIU = 3 if (year==2016 & pcigOR>=200 & pcigOR<300) | (year==2017 & pcigOR>=300.1 & pcigOR<400.1)
		replace pcigBands_90CIU = 4 if (year==2016 & pcigOR>=300) | (year==2017 & pcigOR>=400.1)

		svyset ID0 [pw=fex]
		svy: tab pcigBands_90CIU year, col
		

	tempfile base_2
	save `base_2'
	
* ............................	
	
	use "$dropbox\Contrabando\Baseline\derived\base_completa16_17AB.dta", clear
	recode m3p25a (11001=1 "Bogotá")(5001=2 "Medellín")(13001=3 "Cartagena")(76001=4 "Cali")(54001=5 "Cucuta"),g(ciudad)
	keep if ciudad == 3
	glo controls=" c.m1p02x c.m1p02x#c.m1p02x m1p03 i.m3p18"

		centile pcigAA if year==2016, centile(33.33333333) //300 
		centile pcigAA if year==2017, centile(33.33333333) //400
		centile pcigAA if year==2016, centile(66.66666666) //400 
		centile pcigAA if year==2017, centile(66.66666666) //500
	
		gen 	pcigBands_90CIU = 1 if (year==2016 & pcigOR<85) | (year==2017 & pcigOR<132.05)
		replace pcigBands_90CIU = 2 if (year==2016 & pcigOR>=85 & pcigOR<300) | (year==2017 & pcigOR>=132.05 & pcigOR<400)
		replace pcigBands_90CIU = 3 if (year==2016 & pcigOR>=300 & pcigOR<400) | (year==2017 & pcigOR>=400 & pcigOR<500)
		replace pcigBands_90CIU = 4 if (year==2016 & pcigOR>=400) | (year==2017 & pcigOR>=500)
		
		svyset ID0 [pw=fex]
		svy: tab pcigBands_90CIU year, col

	tempfile base_3
	save `base_3'
	
* ............................	
	use "$dropbox\Contrabando\Baseline\derived\base_completa16_17AB.dta", clear
	recode m3p25a (11001=1 "Bogotá")(5001=2 "Medellín")(13001=3 "Cartagena")(76001=4 "Cali")(54001=5 "Cucuta"),g(ciudad)
	keep if ciudad == 4
	glo controls=" c.m1p02x c.m1p02x#c.m1p02x m1p03 i.m3p18"


		centile pcigAA if year==2016, centile(33.33333333) //200 -- 201
		centile pcigAA if year==2017, centile(33.33333333) //291.66 -- 285
		centile pcigAA if year==2016, centile(66.66666666) //400 
		centile pcigAA if year==2017, centile(66.66666666) //500
			
		gen 	pcigBands_90CIU = 1 if (year==2016 & pcigOR<85) | (year==2017 & pcigOR<132.05)
		replace pcigBands_90CIU = 2 if (year==2016 & pcigOR>=85 & pcigOR<201) | (year==2017 & pcigOR>=132.05 & pcigOR<285)
		replace pcigBands_90CIU = 3 if (year==2016 & pcigOR>=201 & pcigOR<400) | (year==2017 & pcigOR>=285 & pcigOR<500)
		replace pcigBands_90CIU = 4 if (year==2016 & pcigOR>=400) | (year==2017 & pcigOR>=500)

		svyset ID0 [pw=fex]
		svy: tab pcigBands_90CIU year, col
	
	tempfile base_4
	save `base_4'
	
* ............................	
	
	use "$dropbox\Contrabando\Baseline\derived\base_completa16_17AB.dta", clear
	recode m3p25a (11001=1 "Bogotá")(5001=2 "Medellín")(13001=3 "Cartagena")(76001=4 "Cali")(54001=5 "Cucuta"),g(ciudad)
	keep if ciudad == 5
	glo controls=" c.m1p02x c.m1p02x#c.m1p02x m1p03 i.m3p18"

		centile pcigAA if year==2016, centile(33.33333333) //200 
		centile pcigAA if year==2017, centile(33.33333333) //240 -- 
		centile pcigAA if year==2016, centile(66.66666666) //300 
		centile pcigAA if year==2017, centile(66.66666666) //400
			
		gen 	pcigBands_90CIU = 1 if (year==2016 & pcigOR<85) | (year==2017 & pcigOR<132.05)
		replace pcigBands_90CIU = 2 if (year==2016 & pcigOR>=85 & pcigOR<201) | (year==2017 & pcigOR>=132.05 & pcigOR<241)
		replace pcigBands_90CIU = 3 if (year==2016 & pcigOR>=201 & pcigOR<300.1) | (year==2017 & pcigOR>=241 & pcigOR<400)
		replace pcigBands_90CIU = 4 if (year==2016 & pcigOR>=300.1) | (year==2017 & pcigOR>=400)
		
		svyset ID0 [pw=fex]
		svy: tab pcigBands_90CIU year, col

* ............................
tempfile filo
foreach i in  1 2 3 4 {
	append using `base_`i'' 
	sort ID0
	save `filo', replace 
}

recode pcigBands_90CIU (1/2=1 "1st tertile (+ below cut-off)")(3=2 "2nd tertile")(4=3 "3rd tertile"), g(pcigBands_allCIU)

save "$dropbox\Contrabando\Baseline\derived\base_completa16_17_ciudades.dta", replace 
