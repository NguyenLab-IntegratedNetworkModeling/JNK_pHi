clear all
close all
mkdir("figures")
mkdir("figures/svg")
paramsets = textread('paramset_15_1_24.txt');
[param_best,ic] = unique(paramsets,'rows');
data_format
targetparam1=EstimData.model.paramnames(1:47);
tmp_modelparams = JNK_pHi_model('parameters');
stim_time = 0:0.1:120;
tmp_simtime=[linspace(0,4999,500) 5000+stim_time];
tmp_tidx=tmp_simtime>=5000;
tmp_initialConditions = JNK_pHi_model;
statenames = JNK_pHi_model('states');
tmp_initialConditions1 = tmp_initialConditions;
%% best fitted parameter set

previousparamvals=param_best(1,2:end);
% find location of target params in the param vector
targetlocs{1}=find(ismember(EstimData.model.paramnames,targetparam1));

%%%%%%%%%%%%%%%%%

tmp_modelparamvals1 = previousparamvals;
tmp_modelparamvals1(ismember(tmp_modelparams,'TNF0'))=1;

ASK = [1 0.1];
for i =1:length(ASK)
    tmp_initialConditions(ismember(statenames,'ASK'))=tmp_initialConditions1(ismember(statenames,'ASK')) * ASK(i);

    tmp_output_higher_pH = JNK_pHi_model(tmp_simtime,tmp_initialConditions,tmp_modelparamvals1');
    
    pHi_TNF(i,:) = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'pHir'));
    JNK_TNF(i,:) = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'JNKr'));
    
end

tmp_modelparamvals1 = previousparamvals;
tmp_modelparamvals1(ismember(tmp_modelparams,'Sorbitol0'))=1;

for i =1:length(ASK)
    tmp_initialConditions(ismember(statenames,'ASK'))=tmp_initialConditions1(ismember(statenames,'ASK')) * ASK(i);
    tmp_output_higher_pH = JNK_pHi_model(tmp_simtime,tmp_initialConditions,tmp_modelparamvals1');
    
    pHi_Sor(i,:) = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'pHir'));
    JNK_Sor(i,:) = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'JNKr'));
    
end


%%
width = 200;
hight = 140;

%% different PH - 2D plot
color = ['#2D5F8A';'#C03830'];
figure('Position',[1175         658         width   hight]);
for i=1:2
    hold on

plot(stim_time,JNK_TNF(i,:)./max(max(JNK_TNF)),'linewidth',1,'color',color(i,:))
end
xlim([0 120])
% ylim([0 inf])

xticks([0 40 80 120])

mkdir("figures")
mkdir("figures/svg")

saveas(gcf,sprintf('figures/ASK_inhibition_TNF.png'))
saveas(gcf,sprintf('figures/ASK_inhibition_TNF.svg'))

figure('Position',[1175         658         width   hight]);

for i =1:2
    hold on

plot(stim_time,JNK_Sor(i,:)./max(max(JNK_Sor)),'linewidth',1,'color',color(i,:))
end
xlim([0 120])
xticks([0 40 80 120])
% ylim([0 inf])

saveas(gcf,sprintf('figures/ASK_inhibition_Sor.png'))
saveas(gcf,sprintf('figures/ASK_inhibition_Sor.svg'))

