% ES211 Thermodynamics Project 01
% Group 10 Members:
% Dhvani Shah 19110046
% Shreyshi Singh 19110032
% Hiral Sharma 19110016
% Somesh Pratap Singh 19110206
% Siddhi Pravin Surawar 19110170
% Ayush Agarwal 19110143

% Substance: Heptane    Combo: 3
% User inputs p-v OR s-v 
% The code will return a matrix [p,v,T,u,h,s,x] of that state

n = input("Choose the combination of input: \n 1.Pressure and Volume \n 2.Entropy and Volume\n");

if(n == 1) 
    p = input("Pressure = ");
    v = input("Volume = ");
    [p,v,T,u,h,s,x]=SetProperties_heptane_PV(p,v)
    %P-V Combinations code by Somesh and Hiral and Shreyshi and Dhvani

elseif(n == 2)
    s = input("Entropy = ");
    v = input("Volume = ");
        %S-V Combinations codes by Siddhi and Ayush
    [p,v,T,u,h,s,x]=SetProperties_heptane_SV(s,v)
    
else 
   fprintf("Wrong input");
end 