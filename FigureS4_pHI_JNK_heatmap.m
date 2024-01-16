clear all
close all
mkdir("figures")
mkdir("figures/svg")
paramsets = textread('paramset_15_1_24.txt');
[param_best,ic] = unique(paramsets,'rows');
data_format
targetparam1=EstimData.model.paramnames(1:47);
tmp_modelparams = JNK_pHi_model('parameters');
stim_time = 0:1:200;
tmp_simtime=[linspace(0,4999,5) 5000+stim_time];
tmp_tidx=tmp_simtime>=5000;
tmp_initialConditions = JNK_pHi_model;
statenames = JNK_pHi_model('states');
tmp_initialConditions1 = tmp_initialConditions;
%% best fitted parameter set

previousparamvals=param_best(1,2:end);
EstimData.model.bestfit = previousparamvals;
% find location of target params in the param vector
targetlocs{1}=find(ismember(EstimData.model.paramnames,targetparam1));

%%%%%%%%%%%%%%%%%

param0 = [1.5 2 2.5 3 3.5 4];
param = [1./flip(param0) 1 param0];
PH = (0.6+0.1*([0: 10]));
param_index_run = [1:31 33:52];

for k=param_index_run
    param_name = tmp_modelparams(k);
    k

    for i =1:length(PH)

        tmp_modelparamvals1 = previousparamvals;
        tmp_modelparamvals1(ismember(tmp_modelparams,'Sorbitol0')) = 1;


        % varying PH level
        tmp_modelparamvals1(ismember(tmp_modelparams,'kf4base')) = previousparamvals(ismember(tmp_modelparams,'kf4base')) * PH(i);


        for j=1:length(param)

            tmp_modelparamvals1(ismember(tmp_modelparams,param_name)) = previousparamvals(ismember(tmp_modelparams,param_name)) * param(j);
            tmp_output_baseline = JNK_pHi_model(tmp_simtime,tmp_initialConditions,tmp_modelparamvals1');

            tmp_modelparamvals1(ismember(tmp_modelparams,'Timeinput1')) = 0;
            tmp_output_higher_pH = JNK_pHi_model(stim_time,tmp_output_baseline.statevalues(6,:),tmp_modelparamvals1');
            %   

            pHi_Sor(i,j) = trapz(stim_time,tmp_output_higher_pH.variablevalues(:,ismember(tmp_output_higher_pH.variables,'pHir')));
            JNK_Sor(i,j) = trapz(stim_time,tmp_output_higher_pH.variablevalues(:,ismember(tmp_output_higher_pH.variables,'JNKr')));
        end
    end

    param_index(:,k) = (JNK_Sor(end,:)-JNK_Sor(1,:))./(pHi_Sor(end,:)-pHi_Sor(1,:));
end

%% heatmap

%finding parameters that switch the dynamics
index1 = find((min(param_index)./max(param_index))<0);
tmp_index = find((min(param_index)./max(param_index))>0);

[a,index2] = sort( abs(-min(param_index(:,index1))+max(param_index(:,index1))).* (1./(min(param_index(:,index1))+max(param_index(:,index1)))) );
[a,index3] = sort(abs(-min(param_index(:,tmp_index))+max(param_index(:,tmp_index))));
final = [param_index(:,tmp_index(index3)), param_index(:,index1(index2))];

final = final./abs(final(7,:));
load colormap_dirty
ax = heatmap(final,'Colormap',cmap,'ColorLimits',[-1.5 1.5],'GridVisible','off');
names =  EstimData.model.paramnames(1:52);
ax.XData =names([tmp_index(index3),index1(index2)]);

saveas(gcf,'figures/Sor_heatmap.png')
saveas(gcf,'figures/Sor_heatmap.svg')



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for TNF
param0 = [2  4 7 10 15 20];
param = [1./flip(param0) 1 param0];
pHi_Sor=[];
JNK_Sor = [];
for k=param_index_run
    param_name = tmp_modelparams(k);
    k

    for i =1:length(PH)

        tmp_modelparamvals1 = previousparamvals;
        tmp_modelparamvals1(ismember(tmp_modelparams,'TNF0')) = 1;


        % varying PH level
        tmp_modelparamvals1(ismember(tmp_modelparams,'kf4base')) = previousparamvals(ismember(tmp_modelparams,'kf4base')) * PH(i);


        for j=1:length(param)

            tmp_modelparamvals1(ismember(tmp_modelparams,param_name)) = previousparamvals(ismember(tmp_modelparams,param_name)) * param(j);
            tmp_output_baseline = JNK_pHi_model(tmp_simtime,tmp_initialConditions,tmp_modelparamvals1');

            tmp_modelparamvals1(ismember(tmp_modelparams,'Timeinput1')) = 0;
            tmp_output_higher_pH = JNK_pHi_model(stim_time,tmp_output_baseline.statevalues(6,:),tmp_modelparamvals1');
            %   

            pHi_TNF(i,j) = trapz(stim_time,tmp_output_higher_pH.variablevalues(:,ismember(tmp_output_higher_pH.variables,'pHir')));
            JNK_TNF(i,j) = trapz(stim_time,tmp_output_higher_pH.variablevalues(:,ismember(tmp_output_higher_pH.variables,'JNKr')));
        end
    end

    param_index_tnf(:,k) = (JNK_TNF(end,:)-JNK_TNF(1,:))./(pHi_TNF(end,:)-pHi_TNF(1,:));
end

%% heatmap
figure;
%finding parameters that switch the dynamics
index1 = find((min(param_index_tnf)./max(param_index_tnf))<0);
tmp_index = find((min(param_index_tnf)./max(param_index_tnf))>0);

%%%%%%%%%%%%%%%%%%%%%%
norm = param_index_tnf(:,index1)./abs(max(param_index_tnf(:,index1)));
%%%%%%%%%%%%%%%%%%%%%
[a,index2] = sort( abs(-min(param_index_tnf(:,index1))+max(param_index_tnf(:,index1))).* (1./(min(norm)+max(norm))) );
[a,index3] = sort(abs(-min(param_index_tnf(:,tmp_index))+max(param_index_tnf(:,tmp_index))));
final = [param_index_tnf(:,tmp_index(index3)), param_index_tnf(:,index1(index2))];

final = final./abs(final(7,:));
load colormap_dirty
ax = heatmap(final,'Colormap',cmap,'ColorLimits',[-1.5 1.5],'GridVisible','off');
names =  EstimData.model.paramnames(1:52);
ax.XData =names([tmp_index(index3),index1(index2)]);

saveas(gcf,'figures/tnf_heatmap.png')
saveas(gcf,'figures/tnf_heatmap.svg')








