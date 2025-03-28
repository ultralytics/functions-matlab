% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [] = fcnRCcircuit()
%RC Circuit Model from http://www.referencedesigner.com/rfcal/cal_05_01.php

t=linspace(0,.1,1E4); %(s)
C=3.7E-6; %(Farads)
R=100E3; %(Ohms)
V=5; %(V) steady state
y=(1-exp(-t/(R*C)))*V; %(V) voltage as a function of time
fig; plot(t,y); xyzlabel('T (s)','V')
fcnlinewidth(2)



%solve 
syms t R C V y
y=(1-exp(-t/(R*C)))*V;
solve('(1-exp(-t/(R*C)))*V=Vcross',t)

t=-C*R*log(1 - Vcross/V);