function [aux_chan ch_ids start_ind] = extract_behaviour_triggers(aux_chan,ch_ids);

	% find index of new file trigger
	start_ind = find(aux_chan(:,ch_ids.file_trigger) > .5,1,'first');
	% find index of all frame triggers
	frame_trigs = aux_chan(:,ch_ids.frame_trigger) > .5;
	frame_trigs = 1+find(diff(frame_trigs) == 1);

	% make vector with behaviour file trigger numbers
	bv_frame_nums = zeros(size(aux_chan,1),1);
	bv_frame_nums(frame_trigs) = 1;
	bv_frame_nums = cumsum(bv_frame_nums);

	bv_frame_nums = bv_frame_nums - bv_frame_nums(start_ind);

	ch_ids.bv_frame_nums = size(aux_chan,2) + 1;
	aux_chan = cat(2,aux_chan,bv_frame_nums);
