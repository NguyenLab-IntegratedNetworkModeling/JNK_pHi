clear all
close all
mkdir("figures")
mkdir("figures/svg")

paramsets = textread('paramset_15_1_24.txt');
[param_best,ic] = unique(paramsets,'rows');
data_format
targetparam1=EstimData.model.paramnames(1:50);
tmp_modelparams = JNK_pHi_model('parameters');
stim_time = 0:1:60;
tmp_simtime=[linspace(0,4999,500) 5000+stim_time];
tmp_tidx=tmp_simtime>=5000;
tmp_initialConditions = JNK_pHi_model;
statenames = JNK_pHi_model('states');
tmp_initialConditions1 = tmp_initialConditions;
previousparamvals=param_best(1,2:end);
% find location of target params in the param vector


%% Sorbitol
tmp_modelparamvals1 = previousparamvals;
tmp_modelparamvals1(ismember(tmp_modelparams,'Sorbitol0'))=1;
level = 1:10:50;

for i=1:length(level)
    tmp_modelparamvals1(ismember(tmp_modelparams,'ki4'))=previousparamvals(ismember(tmp_modelparams,'ki4')) * level(i);
%     tmp_initialConditions(ismember(statenames,'JNK'))=tmp_initialConditions1(ismember(statenames,'JNK')) * level(i);

    tmp_output_higher_pH = JNK_pHi_model(tmp_simtime,tmp_initialConditions,tmp_modelparamvals1');
    
    pHi_Sor(i,:) = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'pHir'));
    JNK_Sor(i,:) = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'JNKr'));
    ASK_con_Sor = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'totalASK'));
end

%% plotting

width = 130;
hight = 95;

figure('Position',[1175         658         width   hight]);
hold on

plot(stim_time,pHi_Sor./max(max(pHi_Sor)),'linewidth',1)


xticks([0 20 40 60])
set(gca,'fontsize',8,'linewidth',1);
saveas(gcf,sprintf('figures/transition.png'))
saveas(gcf,sprintf('figures/transition.svg'))

