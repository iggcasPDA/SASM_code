clc;clear;close all

% set parameters 
rng(3407)
rownumber=100;
rowpercent=0.85;
gp=readmatrix("group_list.csv");
yr=1850:2010;

% read in instrumantal data and proxy data
load('SASM_inst.mat')
load('select_data.mat', 'data_select')
path=pwd;

mkdir 'step1'
dir1=strcat(path,'\step1\');
delete(strcat(dir1,'*.mat'));
clear path

% proxy data time cover
proxy=data_select;
for i=1:size(proxy,2)
     ind=find(~isnan(proxy(:,i)));
     p_sed(i,1)=yr(ind(1));
     p_sed(i,2)=yr(ind(end));
     clear ind
end
clear i

%% norm
indd=[];
for i=1:1:size(gp,1)
    st=find(yr==gp(i,2));
    ed=find(yr==gp(i,3));
    disp(strcat(num2str(gp(i,2)),'to',num2str(gp(i,3))))
    for j=1:1:size(proxy,2)
        data_mean=mean(proxy(st:ed,j),"all","omitnan");
        data_std=std(proxy(st:ed,j),"omitnan");
        for n=1:1:size(proxy,1)
            proxy2(n,j)=(proxy(n,j)-data_mean)/data_std;
        end
        clear n data_mean data_std
    end    
    data_norm(:,:,i)=proxy2;
    clear proxy2 j 
end
proxy=data_norm; clear data_norm
disp("==================done================")
%% divide proxy data
indmax=1999;
res=10;
for i=1:1:floor(indmax/res)
    stackyear(i,1)=(indmax-9)-(i-1)*res;
    indst=find(p_sed(:,1)<=stackyear(i,1));
    inded=find(p_sed(:,2)>=indmax);
    ind=intersect(indst,inded);
    proxy_gp=proxy(:,ind,:);
    if isempty(proxy_gp)==0 && size(proxy_gp,2)>1
        for j=1:1:size(proxy_gp,3)
            indinst=find((inst(:,1)>=gp(j,2)) & (inst(:,1)<=gp(j,3)));
            var=nan(length(yr),1);
            ind1=find(yr==gp(j,2));ind2=find(yr==gp(j,3));
            var(ind1:ind2,:)=inst(indinst,2);
            clear ind1 ind2
            proxy_gp_inst(:,:,j)=cat(2,squeeze(proxy_gp(:,:,j)),var);
            clear var indinst
        end
        num_years = size(proxy_gp_inst, 1);
        num_data_points = size(proxy_gp_inst, 2);
        num_groups = size(proxy_gp_inst, 3);
        num_select_data = round((num_data_points - 1) * rowpercent);
        proxy_result = zeros(num_years, num_select_data + 1, num_groups,rownumber); 
        sets = randi([1, num_data_points - 1], rownumber, num_select_data);  
        for s = 1:rownumber
            selected_columns = sets(s, :); 
            selected_columns = [selected_columns, num_data_points]; 
            proxy_result(:,:,:,s) = proxy_gp_inst(:, selected_columns, :);
        end
        disp(size(proxy_result) )
        save(strcat(dir1,'proxyinst',num2str(i+1)),'proxy_result')
    end
    clear proxy_gp_inst ind indst inded num_years num_data_points num_groups num_select_data proxy_result
end

%% =====================
% add: 2000-2010
i=1;
indst=find(p_sed(:,1)<=2000);
inded=find(p_sed(:,2)>=2010);
ind=intersect(indst,inded);
proxy_gp=proxy(:,ind,:);
if isempty(proxy_gp)==0 && size(proxy_gp,2)>1
    for j=1:1:size(proxy_gp,3)
        indinst=find((inst(:,1)>=gp(j,2)) & (inst(:,1)<=gp(j,3)));
        var=nan(length(yr),1);
        ind1=find(yr==gp(j,2));ind2=find(yr==gp(j,3));
        var(ind1:ind2,:)=inst(indinst,2);
        clear ind1 ind2
        proxy_gp_inst(:,:,j)=cat(2,squeeze(proxy_gp(:,:,j)),var);
        clear var indinst
    end
    num_years = size(proxy_gp_inst, 1);
    num_data_points = size(proxy_gp_inst, 2);
    num_groups = size(proxy_gp_inst, 3);
    num_select_data = round((num_data_points - 1) * rowpercent);
    proxy_result = zeros(num_years, num_select_data + 1, num_groups,rownumber);  
    sets = randi([1, num_data_points - 1], rownumber, num_select_data);  
    for s = 1:rownumber
        selected_columns = sets(s, :); 
        selected_columns = [selected_columns, num_data_points]; 
        proxy_result(:,:,:,s) = proxy_gp_inst(:, selected_columns, :);
    end
    save(strcat(dir1,'proxyinst',num2str(i)),'proxy_result')
end
clear proxy_gp_inst ind indst inded