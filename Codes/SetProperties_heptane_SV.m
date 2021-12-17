function [p,v,T,u,h,s,x] = SetProperties_heptane_SV(s,v)

%access satheptane_Psat data
% varies from 1 to 63
sat_psat_data = xlsread('heptane.xlsx', 'satHeptane_Psat');%read the data from excel file
[rows_psat, cols_psat] = size(sat_psat_data);%define size of the data

%If the state is in saturated region
y=1;
flag=0;
for i=1:rows_psat %run down the coloums of satHeptane_Psat table
    p = sat_psat_data(i,1); %read value of p from table and asign value to p for i^th iteration
    T = sat_psat_data(i,2); %read value of T from table and asign value to T for i^th iteration
    vf = sat_psat_data(i,3); %read value of vf from table and asign value to vf for i^th iteration
    vg = sat_psat_data(i,5); %read value of vg from table and asign value to vg for i^th iteration
    uf = sat_psat_data(i,6); %read value of uf from table and asign value to uf for i^th iteration
    ufg = sat_psat_data(i,7); %read value of ufg from table and asign value to ufg for i^th iteration
    ug = sat_psat_data(i,8); %read value of ug from table and asign value to ug for i^th iteration 
    hf = sat_psat_data(i,9); %read value of hf from table and asign value to hf for i^th iteration
    hfg = sat_psat_data(i,10); %read value of hfg from table and asign value to hfg for i^th iteration
    hg = sat_psat_data(i,11); %read value of hg from table and asign value to hg for i^th iteration
    sf = sat_psat_data(i,12); %read value of sf from table and asign value to sf for i^th iteration
    sfg = sat_psat_data(i,13); %read value of sfg from table and asign value to sfg for i^th iteration
    sg = sat_psat_data(i,14); %read value of sg from table and asign value to sg for i^th iteration
         
    if v<vg && v>vf && s<sg && s>sf %condition checking whether the required state lies in saturated region
        x1 = (v - vf)/(vg - vf); % let x1 be the quality calcutated using specific volume values
        x2 = (s - sf)/(sg - sf); % let x2 be the quality calcutated using specific entropy values
        if i>1
                y=x_diff;    
        end
            
        x_diff = x1 - x2; % let x_diff be the difference in x1 and x2. x_diff should be zero, so that we get an x=x1=x2 
            
        if -10e-10<x_diff<10e-10 % Checking whether we find the exact match of values in the superheated table 
            x_diff=0; 
            x=x1; % x corresponding to the i^th row (i.e. the input s,v values match with the values of the i^th row)
            u = (1 - x)*uf + x*ug; % calculating the specific internal energy for that x
            h = (1 - x)*hf + x*hg; % calculating the specific enthalpy for that x
            flag=1;
            break
        end
             
        if (x_diff*y)<0 % This step gives two rows where x_diff transitions from a negative value to a positive value
            vf = (sat_psat_data(i-1,3)+ sat_psat_data(i,3))/2; % interpolate to find value of vf between the corresponding rows
            vg = (sat_psat_data(i-1,5)+ sat_psat_data(i,5))/2; % interpolate to find value of vg between the corresponding rows
            uf = (sat_psat_data(i-1,6)+ sat_psat_data(i,6))/2; % interpolate to find value of uf between the corresponding rows
            ufg = (sat_psat_data(i-1,7) + sat_psat_data(i,7))/2; % interpolate to find value of ufg between the corresponding rows
            ug = (sat_psat_data(i-1,8)+ sat_psat_data(i,8))/2; % interpolate to find value of ug between the corresponding rows
            hf = (sat_psat_data(i-1,9)+ sat_psat_data(i,9))/2; % interpolate to find value of hf between the corresponding rows
            hfg = (sat_psat_data(i-1,10) + sat_psat_data(i,10))/2; % interpolate to find value of hfg between the corresponding rows
            hg = (sat_psat_data(i-1,11) + sat_psat_data(i,11))/2; % interpolate to find value of hg between the corresponding rows
            sf = (sat_psat_data(i-1,12) + sat_psat_data(i,12))/2; % interpolate to find value of sf between the corresponding rows
            sfg = (sat_psat_data(i-1,13) + sat_psat_data(i,13))/2; % interpolate to find value of sfg between the corresponding rows
            sg = (sat_psat_data(i-1,14) + sat_psat_data(i,14))/2; % interpolate to find value of sg between the corresponding rows
                
            x= (v-vf)/(vg-vf); % calculate the required x using the newly found values 
            u = (1 - x)*uf + x*ug; % calculate specific internal energy using x
            h = (1 - x)*hf + x*hg; % calculate specific enthalpy using x
            
            T = Interpolate(sat_psat_data(i-1,5), sat_psat_data(i,5), sat_psat_data(i-1,2), sat_psat_data(i,2), vg); %interpolate T between the corresponding values of vg 
            p = Interpolate(sat_psat_data(i-1,12), sat_psat_data(i,12), sat_psat_data(i-1,1), sat_psat_data(i,1), sf); %interpolate T between the corresponding values of sf
                
            flag=2;
            break
        end
    end
         
end   

if flag==0
    
%access supheatheptane data
%varies from 1 to 360
sup_Heat_data = xlsread('heptane.xlsx', 'supHeatHeptane'); %read the data from excel file
[rows_supHeat, cols_supHeat] = size(sup_Heat_data); %Define size of data

%If the state is in superheated region
x=1; % Quality is 1 in superheated region
n=0;
for i=1:rows_supHeat %run down the coloums of supHeatHeptane table and check for a direct match of input values of s and v
    if s==sup_Heat_data(i,6) %if input entropy is equal to one of the entropies in the tables
        if v==sup_Heat_data(i,3) %if input volume corresponds to given volumes for that pressure
            p=sup_Heat_data(i,1); %read pressure (p) from table
            T=sup_Heat_data(i,2); %read temperature (T) from table
            u=sup_Heat_data(i,4); %read specefic internal energy (u) from table
            h=sup_Heat_data(i,5); %read specefic enthalpy (h) from table
            n=1;
            break   
        end
    end
end

% If no entry matches the input s,v values in the superheated table 

%check for the values of s and v lying between the table values on various isobars
start=1;
endd=10;

while n==0 && endd<=360 % check through the entries of each isobar (block wise)
    for i= start:endd-1
       if s>sup_Heat_data(i,6) && s<sup_Heat_data(i+1,6) && v>sup_Heat_data(i,3) && v<sup_Heat_data(i+1,3) %condition for checking that we are on our required isobar
          p = sup_Heat_data(i,1); 
          T = Interpolate(sup_Heat_data(i,3), sup_Heat_data(i+1,3), sup_Heat_data(i,2), sup_Heat_data(i+1,2), v); %interpolate T between the corresponding rows
          u = Interpolate(sup_Heat_data(i,3), sup_Heat_data(i+1,3), sup_Heat_data(i,4), sup_Heat_data(i+1,4), v); %interpolate u between the corresponding rows
          h = Interpolate(sup_Heat_data(i,3), sup_Heat_data(i+1,3), sup_Heat_data(i,5), sup_Heat_data(i+1,5), v); %interpolate h between the corresponding rows
          n=1;
          break
       end
    end
    start=endd;
    endd=endd+10; 
end
end

end