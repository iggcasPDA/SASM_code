clc;clear;close all
rng(3407)

path=pwd;
rownumber=100;
mkdir step2
dir1=strcat(path,'\step2\');
delete(strcat(dir1,'*.mat'));
namelist = dir(strcat(path,'\step1\*.mat')); 
clear path

[~, index] = natsort({namelist.name});
namelist = namelist(index);

yr=1850:1:2010;

%% PLS & PCA
for num=1:1:size(namelist,1)
    data_path=strcat(namelist(num).folder,'\',namelist(num).name);
    load(data_path)
    for sets=1:rownumber
        proxy_sets=squeeze(proxy_result(:,:,:,sets));
        for gp=1:1:size(proxy_sets,3)
        
            proxy=squeeze(proxy_sets(:,1:end-1,gp));
            proxy1=squeeze(proxy_sets(:,:,gp));
            inst=squeeze(proxy_sets(:,end,gp));
        
            i=proxy1;    i(~isnan(i))=1;    i(isnan(i))=0;    i=sum(i,2);
            ind_inst=i==size(proxy1,2);
            clear i
        
            i=proxy;    i(~isnan(i))=1;    i(isnan(i))=0;    i=sum(i,2);
            ind_proxy=i==size(proxy,2);
            clear i
        
            X=proxy1(ind_inst,1:size(proxy,2));
            y=inst(ind_inst,:);
            X1=proxy1(ind_proxy,1:size(proxy,2));
            clear ind_inst inst
        
            n2=size(proxy,2);     
            if n2 >= 3 ;ncomp=3;
            else;       ncomp=n2;            end
            clear proxy proxy1
        
        %% PLC & PCR
            for npc=1:ncomp
                % PLS
                [~,~,~,~,betaPLS] = plsregress(X,y,npc);
                yfitPLS1 = [ones(size(X1,1),1) X1]*betaPLS; 
                % PCR
                [PCALoadings,PCAScores,~] = pca(X,'Economy',false);
                betaPCR = regress(y-mean(y), PCAScores(:,1:npc));
                betaPCR = PCALoadings(:,1:npc)*betaPCR;
                betaPCR = [mean(y) - mean(X)*betaPCR; betaPCR];
                yfitPCR1 = [ones(size(X1,1),1) X1]*betaPCR;
                
                yfitPLS2(:,npc)=yfitPLS1;
                yfitPCR2(:,npc)=yfitPCR1;
    
                clear betaPCR yfitPLS1 yfitPCR1 PCALoadings PCAScores betaPLS
            end
            clear n2 npc ncomp X X1 y
        %% output ==========================================
    
            proxy_PLS1=zeros(length(yr),size(yfitPLS2,2))*nan;
            proxy_PCR1=zeros(length(yr),size(yfitPCR2,2))*nan;
    
            proxy_PLS1(ind_proxy,:)=yfitPLS2;
            proxy_PCR1(ind_proxy,:)=yfitPCR2;
    
            proxy_PLS_var(:,:,gp)=proxy_PLS1;
            proxy_PCR_var(:,:,gp)=proxy_PCR1;
    
            clear proxy_PLS1 proxy_PCR1
             
            all_var=cat(2,proxy_PLS_var,proxy_PCR_var);
    
            inst_var=squeeze(proxy_sets(:,end,:));
           
        end
        proxy_PLS_tt(:,:,:,sets)=proxy_PLS_var;
        proxy_PCR_tt(:,:,:,sets)=proxy_PCR_var;
        all_tt(:,:,:,sets)=all_var;
        inst_tt(:,:,:,sets)=inst_var;
        clear  yfitPCR2 yfitPLS2 inst proxy_sets proxy_PLS_var proxy_PCR_var all_var inst_var
    end
    save(strcat(dir1,'proxyinst',num2str(num)),'proxy_PLS_tt','proxy_PCR_tt','all_tt','inst_tt'); 
    

    disp(strcat('proxy_PLS: ',num2str(size(proxy_PLS_tt))))
    disp(strcat('proxy_PCR: ',num2str(size(proxy_PCR_tt))))
    disp(strcat('all: ',num2str(size(all_tt))))
    disp(strcat('inst: ',num2str(size(inst_tt))))
    clear all_tt ind_proxy proxy_PLS_tt proxy_PCR_tt
end
clear namelist num index dir1 data_path yr