clc
clear
close all

inst=readmatrix("SASM_index_1940_2000_fromERA5_pre.csv");
save("SASM_inst_total.mat","inst");

ind1=find(inst(:,1)==1945);
ind2=find(inst(:,1)==2010);
inst=inst(ind1:ind2,:);
save("SASM_inst.mat","inst");