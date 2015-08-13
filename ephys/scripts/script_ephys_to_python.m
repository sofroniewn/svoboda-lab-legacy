%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOAD SESSION
clear all
close all
drawnow
local_save_path = '/Users/sofroniewn/Documents/DATA/ephys_summary_rev13';
cd(local_save_path);
load('matlab_session_all4.mat')

ps.ipsi_anm = zeros(length(ps.anm_id),1);
 for ij = [5 6 8]
      anm_id = all_anm.names{ij}
      anm_num = str2num(anm_id);
      ps.ipsi_anm = ps.ipsi_anm | (ps.anm_id == anm_num);
end

[ps rasters_ipsi] = get_ipsi_tune_params(all_anm,ps,ps.total_order,rasters);

local_python_save_path = '/Users/sofroniewn/Documents/DATA/ephys_python';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

ps.cl_anm = zeros(length(ps.anm_id),1);
 for ih = 1:numel(all_anm_id)
   anm_id = all_anm_id{ih}
   [base_dir anm_params] = ephys_anm_id_database(anm_id,0);
  if ismember(anm_params.exp_type,{'bilateral_ol_cl';'ol_cl_different_widths';'classic_ol_cl'})
      anm_num = str2num(anm_id);
      ps.cl_anm = ps.cl_anm | (ps.anm_id == anm_num);
    end
end

[ps rasters_cl] = get_cl_tune_params(all_anm,ps,ps.total_order,rasters);

ps.spikes_tune_ol = zeros(length(length(ps.cl_anm)),1);
ps.spikes_tune_cl = zeros(length(length(ps.cl_anm)),1);
for ij = 1:length(ps.cl_anm)
  if ps.cl_anm(ij)
    frac_pts = rasters_cl{ij}.tuning_curve.num_pts/sum(rasters_cl{ij}.tuning_curve.num_pts)*100;
    ps.spikes_tune_cl(ij) =   mean(rasters_cl{ij}.tuning_curve.means(frac_pts>1));
    ps.spikes_tune_ol(ij) =   mean(rasters{ij}.tuning_curve.means(frac_pts>1));
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%
barrel_inds = {'C1','C2','C3','C4','D1','D2','B1','outside'};
layer_id = {'Layer1','Layer23','Layer4','Layer5a','Layer5b','Layer6'};

s = [];
s.Anm = num2cell(horzcat(repmat('Anm_0',length(ps.anm_id),1),num2str(ps.anm_id)),2);
s.CordsAP = ps.AP;
s.CordsML = ps.ML;
s.Barrel = barrel_inds(ps.barrel_loc);
s.IpsiAnm = ps.ipsi_anm;
s.ClAnm = ps.cl_anm;
%%%%% make an info.JSON file

s.ChannelPeak = ps.chan_depth-1;
s.DistLayer4um = ps.layer_4_dist_FINAL;
s.Layer = layer_id(ps.layer_id_FINAL);

% include waveforms for each spike

s.SourceId = ps.clust_id-1;

s.TotalNumSpikes = ps.num_spikes;
s.ISIPeak = ps.isi_peak;
s.ISIViolations = ps.isi_violations;
s.SpikeWaveformSNR = ps.waveform_SNR;
s.MeanSpikeAmplitude = ps.spk_amplitude;
s.SpikeWidth = ps.spike_tau;
s.SpikeTau1 = ps.spike_tau1;
s.SpikeTau2 = ps.spike_tau2;
s.StableFR = ps.stab_fr;
s.StableAmp = ps.stab_amp;

s.BaselineRate = ps.baseline_rate;
s.PeakRate = ps.peak_rate;
s.DirectionMod = ps.dir_mod;
s.TuningMod = ps.tc_mod;

params_names = fieldnames(s);
for ij = 1:numel(params_names)
	tmp = s.(params_names{ij});
	if ~isrow(tmp)
		tmp = tmp';
	end
	s.(params_names{ij}) = tmp;
end

