function [aux_chan ch_ids] = detect_artifacts_ephys(aux_chan,ch_ids);

   disp(['--------------------------------------------']);
    disp(['detect ephys artifacts']);
    
 
artifact_time = zeros(size(aux_chan,1),1);
	% Blank times around artifacts
if ~isempty(ch_ids.artifact)
	forward_conv = 50;
	artifact_onsets = single(diff(aux_chan(:,ch_ids.artifact))>.1);
	artifact_onsets = conv(artifact_onsets,ones(forward_conv,1),'same');
	artifact_onsets = find(artifact_onsets)+forward_conv/2;
	artifact_time(artifact_onsets) = 1;
	forward_conv = 50;
	artifact_offsets = single(diff(aux_chan(:,ch_ids.artifact))<-.1);
	artifact_offsets = conv(artifact_offsets,ones(forward_conv,1),'same');
	artifact_offsets = find(artifact_offsets)+forward_conv/2;
	artifact_time(artifact_offsets) = 1;
end

ch_ids.blank = size(aux_chan,2) + 1;
aux_chan = cat(2,aux_chan,artifact_time);

   disp(['--------------------------------------------']);
