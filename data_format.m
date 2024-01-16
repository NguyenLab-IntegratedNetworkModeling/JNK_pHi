%% directory of training data
tmp_curdir='C:\Users\milad.ghomlaghi\Desktop\Hypo1 with mT1-IR NF';
tmp_filename='training data.xlsx';

tmp_sheet='PH_TNF';
tmp_xlRange = 'B3:C14';
tmp_num = xlsread(tmp_filename,tmp_sheet,tmp_xlRange);
EstimData.expt.title{1}=tmp_sheet;
EstimData.expt.description{1}='time course(in house data (Gaya))';
EstimData.expt.ligand{1}='Doseinput1';
EstimData.expt.dose{1}=[100]; % 10 nM
EstimData.expt.data{1}=tmp_num(:,2);
EstimData.expt.names{1}={'pHir'};
EstimData.expt.time{1}=tmp_num(:,1); % time points (min)


tmp_sheet='JNK_TNF';
tmp_xlRange = 'B3:C14';
tmp_num = xlsread(tmp_filename,tmp_sheet,tmp_xlRange);
EstimData.expt.title{2}=tmp_sheet;
EstimData.expt.description{2}='experiment 2: (Golan-Lavi, Giacomelli et al. 2017)';
EstimData.expt.ligand{2}='Doseinput1';
EstimData.expt.dose{2}=[100]; % 20ng
EstimData.expt.data{2}=tmp_num(:,2);
EstimData.expt.names{2}={'JNKr'};
EstimData.expt.time{2}=tmp_num(:,1);

tmp_sheet='PH_aniso';
tmp_xlRange = 'B3:C14';
tmp_num = xlsread(tmp_filename,tmp_sheet,tmp_xlRange);
EstimData.expt.title{3}=tmp_sheet;
EstimData.expt.description{3}='experiment 2: (Golan-Lavi, Giacomelli et al. 2017)';
EstimData.expt.ligand{3}='Doseinput1';
EstimData.expt.dose{3}=[100]; % 20ng
EstimData.expt.data{3}=tmp_num(:,2);
EstimData.expt.names{3}={'pHir'};
EstimData.expt.time{3}=tmp_num(:,1);

tmp_sheet='JNK_aniso';
tmp_xlRange = 'B3:C14';
tmp_num = xlsread(tmp_filename,tmp_sheet,tmp_xlRange);
EstimData.expt.title{4}=tmp_sheet;
EstimData.expt.description{4}='experiment 2: (Golan-Lavi, Giacomelli et al. 2017)';
EstimData.expt.ligand{4}='Doseinput1';
EstimData.expt.dose{4}=[100]; % 20ng
EstimData.expt.data{4}=tmp_num(:,2);
EstimData.expt.names{4}={'JNKr'};
EstimData.expt.time{4}=tmp_num(:,1);

tmp_sheet='PH_sorb';
tmp_xlRange = 'B3:C14';
tmp_num = xlsread(tmp_filename,tmp_sheet,tmp_xlRange);
EstimData.expt.title{5}=tmp_sheet;
EstimData.expt.description{5}=' experiment 3: (Lauriola, Enuka et al. 2014)';
EstimData.expt.ligand{5}='Doseinput1';
EstimData.expt.dose{5}=[100]; % 1 nM
EstimData.expt.data{5}=tmp_num(:,2);
EstimData.expt.names{5}={'pHir'};
EstimData.expt.time{5}=tmp_num(:,1);


% multi-dose time course response
tmp_sheet='JNK_sorb';
tmp_xlRange = 'B3:C14';
tmp_num = xlsread(tmp_filename,tmp_sheet,tmp_xlRange);
EstimData.expt.title{6}=tmp_sheet;
EstimData.expt.description{6}=' experiment 4: (Bouhaddou, Barrette et al. 2018)';
EstimData.expt.ligand{6}='Doseinput1';
EstimData.expt.dose{6}=[100]; % nM
EstimData.expt.data{6}=tmp_num(:,2);
% EstimData.expt.data{4}{2}=tmp_num(:,6);
EstimData.expt.names{6}={'JNKr'};
EstimData.expt.time{6}=tmp_num(:,1);


%% model parameters
EstimData.model.paramnames=JNK_pHi_model('parameters');
EstimData.model.paramvals=[];
EstimData.model.initialparamvals=JNK_pHi_model('parametervalues');
EstimData.model.statenames=JNK_pHi_model('states');
tmp_output=JNK_pHi_model(0:10);
EstimData.model.initials=tmp_output.statevalues(end,:);
EstimData.model.varnames=tmp_output.variables;
EstimData.model.maxnumsteps=10000; % max steps of MEX
EstimData.model.bestfit=JNK_pHi_model('parametervalues');

%% simulation data
EstimData.sim.statevalues{1}=[];
EstimData.sim.varvalues{1}=[];
EstimData.sim.resampled{1}=[];
EstimData.sim.J{1}=[];
EstimData.sim.Jb=[];
EstimData.sim.ph=[];

EstimData.sim.errorcheck= @(x) logical(sum((abs(x(end-1,x(end,:)>1e-3) - x(end,x(end,:)>1e-3))./x(end,x(end,:)>1e-3) > 1e-3) + (x(end,x(end,:)>1e-3)) < -1e-10));
EstimData.sim.ci_mask_size=0;
EstimData.sim.Jth={0 0 0 0 0 0};
EstimData.sim.Jweight={2 2 1 1 1 1};

clear -regexp ^tmp_