opt = [];
opt.NaN = 'NaN';
opt.Inf = 'NaN';
opt.FileName = fullfile(local_python_save_path,'unitsDF.json');
savejson('',s,opt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indS = 1;
rastersTMP = rasters;

sBetas = [];
sBetas.ParamVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_vals));
sBetas.MeanVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_vals));
sBetas.StdVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_vals));
sBetas.NumPts = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_vals));
sBetas.FitVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_fit_vals));
sBetas.FitParamVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_fit_vals));
sBetas.R2Val = NaN(length(s.Anm),1);
for ij = 1:length(s.Anm)
	if ~isempty(rastersTMP{ij})
		sBetas.ParamVals(ij,:) = rastersTMP{ij}.tuning_curve.regressor_obj.x_vals;
		sBetas.MeanVals(ij,:) = rastersTMP{ij}.tuning_curve.means;
		sBetas.StdVals(ij,:) = rastersTMP{ij}.tuning_curve.std;
		sBetas.NumPts(ij,:) = rastersTMP{ij}.tuning_curve.num_pts;
		sBetas.FitVals(ij,:) = rastersTMP{ij}.tuning_curve.model_fit.curve;
		sBetas.FitParamVals(ij,:) = rastersTMP{ij}.tuning_curve.regressor_obj.x_fit_vals;
		sBetas.R2Val(ij,:) = rastersTMP{ij}.tuning_curve.model_fit.r2;
	end
end
sBetas.R2Val = ps.r2;
opt = [];
opt.NaN = 'NaN';
opt.Inf = 'NaN';
opt.FileName = fullfile(local_python_save_path,'unitsCorPos.json');
savejson('',sBetas,opt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indS = find(ps.cl_anm,1,'first');
rastersTMP = rasters_cl;

sBetas = [];
sBetas.ParamVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_vals));
sBetas.MeanVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_vals));
sBetas.StdVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_vals));
sBetas.NumPts = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_vals));
sBetas.FitVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_fit_vals));
sBetas.FitParamVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_fit_vals));
sBetas.R2Val = NaN(length(s.Anm),1);
for ij = 1:length(s.Anm)
	if ~isempty(rastersTMP{ij})
		sBetas.ParamVals(ij,:) = rastersTMP{ij}.tuning_curve.regressor_obj.x_vals;
		sBetas.MeanVals(ij,:) = rastersTMP{ij}.tuning_curve.means;
		sBetas.StdVals(ij,:) = rastersTMP{ij}.tuning_curve.std;
		sBetas.NumPts(ij,:) = rastersTMP{ij}.tuning_curve.num_pts;
		sBetas.FitVals(ij,:) = rastersTMP{ij}.tuning_curve.model_fit.curve;
		sBetas.FitParamVals(ij,:) = rastersTMP{ij}.tuning_curve.regressor_obj.x_fit_vals;
		sBetas.R2Val(ij,:) = rastersTMP{ij}.tuning_curve.model_fit.r2;
	end
end
sBetas.R2Val = ps.cl_r2;
opt = [];
opt.NaN = 'NaN';
opt.Inf = 'NaN';
opt.FileName = fullfile(local_python_save_path,'unitsCorPosCL.json');
savejson('',sBetas,opt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indS = find(ps.ipsi_anm,1,'first');
rastersTMP = rasters_ipsi;

sBetas = [];
sBetas.ParamVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_vals));
sBetas.MeanVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_vals));
sBetas.StdVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_vals));
sBetas.NumPts = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_vals));
sBetas.FitVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_fit_vals));
sBetas.FitParamVals = NaN(length(s.Anm),length(rastersTMP{indS}.tuning_curve.regressor_obj.x_fit_vals));
sBetas.R2Val = NaN(length(s.Anm),1);
for ij = 1:length(s.Anm)
	if ~isempty(rastersTMP{ij})
		sBetas.ParamVals(ij,:) = rastersTMP{ij}.tuning_curve.regressor_obj.x_vals;
		sBetas.MeanVals(ij,:) = rastersTMP{ij}.tuning_curve.means;
		sBetas.StdVals(ij,:) = rastersTMP{ij}.tuning_curve.std;
		sBetas.NumPts(ij,:) = rastersTMP{ij}.tuning_curve.num_pts;
		sBetas.FitVals(ij,:) = rastersTMP{ij}.tuning_curve.model_fit.curve;
		sBetas.FitParamVals(ij,:) = rastersTMP{ij}.tuning_curve.regressor_obj.x_fit_vals;
		sBetas.R2Val(ij,:) = rastersTMP{ij}.tuning_curve.model_fit.r2;
	end
