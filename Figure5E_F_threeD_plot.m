clear all
close all
mkdir("figures")
mkdir("figures/svg")
paramsets = textread('paramset_15_1_24.txt');
[param_best,ic] = unique(paramsets,'rows');
data_format
targetparam1=EstimData.model.paramnames(1:47);
tmp_modelparams = JNK_pHi_model('parameters');
stim_time = 0:0.1:200;
tmp_simtime=[linspace(0,4999,500) 5000+stim_time];
tmp_tidx=tmp_simtime>=5000;
tmp_initialConditions = JNK_pHi_model;
statenames = JNK_pHi_model('states');
tmp_initialConditions1 = tmp_initialConditions;
%% best fitted parameter set

previousparamvals=param_best(1,2:end);
% find location of target params in the param vector

%%%%%%%%%%%%%%%%%

tmp_modelparamvals1 = previousparamvals;
tmp_modelparamvals1(ismember(tmp_modelparams,'TNF0'))=1;
% tmp_modelparamvals1(ismember(tmp_modelparams,'kf1d'))=previousparamvals(ismember(tmp_modelparams,'kf6')) / 2;

PH = (0.6+0.01*(0:100));
for i =1:length(PH)
    
    tmp_modelparamvals1(ismember(tmp_modelparams,'kf4base'))=previousparamvals(ismember(tmp_modelparams,'kf4base')) * PH(i);
%     tmp_initialConditions(ismember(statenames,'JNK'))=tmp_initialConditions1(ismember(statenames,'JNK')) * PH(i);

    tmp_output_higher_pH = JNK_pHi_model(tmp_simtime,tmp_initialConditions,tmp_modelparamvals1');
    
    pHi_TNF(i,:) = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'pHir'));
    JNK_TNF(i,:) = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'JNKr'));
    
end

tmp_modelparamvals1 = previousparamvals;
% tmp_modelparamvals1(ismember(tmp_modelparams,'kf1d'))=previousparamvals(ismember(tmp_modelparams,'kf6')) / 2;

tmp_modelparamvals1(ismember(tmp_modelparams,'Sorbitol0'))=1;

for i =1:length(PH)
    tmp_modelparamvals1(ismember(tmp_modelparams,'kf4base'))=previousparamvals(ismember(tmp_modelparams,'kf4base')) * PH(i);
%     tmp_initialConditions(ismember(statenames,'JNK'))=tmp_initialConditions1(ismember(statenames,'JNK')) * PH(i);

    tmp_output_higher_pH = JNK_pHi_model(tmp_simtime,tmp_initialConditions,tmp_modelparamvals1');
    
    pHi_Sor(i,:) = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'pHir'));
    JNK_Sor(i,:) = tmp_output_higher_pH.variablevalues(tmp_tidx,ismember(tmp_output_higher_pH.variables,'JNKr'));
    
end

%% different PH - 2D plot
width = 200;
hight = 140;

figure('Position',[1175         658         width   hight]);
hold on

plot (PH,trapz(JNK_TNF,2)./max(trapz(JNK_TNF,2)),'linewidth',1,'color',[0 0 0])

plot (PH,trapz(JNK_Sor,2)./max(trapz(JNK_Sor,2)),'linewidth',1,'color',[0 .3 .8])
saveas(gcf,sprintf('figures/sorbitol.svg'))
saveas(gcf,sprintf('figures/sorbitol.png'))



%% different PH - 3D plot
% TNF
figure('Position',[1175         658         209         129]);
[X,Y] = meshgrid(stim_time,PH);
Z = JNK_TNF/max(max(JNK_TNF));

mesh(X,Y,Z)
colormap (jet)
set(gca,'XTickLabel',[],'YTickLabel',[], 'ZTicklabel',[])
res = 600;
set(gca,'fontsize',12,'linewidth',1);
box off
print('figures/svg/3D-JNK_TNF.svg','-dsvg',['-r' sprintf('%.0f',res)]);
print('figures/svg/3D-JNK_TNF.png','-dpng',['-r' sprintf('%.0f',res)]);

% Sorbitol
figure('Position',[1175         658         209         129]);
[Y,X] = meshgrid(PH,stim_time);
Z = JNK_Sor'/max(max(JNK_Sor));

mesh(X,Y,Z)
colormap (jet)
set(gca,'XTickLabel',[],'YTickLabel',[], 'ZTicklabel',[])
res = 600;
set(gca,'fontsize',12,'linewidth',1);
box off
print('figures/svg/3D-JNK_Sor.svg','-dsvg',['-r' sprintf('%.0f',res)]);
print('figures/svg/3D-JNK_Sor.png','-dpng',['-r' sprintf('%.0f',res)]);

