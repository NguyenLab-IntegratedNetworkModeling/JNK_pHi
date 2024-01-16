clear all
close all
mkdir("figures")
mkdir("figures/svg")
paramsets = textread('paramset_15_1_24.txt');
[param_best,ic] = unique(paramsets,'rows');
data_format
targetparam1=EstimData.model.paramnames(1:52);
tmp_modelparams = JNK_pHi_model('parameters');
stim_time = 0:2:200;
tmp_simtime=[linspace(0,4999,500) 5000+stim_time];
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


param = [0.1:0.05:20];
param_name = 'kf3a';
PH = (0.6+0.01*([1:100]));

tmp_output_baseline = JNK_pHi_model(tmp_simtime,tmp_initialConditions,previousparamvals');


tmp_modelparamvals1 = previousparamvals;
tmp_modelparamvals1(ismember(tmp_modelparams,'TNF0')) = 1;
% 
for j=1:length(param)
    tmp_modelparamvals1(ismember(tmp_modelparams,param_name)) = previousparamvals(ismember(tmp_modelparams,param_name)) * param(j);
    j
    for i =1:length(PH)
        tmp_modelparamvals1(ismember(tmp_modelparams,'kf4base')) = previousparamvals(ismember(tmp_modelparams,'kf4base')) * PH(i);
        %     tmp_initialConditions(ismember(statenames,'JNK'))=tmp_initialConditions1(ismember(statenames,'JNK')) * PH(i);
        
        tmp_output_higher_pH = JNK_pHi_model(tmp_simtime,tmp_initialConditions,tmp_modelparamvals1');
        
        act_JNK(i,j,:) = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'JNKr'));
        JNK(i,j,:) = tmp_output_higher_pH.statevalues(tmp_tidx,ismember(tmp_output_higher_pH.states,'JNK'));
        act_ASK(i,j,:) = tmp_output_higher_pH.statevalues(tmp_tidx,ismember(tmp_output_higher_pH.states,'act_ASK'));
        JNKcon(i,j,:) = tmp_output_higher_pH.statevalues(tmp_tidx,ismember(tmp_output_higher_pH.states,'JNK2con')); 
        DUSP1 (i,j,:) = tmp_output_higher_pH.statevalues(tmp_tidx,ismember(tmp_output_higher_pH.states,'DUSP1')); 
        
    end
end
%% timecourse plot
width = 200;
hight = 140;



%% different PH - 3D plot

Int_JNK = sum(act_JNK,3)
% Sorbitol
figure('Position',[1175         658         209         129]);
[Y,X] = meshgrid(param,PH);
Z = (Int_JNK)./max(max(Int_JNK));

mesh(X,Y,Z)
colormap (jet)
% set(gca,'XTickLabel',[],'YTickLabel',[], 'ZTicklabel',[])
res = 600;
set(gca,'fontsize',12,'linewidth',1);
box off
print('figures/3D-JNK_Sor.svg','-dsvg',['-r' sprintf('%.0f',res)]);
print('figures/3D-JNK_Sor.png','-dpng',['-r' sprintf('%.0f',res)]);











