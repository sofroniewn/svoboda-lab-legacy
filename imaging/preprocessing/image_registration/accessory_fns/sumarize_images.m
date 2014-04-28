function im_summary = sumarize_images(improps,im_raw,im_shifted,shifts_raw,scim_trial)
%display('Resorting data')
%tic
num_planes = improps.numPlanes;
num_chan = improps.nchans;

% resort data
mean_aligned = cell(num_planes,num_chan);
mean_raw = cell(num_planes,num_chan);
shifts = cell(num_planes,1);

for ij = 1:num_chan
    for ik = 1:num_planes
        mean_raw{ik,ij} = uint16(mean(im_raw(:,:,(ik+(ij-1)*num_chan):num_planes*num_chan:end),3));
        mean_aligned{ik,ij} = uint16(mean(im_shifted(:,:,(ik+(ij-1)*num_chan):num_planes*num_chan:end),3));
        shifts{ik} = shifts_raw(ik:num_planes:end,:);
    end
end

% extract summary data
im_summary.props.num_frames = size(shifts_raw,1)/num_planes;
im_summary.props.num_planes = num_planes;
im_summary.props.num_chan = num_chan;
im_summary.props.height = improps.height;
im_summary.props.width = improps.width;
im_summary.props.firstFrame = improps.firstFrameNumberRelTrigger;
im_summary.props.frameRate = improps.frameRate;
im_summary.props.scim_trial = scim_trial;
im_summary.shifts = shifts;
im_summary.mean_raw = mean_raw;
im_summary.mean_aligned = mean_aligned;
%toc