end
sBetas.R2Val = ps.ipsi_r2;
opt = [];
opt.NaN = 'NaN';
opt.Inf = 'NaN';
opt.FileName = fullfile(local_python_save_path,'unitsCorPosIpsi.json');
savejson('',sBetas,opt);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indS = 1;
rastersTMP = rasters;

sBetas = [];
sBetas.Time = NaN(length(s.Anm),length(rastersTMP{indS}.trace_t));
sBetas.Towards = NaN(length(s.Anm),length(rastersTMP{indS}.trace_t));
sBetas.Away = NaN(length(s.Anm),length(rastersTMP{indS}.trace_t));
for ij = 1:length(s.Anm)
	if ~isempty(rastersTMP{ij})
		sBetas.Time(ij,:) = rastersTMP{ij}.trace_t';
		sBetas.Towards(ij,:) = rastersTMP{ij}.trace_on;
		sBetas.Away(ij,:) = rastersTMP{ij}.trace_off;
	end
end

opt = [];
opt.NaN = 'NaN';
opt.Inf = 'NaN';
opt.FileName = fullfile(local_python_save_path,'unitsCorPosDirection.json');
savejson('',sBetas,opt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sBetas = [];
sBetas.NumPts = NaN(length(s.Anm),length(all_anm.data{1}.d.summarized_cluster{1}.ISI.edges));
sBetas.ParamVals = NaN(length(s.Anm),length(all_anm.data{1}.d.summarized_cluster{1}.ISI.edges));
sBetas.NumPtsTotal = NaN(length(s.Anm),1);
ih = 0;
for ij = 1:numel(all_anm.data)
	for ik = 1:numel(all_anm.data{ij}.d.summarized_cluster)
		ih = ih + 1;
		sBetas.NumPts(ij,:) = all_anm.data{ij}.d.summarized_cluster{ik}.ISI.dist;
		sBetas.ParamVals(ij,:) = all_anm.data{ij}.d.summarized_cluster{ik}.ISI.edges;
		sBetas.NumPtsTotal(ij,:) = all_anm.data{ij}.d.summarized_cluster{ik}.ISI.num_spikes;
	end
end

opt = [];
opt.NaN = 'NaN';
opt.Inf = 'NaN';
opt.FileName = fullfile(local_python_save_path,'unitsISI.json');
savejson('',sBetas,opt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


sBetas = [];
sBetas.MeanVals = NaN(length(s.Anm),length(all_anm.data{1}.d.summarized_cluster{1}.WAVEFORMS.time_vect));
sBetas.StdVals = NaN(length(s.Anm),length(all_anm.data{1}.d.summarized_cluster{1}.WAVEFORMS.time_vect));
sBetas.ParamVals = NaN(length(s.Anm),length(all_anm.data{1}.d.summarized_cluster{1}.WAVEFORMS.time_vect));
sBetas.NumPtsTotal = NaN(length(s.Anm),1);
ih = 0;
for ij = 1:numel(all_anm.data)
	for ik = 1:numel(all_anm.data{ij}.d.summarized_cluster)
		ih = ih + 1;
		sBetas.MeanVals(ij,:) = all_anm.data{ij}.d.summarized_cluster{ik}.WAVEFORMS.avg;
		sBetas.StdVals(ij,:) = all_anm.data{ij}.d.summarized_cluster{ik}.WAVEFORMS.std;
		sBetas.ParamVals(ij,:) = all_anm.data{ij}.d.summarized_cluster{ik}.WAVEFORMS.time_vect;
		sBetas.NumPtsTotal(ij,:) = all_anm.data{ij}.d.summarized_cluster{ik}.WAVEFORMS.num_spikes;
	end
end

opt = [];
opt.NaN = 'NaN';
opt.Inf = 'NaN';
opt.FileName = fullfile(local_python_save_path,'unitsWaveforms.json');
savejson('',sBetas,opt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%
sParam = [];

Anm
SourceId
Param % CorPos, CorPosCL, CorPosIpsi, Towards, Away
RValue
BaselineRate
PeakRate
MeanRate
PeakValue
Activation
Supression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%

% Notebook from raw ephys to summary dataframe - specific to one experiment
% save raw spikes and spike times
for iAnm = 1:numel(all_anm.data)
	s = [];
	s.trialNum = [];
	s.spkTime = [];
	s.sourceId = [];
	for iSource = 1:numel(all_anm.data{iAnm}.d.summarized_cluster)
		s.trialNum = cat(1,s.trialNum,all_anm.data{iAnm}.d.summarized_cluster{iSource}.spike_trials-1);
		s.spkTime = cat(1,s.spkTime,all_anm.data{iAnm}.d.summarized_cluster{iSource}.spike_times_ephys);
		s.sourceId = cat(1,s.sourceId,repmat(iSource-1,length(all_anm.data{iAnm}.d.summarized_cluster{iSource}.spike_trials),1));
	end
    namesData = fieldnames(s);
    dataMat = zeros(length(s.trialNum),numel(namesData));
    for ij = 1:numel(namesData)
        dataMat(:,ij) = s.(namesData{ij});
    end
    save(fullfile(local_save_path,['Anm_0' all_anm.names{iAnm}],'ephys.mat'),'dataMat','namesData');
end

% Notebook from raw ephys to summary dataframe - specific to one experiment
% save waveforms for each spike
for iAnm = 1:numel(all_anm.data)
	waves = [];
	for iSource = 1:numel(all_anm.data{iAnm}.d.summarized_cluster)
		waves = cat(1,waves,all_anm.data{iAnm}.d.summarized_cluster{iSource}.WAVEFORMS.waves);
	end
    timeWaveform = all_anm.data{iAnm}.d.summarized_cluster{1}.WAVEFORMS.time_vect;
    save(fullfile(local_save_path,['Anm_0' all_anm.names{iAnm}],'ephysWaveforms.mat'),'waves','timeWaveform');
end

% Notebook from raw ephys to summary dataframe - specific to one experiment
% save lamina depth for cluster
for iAnm = 1:numel(all_anm.data)
	s = [];
	s.ChannelPeak = [];
	s.DistLayer4um = [];
	s.Layer = [];
	s.sourceId = [];
	for iSource = 1:numel(all_anm.data{iAnm}.d.summarized_cluster)
		ind = find(ps.clust_id == iSource & ps.anm_id == str2num(all_anm.names{iAnm}));

		s.ChannelPeak = cat(1,s.ChannelPeak,ps.chan_depth(ind)-1);
		s.DistLayer4um = cat(1,s.DistLayer4um,ps.layer_4_dist_FINAL(ind));
		s.Layer = cat(1,s.Layer,ps.layer_id_FINAL(ind)-1);
		s.sourceId = cat(1,s.sourceId,iSource-1);
	end
    layerId = layer_id;
    namesData = fieldnames(s);
    dataMat = zeros(length(s.sourceId),numel(namesData));
    for ij = 1:numel(namesData)
        dataMat(:,ij) = s.(namesData{ij});
    end
    save(fullfile(local_save_path,['Anm_0' all_anm.names{iAnm}],'ephysSummary.mat'),'dataMat','namesData','layerId');
end


% Notebook from raw ephys to summary dataframe - specific to one experiment
% save recording info for each experiment
for iAnm = 1:numel(all_anm.data)
	s = [];
	ind = find(ps.anm_id == str2num(all_anm.names{iAnm}),1);
	s.CordsAP = ps.AP(ind);
	s.CordsML = ps.ML(ind);
	s.Barrel = barrel_inds(ps.barrel_loc(ind));
	s.IpsiAnm = ps.ipsi_anm(ind);
	s.ClAnm = ps.cl_anm(ind);
	opt = [];
	opt.NaN = 'NaN';
	opt.Inf = 'NaN';
	opt.FileName = fullfile(local_save_path,['Anm_0' all_anm.names{iAnm}],'exptSummary.json');
	savejson('',s,opt);
end

% concatenate multiple clusters together to create one data frame of ephys results, save out

% for behavior have all params and then a trial type column

% get first trial and last trial and only have behaviour params for that range
% include waveforms for each spike? include cross channel amplitude for each cluster?

% function to put spikes into same time base as behaviour data
% include NaN during iti and then integer valued spike counts during bins

% include function which computes whether running or not running on trial
% include function which reshapes open loop data into trial rasters, including sensory variables
% plots overlay

% function for computing closed loop tuning curve

% generate data frame with unit summary information and (both derived from data and independent)

% include if ipsi lateral or if stimulation, if bilateral etc. etc.
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Notebook from summary data frames to figure plots - pools across experiments

% load across experiments - concatanate 
% plots results



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

