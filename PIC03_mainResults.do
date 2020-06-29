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
use "$dropbox\Contrabando\Baseline\derived\base_completa16_17_ciudades.dta", clear

tab pcigBands_allCIU, gen(d_pcig)
tab pcigBands_90CIU , gen(d_pcig_90)

gen vendedor=0
replace vendedor=. if m2p09==99
replace m2p09 = . if m2p09==99
replace vendedor=1 if m2p09==3
la def vendedor 0 "Non street vendors" 1 "Street vendors"
la val vendedor vendedor

gen cons_d=cons_s/7 if cons_s!=.

svy: mean vendedor if year==2016 // 51.2% is the share of street vendors in 2016
	
* Diff in Diff (individuos , zonas FE)
svyset ID0 [pw=fex]

label var I_time "Year = 2017"

glo controls=" c.m1p02x c.m1p02x#c.m1p02x m1p03 i.m3p18 i.m3p19"  // Edad, edad al cuadrado, género y nivel educativo

********************************************************************************
* Table A4: Difference in means ************************************************

if 1==1 { // Discussion in the descriptives on the no-significant diff on PIC 2017 vs 2017

	** Contrabando
	svy: mean contrab if I_time==0   // 3.34%
	svy: mean contrab if I_time==1	 // 4.23%

	eststo clear
	eststo: svy: reg contrab I_time
	estadd ysumm

	eststo: svy: reg contrab I_time $controls i.id_zona 
	estadd ysumm	
	eststo: svy: reg cotas I_time $controls i.id_zona 
	estadd ysumm
	eststo: svy: reg intensity_weekly I_time $controls i.id_zona 
	estadd ysumm
	eststo: svy: reg vendedor I_time $controls i.id_zona 
	estadd ysumm
	esttab, se ar2 keep(I_time) label star(* .1 ** .05 *** .01) ///
	stats(N r2 N_clus, label("Observations" "R-squared")) 			

}

