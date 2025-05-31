clc
clear
close all

load('SASM_inst_total.mat')
delete("valid\*.csv")
delete("output\*.csv")
insttotal=inst;

namelist = dir('step3\*.mat');
[~, index] = natsort({namelist.name});
namelist = namelist(index);
clear index

indmax=1999;
res=10;
rownumber=100;
for i=1:1:floor(indmax/res)
    stackyear(i,1)=(indmax-9)-(i-1)*res;
end
stackyear(:,2)=stackyear(:,1)+res;
stackyear=stackyear(1:numel(namelist)-1,:);
stackyear=[[2000,2010];stackyear]; % new group
clear i indmax res

year=1850:2010;
data_op=nan(2010,15,rownumber);
for i=size(namelist,1):-1:1
    data_path=strcat(namelist(i).folder,'\',namelist(i).name);
    load(data_path)
    oie_result=oie_result_tt;
    data=squeeze(median(oie_result(:,2:end,:,:),2,"omitnan"));
    st=stackyear(i,1);st=find(year==st);
    ed=stackyear(i,2);ed=find(year==ed);
    data_op(stackyear(i,1):stackyear(i,2),:,:)=data(st:ed,:,:);
    clear oie_result data
    clear st ed
end
clear i namelist data_path res stackyear
results=median(data_op,3,"omitmissing");
figure; plot(results,'DisplayName','data2')
save("oie_result_tt.mat",'data_op')
save("oie_result.mat",'results')

st=find((1:2010)==1850);
results=[(1850:2010)',results(st:end,:),median(results(st:end,:),2)];
name="SASMI_oie_recon_1850_2010_20250123.csv";
writematrix(results,name)

clc
figure
load('oie_result_tt.mat')
load('SASM_inst_total.mat')
data = data_op(1850:2010,:);
percentiles_5 = prctile(data, 5, 2);  % 5th percentile
percentiles_95 = prctile(data, 95, 2);  % 95th percentile
median_values = median(data, 2);  % Median
years = (1850:2010)';  
h=fill([years;flipud(years)], [percentiles_95;flipud(percentiles_5)], 'b'); hold on
set(h,'edgealpha',0,'facealpha',0.1) 
plot(years, median_values, 'LineWidth', 1, 'Color', 'r', 'DisplayName', 'SASM new'); hold on
p=polyfit(years,median_values,1);
yfit=polyval(p,years);
plot(years,yfit,'-','Color',[218,165,32]/255,'LineWidth',2,'LineStyle',':') ;hold on
plot(years,median_values,'Color',[135,206,235]/255,'LineWidth',1);
plot(inst(:,1),inst(:,2),'Color','g','LineWidth',1,'LineStyle','-');hold on
grid on
title('Median SASM Index reconstruction')
ylabel('SASM Index')
xlim([1850,2010])
set(gca,'linewidth',1) 