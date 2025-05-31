clc;clear;close all

yr=1850:1:2010;
per=0.25;
len=length(yr);
rownumber=100;
rng(3407)

path=pwd;
mkdir step3
dir1=strcat(path,'\step3\');
delete(strcat(dir1,'*.mat'));
namelist = dir(strcat(path,'\step2\*.mat')); 
clear path
[~, index] = natsort({namelist.name});
namelist = namelist(index);
clear index

for k=1:1:size(namelist,1)
    data_path=strcat(namelist(k).folder,'\',namelist(k).name);
    load(data_path)
    for sets=1:rownumber
        all_var=squeeze(all_tt(:,:,:,sets));
        inst_var=squeeze(inst_tt(:,:,:,sets)); 

        for gp=1:1:size(all_var,3)
            proxy_origin=squeeze(all_var(:,:,gp));
            nan_columns = all(isnan(proxy_origin), 1);
            if isempty(nan_columns)==0
                proxy_origin(:,nan_columns)=[];
            end
            clear nan_columns

            inst=squeeze(inst_var(:,gp));  
            for n=1:1:size(proxy_origin,1)
                num1(n,:)=numel(find(~isnan(proxy_origin(n,:))));
            end
    
            ind_proxy=find(num1==size(proxy_origin,2));
            ind_inst=find(~isnan(inst));
            
            ind_yr2=intersect(ind_proxy,ind_inst);
            st=ind_yr2(1);ed=ind_yr2(end);
            
            x=proxy_origin(st:ed,:); 
            y = inst(st:ed,:);
            zz2_origin=proxy_origin(ind_proxy(1):ind_proxy(end),:); 
            clear st ed ind_yr2 proxy_origin inst n num1 ind_inst 
            
            st=ind_proxy(1);           
            ed=ind_proxy(end);          
            num = length(y);           
            recon_ucl_total=nan(len,size(zz2_origin,2)+1);
            clear ind_proxy
    
            for i1=1:1:size(zz2_origin,2)
                zz2=zz2_origin(:,i1);   
                x2=x(:,i1);             
                c = cvpartition(num,'HoldOut',per); 
                idxTrain = training(c,1); 
                idxTest = ~idxTrain; 
                
                xTrain1 = x2(idxTrain,:);
                yTrain = y(idxTrain); 
                
                xTest1 = x2(idxTest,:); 
                yTest = y(idxTest);
                
                p2 = polyfit(xTrain1,yTrain,1); 
                p2_2 = polyfit(yTrain,xTrain1,1); 
                p2_1 = 1/p2_2(1,1);                    
                p2_1(1,2) = -p2_2(1,2)/p2_2(1,1);
                
                n=5000;
                R1 = p2(1,1) + (p2_1(1,1)-p2(1,1)).*rand(n,1);
                R2 = p2(1,2) + (p2_1(1,2)-p2(1,2)).*rand(n,1);
            
                reconmembers=nan(len,n);
                for i=1:n
                    reconmembers(st:ed,i)=zz2*R1(i)+R2(i);
                end
                rr=nan(n,1);
                Weight=nan(n,1);
                clear i
            
                reconmembers_v=reconmembers(st:ed,:);
                for i=1:length(R1)
                    rr(i,1)=rmse(yTest,reconmembers_v(idxTest,i));
                    Weight(i,1)=round(1/rr(i,1));
                end
                clear i
            
                ind=1;ind(1,2)=Weight(1,1);            
                parameter1(ind(1,1):ind(1,2),1)=R1(1,1);
                parameter2(ind(1,1):ind(1,2),1)=R2(1,1);
                
                for i=1:length(R1)-1
                    ind(i+1,1)=sum(Weight(1:i,1))+i*1;
                    ind(i+1,2)=sum(Weight(1:i+1,1))+i*1;
                    parameter1(ind(i+1,1):ind(i+1,2),1)=R1(i+1,1);
                    parameter2(ind(i+1,1):ind(i+1,2),1)=R2(i+1,1);
                end
                clear i
                m=length(parameter1);
            
                reconmembers_u=nan(len,m);
                for i=1:m
                    reconmembers_u(st:ed,i)=zz2*parameter1(i,1)+parameter2(i,1);
                end
                clear i
            
                recon_ucl_total(:,i1+1)=quantile(reconmembers_u,0.5,2);
                recon_ucl_total(:,1)=yr;
                
                
            end
            clear zz2_origin zz2 x2 c idxTest idxTrain xTest1 xTrain1 yTest yTrain
            clear p2 p2_1 p2_2 n R1 R2 reconmembers reconmembers_u reconmembers_v m
            clear parameter1 parameter2 ind rr Weight num x y st ed i1
   
            oie_result_tt(:,:,gp,sets)=[recon_ucl_total,nan(size(recon_ucl_total,1),(size(all_var,2)+1-size(recon_ucl_total,2)))];            
        end  
        clear data_path gp all_var inst_var recon_ucl_total
        disp(sets)
    end
    save(strcat(dir1,'proxyinst',num2str(k)),'oie_result_tt');
    disp(size(oie_result_tt))
    clear oie_result_tt 
end
clear dir1 namelist yr per k