function [p,v,T,u,h,s,x] = SetProperties_heptane_PV(p,v)
sat_psat_data = xlsread('heptane.xlsx', 'satHeptane_Psat');

%size of data
[rows_psat, cols_psat] = size(sat_psat_data);
c=1;

%If the state is in saturatede region
for i=1:rows_psat
    if p==sat_psat_data(i,1)
         c=0;
         T =  sat_psat_data(i,2);
         vf = sat_psat_data(i,3);
         vg = sat_psat_data(i,5);
         uf = sat_psat_data(i,6);
         ug = sat_psat_data(i,8);
         hf = sat_psat_data(i,9);
         hg = sat_psat_data(i,11);
         sf = sat_psat_data(i,12);
         sg = sat_psat_data(i,14);
         x = (v - vf)/(vg - vf);
        % if x >= 1 || x < 0
         %   fprintf("Error in input");
          %     continue
         %end
         u = (1 - x)*uf + x*ug;
         h = (1 - x)*hf + x*hg;
         s = (1 - x)*sf + x*sg;
        break
    end
end

%Saturated region: requires extrapolation
if c==1
    for i=1:rows_psat-1
        if p>sat_psat_data(i,1)&& p<sat_psat_data(i+1,1)
            T = Interpolate(sat_psat_data(i,1), sat_psat_data(i+1,1), sat_psat_data(i,2), sat_psat_data(i+1,2), p);
            vf = Interpolate(sat_psat_data(i,1), sat_psat_data(i+1,1), sat_psat_data(i,3), sat_psat_data(i+1,3), p);
            vg = Interpolate(sat_psat_data(i,1), sat_psat_data(i+1,1), sat_psat_data(i,5), sat_psat_data(i+1,5), p);
            uf = Interpolate(sat_psat_data(i,1), sat_psat_data(i+1,1), sat_psat_data(i,6), sat_psat_data(i+1,6), p);
            ug = Interpolate(sat_psat_data(i,1), sat_psat_data(i+1,1), sat_psat_data(i,8), sat_psat_data(i+1,8), p);
            hf = Interpolate(sat_psat_data(i,1), sat_psat_data(i+1,1), sat_psat_data(i,9), sat_psat_data(i+1,9), p);
            hg = Interpolate(sat_psat_data(i,1), sat_psat_data(i+1,1), sat_psat_data(i,11), sat_psat_data(i+1,11), p);
            sf = Interpolate(sat_psat_data(i,1), sat_psat_data(i+1,1), sat_psat_data(i,12), sat_psat_data(i+1,12), p);
            sg = Interpolate(sat_psat_data(i,1), sat_psat_data(i+1,1), sat_psat_data(i,14), sat_psat_data(i+1,14), p);
            x = (v - vf)/(vg - vf);
            if x >= 1 || x < 0
                fprintf("Error in input");
                continue
            end
            u = (1 - x)*uf + x*ug;
            h = (1 - x)*hf + x*hg;
            s = (1 - x)*sf + x*sg;
            break
        end
    end
end

%If the state is in superheated region
max_sat_p = sat_psat_data(rows_psat, 1);
if(v > vg)
    %go and read superheated table data
    x=1;
    q=0;
    supheat_data = xlsread('heptane.xlsx', 'supHeatHeptane'); %read the data from excel file
    [rows_supheat, cols_supheat] = size(supheat_data); %define size of the data
    for i=1:rows_supheat %run down the coloums and check that which pressure is equal to input pressure

        if p==supheat_data(i,1) %if input pressure == one of the pressures in the tables
            if v==supheat_data(i,3) %if input volume corresponds to given volumes for that pressure
                T=supheat_data(i,2); %read temperature (T) from table
                u=supheat_data(i,4); %read specefic internal energy (u) from table
                h=supheat_data(i,5); %read specefic enthalpy (h) from table
                s=supheat_data(i,6); %read specefic entropy (s) from table
                q=1;
            end
            if q==0
                if v>supheat_data(i,3) && v<supheat_data(i+1,3) %if input pressure corresponds to one of the pressures given but volume is between two values lying in the table
                     T = Intrapolate(supheat_data(i,3), supheat_data(i+1,3), supheat_data(i,2), supheat_data(i+1,2), v); %interpolate T between the corresponding rows
                     u = Intrapolate(supheat_data(i,3), supheat_data(i+1,3), supheat_data(i,4), supheat_data(i+1,4), v); %interpolate u between the corresponding rows
                     h = Intrapolate(supheat_data(i,3), supheat_data(i+1,3), supheat_data(i,5), supheat_data(i+1,5), v); %interpolate h between the corresponding rows
                     s = Intrapolate(supheat_data(i,3), supheat_data(i+1,3), supheat_data(i,6), supheat_data(i+1,6), v); %interpolate s between the corresponding rows
                end
            end

        end 

        if p>supheat_data(i,1) && p<supheat_data(i+1,1) %if pressure does not corresponds to the values given in the table
            Y=zeros(10, 6); %create a matrix with all entries as zero
            %{to obtain properties at this pressure we need to interpolate all
            %the properties between the pressure tables of the pressure values
            %btween which our input pressure lies %}
            for j=1:10
                for k=1:6
                    Y(j,1)=p;
                    Y(j,2)= Intrapolate(supheat_data(i,1), supheat_data(i+1,1), supheat_data(i,2), supheat_data(i+1,2), p); %interpolate T between the corresponding pressures
                    Y(j,3)= Intrapolate(supheat_data(i,1), supheat_data(i+1,1), supheat_data(i,3), supheat_data(i+1,3), p); %interpolate v between the corresponding pressures
                    Y(j,4)= Intrapolate(supheat_data(i,1), supheat_data(i+1,1), supheat_data(i,4), supheat_data(i+1,4), p); %interpolate u between the corresponding pressures
                    Y(j,5)= Intrapolate(supheat_data(i,1), supheat_data(i+1,1), supheat_data(i,5), supheat_data(i+1,5), p); %interpolate h between the corresponding pressures
                    Y(j,6)= Intrapolate(supheat_data(i,1), supheat_data(i+1,1), supheat_data(i,6), supheat_data(i+1,6), p); %interpolate s between the corresponding pressures
                end 
            end
            if v==Y(j,3) %if input volume corresponds to a value in the new matrix
                T=Y(j,2); %read T from the new matrix
                u=Y(j,4); %read u from the new matrix
                h=Y(j,5); %read h from the new matrix
                s=Y(j,6); %read s from the new matrix
                q=1;
            end
            if q==0            
                if v>Y(j,3) && v<Y(j+1,3) %if input volume does not corresponds to a value in the new matrix, interpolate all the properties
                     T = Intrapolate(Y(j,3), Y(j+1,3), Y(j,2), Y(j+1,2), v); %interpolate T between the corresponding rows of new matrix
                     u = Intrapolate(Y(j,3), Y(j+1,3), Y(j,4), Y(j+1,4), v); %interpolate u between the corresponding rows of new matrix
                     h = Intrapolate(Y(j,3), Y(j+1,3), Y(j,5), Y(j+1,5), v); %interpolate h between the corresponding rows of new matrix
                     s = Intrapolate(Y(j,3), Y(j+1,3), Y(j,6), Y(j+1,6), v); %interpolate s between the corresponding rows of new matrix
                end
            end

        end 
    end
elseif (v<vf)
    fprintf("Data in subcooled region is not available ");
    
end

end
