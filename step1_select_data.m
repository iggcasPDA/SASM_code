clc;clear;close all

% Add after line 3
if ~exist('SASM_proxy_withoutcoral.mat', 'file')
    error('File not found: SASM_proxy_withoutcoral.mat');
end
if ~exist('SASM_inst.mat', 'file')
    error('File not found: SASM_inst.mat');
end

year=1850:2010;

% read in proxy data
load('SASM_proxy_withoutcoral.mat')
data=proxy;

% read in instrumental data
load('SASM_inst.mat')
inst_yr=inst(:,1);
inst=inst(:,2);

% 
n=0;
for i=1:1:size(data,2)
    data_year=year(~isnan(data(:,i)));
    data_var=data(~isnan(data(:,i)),i);
    ind_year=intersect(inst_yr,data_year);
% (1) time cover
    if isempty(ind_year)==0
        RowIdx1 = ismember(inst_yr,ind_year);
        inst_var=inst(RowIdx1);

        RowIdx2 = ismember(data_year,ind_year);
        data_var=data_var(RowIdx2);

        clear RowIdx1 RowIdx2

        [r1,p1]=corr(data_var,inst_var);
        [r2,p2]=corr(detrend(data_var),detrend(inst_var));

% (2) correlation      
        if (p1<0.1) && (p2<0.1)
            n=n+1;
            data_rp(n,1:5)=[i,r1,r2,p1,p2];
        end
    end
    clear r1 r2 p1 p2 data_var inst_var ind_year data_year
end
clear i n year

% save data
index=data_rp(:,1);
data_select=proxy(:,index);
rp_select=data_rp;
save("select_data.mat",'data_select','rp_select')