********************************************************************************
* Table 4: Difference-in-differences results ***********************************
if 1==1 {
    eststo clear
	*keep  if pcigBands_90>1 // Old version
	
	svy: mean contrab if year==2016 & d_pcig1==1
	mat A=r(table)
	svy: mean contrab if year==2016 & d_pcig2==1
	mat B=r(table)
	
	eststo: svy: reg contrab c.I_time#c.d_pcig1 c.I_time#c.d_pcig2  d_pcig1 d_pcig2 I_time  i.id_zona 
	estadd scalar ymeano1= A[1,1]
	estadd scalar ymeano2= B[1,1]

	eststo: svy: reg contrab c.I_time#c.d_pcig1 c.I_time#c.d_pcig2  d_pcig1 d_pcig2 I_time $controls i.id_zona
	estadd scalar ymeano1= A[1,1]
	estadd scalar ymeano2= B[1,1]
	
	eststo: svy: reg contrab c.I_time#c.d_pcig1  d_pcig1 I_time  i.id_zona 
	estadd scalar ymeano1= A[1,1]
	estadd scalar ymeano2= B[1,1]

	eststo: svy: reg contrab c.I_time#c.d_pcig1  d_pcig1 I_time $controls i.id_zona
	estadd scalar ymeano1= A[1,1]
	estadd scalar ymeano2= B[1,1]


	svy: mean vendedor if year==2016 & d_pcig1==1	
	mat A=r(table)
	svy: mean vendedor if year==2016 & d_pcig2==1
	mat B=r(table)	
	eststo: svy: reg vendedor c.I_time#c.d_pcig1 c.I_time#c.d_pcig2  d_pcig1 I_time $controls i.id_zona  
	estadd scalar ymeano1= A[1,1]
	estadd scalar ymeano2= B[1,1]

	esttab, se  keep( c.I_time#c.d_pcig1 c.I_time#c.d_pcig2 d_pcig1 d_pcig2 I_time ) ///
			 scalars(N r2 ymeano1 ymeano2 ) star(* .1 ** .05 *** .01) 
}
xx

********************************************************************************
* Table A5: PIC-I and PIC-C difference-in-differences results ******************
if 1==0 {

	gen intensity_weekly=contrab*cons_s if cons_s!=. 

	eststo clear

	svy: mean contrab if year==2016 & d_pcig1==1
	mat A=r(table)
	svy: mean contrab if year==2016 & d_pcig2==1
	mat B=r(table)
	
	eststo: svy: reg contrab c.I_time#c.d_pcig1  d_pcig1 I_time $controls i.id_zona
	estadd scalar ymeano1= A[1,1]
	estadd scalar ymeano2= B[1,1]
	
	eststo: svy: reg contrab c.I_time#c.d_pcig1 c.I_time#c.d_pcig2  d_pcig1 d_pcig2 I_time $controls i.id_zona
	estadd scalar ymeano1= A[1,1]
	estadd scalar ymeano2= B[1,1]	
	

	svy: mean intensity_weekly if year==2016 & d_pcig1==1
	mat A=r(table)
	svy: mean intensity_weekly if year==2016 & d_pcig2==1
	mat B=r(table)	
		
	eststo: svy: reg intensity_weekly c.I_time##c.d_pcig1 $controls i.id_zona 
	estadd scalar ymeano1= A[1,1]
	estadd scalar ymeano2= B[1,1]

	eststo: svy: reg intensity_weekly c.I_time##c.d_pcig1 c.I_time##c.d_pcig2 $controls i.id_zona  
	estadd scalar ymeano1= A[1,1]
	estadd scalar ymeano2= B[1,1]

	esttab, se  keep( c.I_time#c.d_pcig1 c.I_time#c.d_pcig2) ///
			 scalars(N r2 ymeano1 ymeano2 ) star(* .1 ** .05 *** .01) 

}
			 
********************************************************************************
** REGRESIONES CON INTERACCIONES
********************************************************************************
* By gender, age, occupation, education level & channel ........................

recode m1p02x (10/35=0 "Teenagers - Young Ad.")(36/100=1 "Adults - Elderly"), g(edad_grupos1)
recode m3p18 (1/2=0 "<Secondary School") (3/6=1 ">High School"), g(nivel_educ)
recode m3p18 (1/4=0 "<Professional") (5/6=1 "Professional"), g(nivel_educ1)
recode m3p19 (1/3=0 "Non student") (4=1 "Student") (5/6=0), g(occup)
recode m3p19 (1=1 "Working") (2/6=0 "Other"), g(occup1)

gen m1p03_w=1-m1p03
gen occup_o=1-occup
gen occup1_o=1-occup1  // Non-working people
gen edad2=1-edad_grupos1 
gen nivel_educ1_c=1-nivel_educ1 //Non-professionals
gen novendedor=1-vendedor //Non-street-vendors

bys nivel_educ1 year: su pcigOR
bys occup1 year: su pcigOR
bys novendedor year: su pcigOR

* Interactions .................................................................
if 1==0{

eststo clear	
svy: reg contrab c.I_time#c.nivel_educ1 c.d_pcig1#c.nivel_educ1 c.I_time#c.d_pcig1#c.nivel_educ1 c.I_time#c.d_pcig1#c.nivel_educ1_c i.id_zona $controls
test c.I_time#c.d_pcig1#c.nivel_educ1=c.I_time#c.d_pcig1#c.nivel_educ1_c
estadd scalar F_val=r(F)
estadd scalar pval=r(p)
eststo reg1

svy: reg contrab c.I_time#c.occup1 c.d_pcig1#c.occup1 c.I_time#c.d_pcig1#c.occup1 c.I_time#c.d_pcig1#c.occup1_o i.id_zona $controls
test c.I_time#c.d_pcig1#c.occup1=c.I_time#c.d_pcig1#c.occup1_o
estadd scalar F_val=r(F)
estadd scalar pval=r(p)
eststo reg2

svy: reg contrab c.I_time#c.vendedor c.d_pcig1#c.vendedor c.I_time#c.d_pcig1#c.vendedor c.I_time#c.d_pcig1#c.novendedor i.id_zona $controls
test c.I_time#c.d_pcig1#c.novendedor=c.I_time#c.d_pcig1#c.vendedor
estadd scalar F_val=r(F)
estadd scalar pval=r(p)
eststo reg3
	
esttab, se ar2 keep( c.I_time#c.d_pcig1#c.nivel_educ1 c.I_time#c.d_pcig1#c.nivel_educ1_c c.I_time#c.d_pcig1#c.occup1 c.I_time#c.d_pcig1#c.occup1_o  c.I_time#c.d_pcig1#c.vendedor c.I_time#c.d_pcig1#c.novendedor) ///
		 scalars(F_val pval) star(* .1 ** .05 *** .01) 
}

********************************************************************************
** BY CITY
********************************************************************************

eststo clear

foreach city in 1 2 3 4 5 {
    preserve
	keep if ciudad==`city'
	svy: mean contrab if year==2016 & d_pcig1==1
	mat A=r(table)
	svy: mean contrab if year==2016 & d_pcig2==1
	mat B=r(table)
    
	eststo: svy: reg contrab c.I_time#c.d_pcig1  d_pcig1 I_time  i.id_zona $controls
	estadd scalar ymeano1= A[1,1]
	estadd scalar ymeano2= B[1,1]	
	restore
}

* Nacional con Cúcuta ..........................................................
svy: mean contrab if year==2016 & d_pcig1==1
mat A=r(table)
svy: mean contrab if year==2016 & d_pcig2==1
mat B=r(table)
eststo: svy: reg contrab c.I_time##c.d_pcig1  ///
			i.ciudad c.I_time##i.ciudad c.d_pcig1##i.ciudad c.I_time##c.d_pcig1##i.ciudad ///
			i.id_zona $controls
	estadd scalar ymeano1= A[1,1]
	estadd scalar ymeano2= B[1,1]	

* Nacional sin Cúcuta ..........................................................
preserve
keep if ciudad!= 5 
svy: mean contrab if year==2016 & d_pcig1==1
mat A=r(table)
svy: mean contrab if year==2016 & d_pcig2==1
mat B=r(table)
eststo: svy: reg contrab c.I_time#c.d_pcig1  d_pcig1 I_time  i.id_zona $controls 
	estadd scalar ymeano1= A[1,1]
	estadd scalar ymeano2= B[1,1]	
restore

/*
     Bogotá |      1,031       30.38       30.38
   Medellín |        798       23.51       53.89
  Cartagena |        587       17.30       71.18
       Cali |        392       11.55       82.73
     Cucuta |        586       17.27      100.00 */

esttab, se  keep( c.I_time#c.d_pcig1 2.ciudad#c.I_time#c.d_pcig1 ///
	3.ciudad#c.I_time#c.d_pcig1 4.ciudad#c.I_time#c.d_pcig1 5.ciudad#c.I_time#c.d_pcig1  ) ///
		 scalars(N r2 ymeano1 ymeano2 ) star(* .1 ** .05 *** .01) 	
