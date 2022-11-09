program bolo
implicit none
real :: mtotal,mm, mac, mo, mf, mar,mar1,mfer,mfer1,mmfer=0.062,magua,mmar=0.04401
real :: Lm=33.472,Lagua=2453.5
real :: tf1,deltat=0.01,t=0.0,tf2,tf3
real :: Temp,Temp0=30.0,k=0.001882,tempc,tempc0=100.0,somatorio
real :: Q0=0.0,Q1,Q2,Q3,Qc
real :: cm=1.42,cac=3.89,co=3.04,co1,cf=1.75,car=1.0,cb=2.61,ca=4.19,cfer,cof=3.323
real ::p,p0=1.2928,Beta=0.00367,v




!!!Abertura dos arquivos de saída!!!!!
open(UNIT=20,FILE='Tbolo_x_t.dat',STATUS='unknown',ACTION='WRITE')
open(UNIT=21,FILE='Qbolo_x_t.dat',STATUS='unknown',ACTION='WRITE')
open(UNIT=22,FILE='Tcasca_x_t.dat',STATUS='unknown',ACTION='WRITE')
open(UNIT=23,FILE='Qcasca_x_t.dat',STATUS='unknown',ACTION='WRITE')
open(UNIT=25,FILE='Mar_x_t.dat',STATUS='unknown',ACTION='WRITE')
open(UNIT=26,FILE='Volar_x_t.dat',STATUS='unknown',ACTION='WRITE')
!!!!Abertura arquivo de entrada!!!!
open(UNIT=24,FILE='receita.dat',STATUS='unknown',ACTION='READ')
read(24,*) mm,mac,mo,mf,mar,mfer
!!!!!MASSA TOTAL!!!!!!!!
somatorio=(mm*cm)+(mac*cac)+(mo*co)+(mf*cf)+(mar*car)
magua=(0.16*mm+0.74*mo)
!FASE 1!!!!!!!!!!!!!!!
tf1=mm*Lm/(k*150.0)
do 
	Q1=Q0-k*(30.0-180.0)*deltat
	mar1=mar+23.0*(mfer/Mmfer)*mmar*deltat	
	mfer1=mfer-23.0*mfer*deltat	
	p=p0/(1.0+Beta*(Temp0-0.0))	
	v=mar1/p	
	write(20,*) t,30.0
	write(21,*) t,Q1 
	write(25,*) t,mar	
	write(26,*) t,v
	Q0=Q1	
	t=t+deltat
	mar=mar1
	mfer=mfer1
	if(t>tf1) exit
end do
tf2=tf1
!!!!!!FASE 2!!!!!!!!!

do
	Temp=Temp0-k*(Temp0-180.0)*deltat/somatorio
	Q2=Q1-k*(Temp-180.0)*deltat
	write(20,*) tf2,Temp	
	write(21,*) tf2, Q2	
	p=p0/(1.0+Beta*(Temp-0.0))	
	v=mar1/p
	co1=co+(Temp-30.0)*(cof-co)/(100.0-30.0)	
	somatorio=(mm*cm)+(mac*cac)+(mo*co1)+(mf*cf)+(mar1*car)	
	Temp0=Temp
	Q1=Q2
	!if(tf2<=tf1+100*deltat) then 
	write(25,*) tf2,mar1		
	write(26,*) tf2,v	
	write(*,*)'t=',tf2,' Temp=',Temp, ' soma=',somatorio, ' co1=',co1
	!end if		
	tf2=tf2+deltat
	
	
	!co=co1	
	
	if(Temp>=100.0) exit
end do
tf3=tf2
!!!!!FASE 3!!!!!!!!
do
	Q3=Q2-k*(100-180)*deltat	
	write(20,*) tf3,100
	write(21,*) tf3,Q3
	
	mtotal=mm+mac+mo+mf+mar1+mfer1	
	TempC=TempC0-k*(TempC0-180)*deltat/(0.05*mtotal*cb)
	Qc=Q2-k*(TempC-180)*deltat	
	write(22,*) tf3,TempC
	write(23,*)tf3,Qc
	tf3=tf3+deltat	
	TempC0=TempC
	Q2=Qc
	magua=magua-((Q3-Qc)/Lagua)
	write(22,*) tf3,magua
	write(*,*)'t=',tf3,' Temp=',TempC
	write(25,*) tf3,mar1
	write(26,*) tf3,v	
	if(TempC>=175) exit
end do


close(20)
close(21)
close(22)
close(23)
close(24)

stop
end program bolo
