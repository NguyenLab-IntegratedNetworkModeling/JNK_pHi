clear all
close all
mkdir("figures")
mkdir("figures/svg")

paramsets = textread('paramset_15_1_24.txt');
[param_best,ic] = unique(paramsets,'rows');
data_format
targetparam1=EstimData.model.paramnames(1:52);
tmp_modelparams = JNK_pHi_model('parameters');
stim_time = 0:0.1:60;
tmp_simtime=[linspace(0,4999,500) 5000+stim_time];
tmp_tidx=tmp_simtime>=5000;
tmp_initialConditions = JNK_pHi_model;
statenames = JNK_pHi_model('states');
tmp_initialConditions1 = tmp_initialConditions;
previousparamvals=param_best(1,2:end);
% find location of target params in the param vector

%% TNF

tmp_modelparamvals1 = previousparamvals;
tmp_modelparamvals1(ismember(tmp_modelparams,'TNF0'))=1;


tmp_output_higher_pH = JNK_pHi_model(tmp_simtime,tmp_initialConditions,tmp_modelparamvals1');

pHi_TNF = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'pHir'));
JNK_TNF = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'JNKr'));
ASK_con_TNF = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'totalASK'));

%% anisomycin
tmp_modelparamvals1 = previousparamvals;
tmp_modelparamvals1(ismember(tmp_modelparams,'Anisomycin0'))=1;

tmp_output_higher_pH = JNK_pHi_model(tmp_simtime,tmp_initialConditions,tmp_modelparamvals1');

pHi_Aniso = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'pHir'));
JNK_Aniso = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'JNKr'));
ASK_con_Aniso = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'totalASK'));

%% Sorbitol
tmp_modelparamvals1 = previousparamvals;
tmp_modelparamvals1(ismember(tmp_modelparams,'Sorbitol0'))=1;

tmp_output_higher_pH = JNK_pHi_model(tmp_simtime,tmp_initialConditions,tmp_modelparamvals1');

pHi_Sor = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'pHir'));
JNK_Sor = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'JNKr'));
ASK_con_Sor = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'totalASK'));


%%
width = 230;
hight = 195;

figure('Position',[1175         658         width   hight]);
hold on
yyaxis right

plot(stim_time,pHi_TNF./max(pHi_TNF),'linewidth',1,'color','#1520A6')
ylim([min(pHi_TNF/max(pHi_TNF))*0.98,max(pHi_TNF/max(pHi_TNF))*1.05])
plot(stim_time,1.0*ASK_con_TNF./max(ASK_con_TNF),'linewidth',1,'color','#AA7A38','LineStyle','-')

yyaxis left
plot(stim_time,JNK_TNF./max(JNK_TNF),'linewidth',1,'color','#9B1003')
ylim([-inf,1.03*max(JNK_TNF./max(JNK_TNF))])

xticks([0 20 40 60])
set(gca,'fontsize',8,'linewidth',1);
saveas(gcf,sprintf('figures/TNF.png'))
saveas(gcf,sprintf('figures/TNF.svg'))

figure('Position',[1175         658         width   hight]);
hold on
yyaxis right

plot(stim_time,pHi_Aniso./(pHi_Aniso(1)),'linewidth',1,'color','#1520A6')
ylim([min(pHi_Aniso./(pHi_Aniso(1)))*0.98,max(pHi_Aniso./(pHi_Aniso(1)))*1.07])
plot(stim_time,1.01*ASK_con_Aniso./(ASK_con_Aniso(1)),'linewidth',1,'color','#AA7A38','LineStyle','-')

yyaxis left
plot(stim_time,JNK_Aniso./max(JNK_Aniso),'linewidth',1,'color','#9B1003')
xticks([0 20 40 60])
ylim([-inf,1.03*max(JNK_Aniso./max(JNK_Aniso))])

set(gca,'fontsize',8,'linewidth',1);
saveas(gcf,sprintf('figures/Aniso.png'))
saveas(gcf,sprintf('figures/Aniso.svg'))


