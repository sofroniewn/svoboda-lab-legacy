%
% [im improps] = load_image(fullpath, frames, opt)
%
% S Peron Nov 2009
%
% This is basically a wrapper for imread that allows you to do more fancy things
%  as necessity arises.  Returns im, which is either a stack or a single frame.
%
% PARAMS:
%
%  fullpath - location of the image stack file.  You can specify a wildcard using
%             a * or a cell array of filenames -- in this case, it will load all as
%             a single stack.
%  frames - [a b] or a ; if [a b], read inclusively frame range a to b ; if a, only a.
%           If the file is multichannel, frame a does *not* correspond to frame a in
%           the file, but rather frame a in the specified channel.  Set to -1 to load all.
%  opt - a generic structure for parameters:
%        numchannels - how many imaging channels?  if > 1, assume frames are in
%                      1_c1,1_c2,2_c1,2_c2 ... where 1_c1 is frame 1, channel 1
%                      FOR now this is ignored -- scanimage header has this, and if
%                      not scanimage, then assumed 1.  This is typically
%                      detected automatically but you can override manually.
%        channel - if # channels > 1, you can select (default ALL).  Can be
%                  a vector, in which case your stack will consist of
%                  c1_1,c1_2,...c1_m, c2_1,c2_2,c2_m,...cn_1,cn_2,...cn_m where
%                  m is the # of channels and m is the number of frames/chan
%                  SET to 0 to load ALL channels ; default 0.  Note that the
%                  channel numbering is in terms of ordering within the
%                  file and NOT scanimage-assigned number.
%        negodds - if set to 1, then post-loading, all ODD values are set to
%                  negative, then 1 is subtracted from them, and finally the
%                  whole thing is divided by two.  Basically, for loading data
%                  that was processed by ThorLabs alizzar digitizer.
%        data_type - what should data type be?  default is 'single' ; can be
%               'double', 'uint16', etc.
%
% RETURNS:
%
%  im - the image stack
%  improps - structure with following fields:
%    header: stuff in the 'ImageDescription' field from imfinfo
%    width, height: (duh!)
%    nframes: how many frames in the returned image -- PER CHANNEL
%    nchans: how many channels in the original image? (you know how many are
%            returned since you specified it!)
%    frameRate: in Hz, scanimage header.  If this is volume imaging, frameRate
%               will effectively be volume rate -- i.e., how many volumes/second --
%               taken by dividing 1 by fastZPeriod property.
%    numPlanes: if you are indeed using fast Z, how many planes are being imaged?
%    firstFrameNumberRelTrigger: first frame AFTER trigger is 1, then this grows,
%                             and next trigger DOES NOT increment this only
%                             start of a new LOOP.
%    startTimeMS: when was trigger received, based on scanimage header (in ms)
%    startOffsetMS: when did imaging start relative trigger? (offset in ms)
%
function [im improps] = load_image(fullpath, frames, opt)
im = [];
improps = [];
SI_date_format_str = 'dd-mm-yyyy HH:MM:SS.FFF';

%% --- input parse

% # arguments
if (nargin < 2) ; frames = -1 ; end % all frames default
if (nargin < 3) ; opt = []; end
if (nargin == 2 && isstruct(frames)) ; opt = frames; frames = -1 ; end

% opt check:
negodds = 0;
numchannels = 1;
channel = 0;
data_type = 'single';

if (isstruct(opt))
    fn = fieldnames(opt);
    for f=1:length(fn)
        eval([fn{f} ' = opt.' fn{f} ';']);
    end
end

%% --- read mode -- tiff lib?
read_mode = 1; % default -- imread
% if (length(which('tifflib') > 0))
%     read_mode = 2;
% else
%     %  disp('load_image::load_image is now optimized for using the mex tifflib, which will make things MUCH faster.  To use,')
%     %	disp('copy tifflib.XXXX from the MATLAB toolbox imagesci directory into sci/lib.  XXXX depends on your distro.');
%     %disp('');
%     pathStr = path;
%     colIdx = find(pathStr == ':');
%     imageSciIdx = strfind(pathStr,'imagesci');
%     ci1 = colIdx(max(find(colIdx < imageSciIdx)));
%     ci2 = colIdx(min(find(colIdx > imageSciIdx)));
%     desiredDir = pathStr(ci1+1:ci2-1);
%     %disp(['Get it from: ' desiredDir ' (or a subdirectory thereof)']);
%     %disp(['Put it in: ' fileparts(which('load_image'))]);
% end

%% --- recursive?  check for * in name
if (iscell(fullpath)) % list of files?
    disp('load_image: cell array passed; loading multiple files.');
    frame_idx = 1;
    
    nframes = zeros(1,length(fullpath));
    
    % get # frames first
    nframes_total = 0;
    for f=1:length(fullpath)
        fname = fullpath{f};
        iinfo = imfinfo(fname);
        nframes(f) = length(iinfo);
        
        if (f == 1) ; iinfo_1 = iinfo(1) ; end
        
        [irr improps] = load_image(fname, []);
        if (improps.nchans > 1 && channel ~= 0)
            nframes(f) = nframes(f)*(length(channel)/improps.nchans);
        end
    end
    
    % prebuild output
    im = zeros(iinfo_1.Height, iinfo_1.Width, sum(nframes), data_type);
    
    % load
    for f=1:length(fullpath)
        fname = fullpath{f};
        [im(:,:,frame_idx:frame_idx+nframes(f)-1) props]= load_image(fname, frames, opt);
        if (f == 1) ; improps = props ; end
        frame_idx = frame_idx+nframes(f);
    end
    
elseif (length(find (fullpath == '*')) > 0) % wildcard: convert to list and bump it up
    disp('load_image: wildcard detected; building cell array list.');
    fl = dir(fullpath);
    top_dir = fullpath(1:find(fullpath == filesep, 1, 'last'));
    
    if (length(fl) == 0)
        disp(['load_image::no files found matching ' fullpath ' wildcard; aborting load.'])
        return;
    else
        fnames = {};
        for f=1:length(fl)
            if (length(top_dir) > 0)
                fnames{f} = [top_dir filesep fl(f).name];
            else
                fnames{f} = fl(f).name;
            end
        end
        
        [im improps] = load_image(fnames, frames, opt);
        nframes = size(im,3);
    end
    %% --- single file mode
else
    % .tif append?
    if (~exist(fullpath, 'file') & exist ([fullpath '.tif'], 'file')) ; fullpath =[fullpath '.tif']; end
    
    % --- scanimage header info
    try
        hdr = extern_scim_opentif_fast(fullpath, 'header');
        imf = hdr.info;
    catch
        hdr = -1;
    end
    
    if (isstruct(hdr) == 0 & hdr == -1)
        disp(['load_image::' fullpath ' is not a scanimage TIF; no header.']);
        improps.nchans = 1;
        improps.startTimeMS = 0;
        improps.startOffsetMS = 0;
        improps.frameRate = 0;
        improps.numPlanes= 0;
    else
        if (isfield(hdr, 'SI4')) % SI4
            hdr = hdr.SI4;
            % number of channels
            improps.nchans = length(hdr.channelsSave);
            
            % frame rate
            improps.frameRate = hdr.scanFrameRate;
            
            % # planes
            improps.numPlanes = 1;
            
            % Fast Z?
            if (hdr.fastZEnable)
                improps.numPlanes= round(hdr.scanFrameRate*hdr.fastZPeriod) ;
                improps.frameRate = 1/hdr.fastZPeriod;
            end
            
            % frame start time (first frame of file -- usually some lag after trigger)
            %  this is the OFFSET in seconds (with 10 us precision) after LOOP in scanimage started, so
            %  we must add to date stamp of the time at which first frame of LOOP was obtained to get
            %  actual bonafide time
            frame_start = hdr.triggerFrameStartTime*1000;
            first_time = hdr.triggerClockTimeFirst;
            d2ms = 24*60*60*1000; % date number from MATLAB to ms conversion factor
            improps.startTimeMS= d2ms*datenum(first_time, SI_date_format_str) + frame_start;
            
            % how much *before* the frame started did the trigger come?  should ALWAYS be positive or zero
            %  since trigger should come BEFORE new file is started
            if (isfield(hdr, 'triggerFrameStartTime'))
                trigger_start_offs = hdr.triggerFrameStartTime*1000 - hdr.triggerTime*1000;
            else
                disp('load_image::no triggerFrameStartTime field ; setting trigger_start_offs to 0 ms');
                trigger_start_offs = 0;
            end
            improps.startOffsetMS = trigger_start_offs;
            
            % frame number
            if (isfield(hdr, 'triggerFrameNumber'))
                improps.firstFrameNumberRelTrigger = hdr.triggerFrameNumber;
            else
                improps.firstFrameNumberRelTrigger = -1;
            end
        else % SI3
            % number of channels
            improps.nchans = hdr.acq.numberOfChannelsAcquire;
            
            % frame rate
            improps.frameRate = hdr.acq.frameRate;
            
            % 1 plane
            improps.numPlanes= 1;
            
            % start time
            trig_time = hdr.internal.triggerTimeString;
            if (isfield(hdr.internal, 'triggerFrameDelayMS'))
                trigger_start_offs = hdr.internal.triggerFrameDelayMS;
            else
                disp('load_image::no triggerFrameDelayMS field ; setting trigger_start_offs to 0 ms');
                trigger_start_offs = 0;
            end
            d2ms = 24*60*60*1000; % date number from MATLAB to ms conversion factor
            improps.startTimeMS= d2ms*datenum(trig_time, SI_date_format_str)+trigger_start_offs;
            improps.startOffsetMS = trigger_start_offs;
            improps.firstFrameNumberRelTrigger = nan; % not in SI3
        end
    end
    numchannels = improps.nchans;
    
    % --- channel selection/cleanup
    % want all channels? - do it!
    if (channel == 0)
        channel = 1:numchannels;
    else % check channel selection
        % one selected but wrong? fix this (set to 1)
        if (length(channel) == 1 & channel > numchannels)
            disp(['load_image::invalid channel number ' num2str(channel) ' ; setting to 1']);
            channel = 1;
        end
        noc = [];
        % multi? scan and make sure valid; discard otherwise
        for c=1:length(channel)
            if (channel(c) > 0 & channel(c) <= numchannels)
                noc(length(noc)+1) = channel(c);
            else
                disp(['load_image::no channel ' num2str(channel(c))]);
            end
        end
        channel = noc;
    end
    
    % --- load - first, get info and construct im, then fill it
    %imf = imfinfo(fullpath);
    
    bit_depth = imf(1).BitDepth;
    nframes = length(imf);
    
    % grab header
    if (isfield(imf, 'ImageDescription') == 0)
        improps.header = '';
    else
        hdr_txt = imf.ImageDescription;
        improps.header = hdr_txt;
    end
    
    if (length(frames) == 2) % frame range
        nf = 1;
        for f=frames(1):frames(2)
            for c=1:length(channel)
                frames(nf) = (f-1)*numchannels + channel(c);
                nf = nf + 1;
            end
        end
    elseif (length(frames) == 0) % header only
    elseif (frames(1) == -1) % load all frame mode
        nf = 1;
        for f=1:length(imf)/numchannels % loop over frames
            for c=1:length(channel)
                frames(nf) = (f-1)*numchannels + channel(c);
                nf = nf + 1;
            end
        end
    else
        error(['load_image::frames should be either 0, 1, or 2 elements.']);
    end
    
    % data type
    im = zeros(imf(1).Height, imf(1).Width, length(frames), data_type);
    read_mode = 3;
    if (read_mode == 3) %fast imread
        fmt_s = imformats('tif');
        for f=1:length(frames)
            infile_idx = frames(f);
            % skip inappropriately sized frames
            if (imf(infile_idx).Width == imf(1).Width & imf(infile_idx).Height == imf(1).Height)
                im(:,:,f) = feval(fmt_s.read, fullpath, infile_idx);
            else
                disp(['load_image::not allowed to have files with disparate frame sizes -- skipping frame ' num2str(infile_idx) ' in ' fullpath]);
            end
        end
    elseif (read_mode == 2) % tifflib
        file_id = tifflib('open',fullpath,'r');
        rps = tifflib('getField',file_id,Tiff.TagID.RowsPerStrip);
        im_height = imf(1).Height;
        warning('off','MATLAB:imagesci:Tiff:libraryWarning');
        
        for f=1:length(frames)
            tifflib('setDirectory',file_id,frames(f));
            % Go through each strip of data.
            rps = min(rps,im_height);
            for r = 1:rps:im_height
                row_inds = r:min(im_height,r+rps-1);
                strip_num = tifflib('computeStrip',file_id,r);
                im(row_inds,:,f) = tifflib('readEncodedStrip',file_id,strip_num);
            end
        end
        tifflib('close',file_id);
        warning('on','MATLAB:imagesci:Tiff:libraryWarning');
        
    elseif (read_mode == 1) % imread
        for f=1:length(frames)
            infile_idx = frames(f);
            % skip inappropriately sized frames
            if (imf(infile_idx).Width == imf(1).Width & imf(infile_idx).Height == imf(1).Height)
                im(:,:,f) = imread(fullpath, infile_idx, 'Info', imf);
            else
                disp(['load_image::not allowed to have files with disparate frame sizes -- skipping frame ' num2str(infile_idx) ' in ' fullpath]);
            end
        end
    end
    
end

% --- ThorLabs odd-to-negative correction
if (negodds)
    max_val = max(reshape(im,[],1));
    oddidx = find(ismember(im,1:2:max_val));
    im(oddidx) = im(oddidx)*-1;
    im(oddidx) = im(oddidx) -1;
    im = im/2;
end

% --- image properties
improps.height = size(im,1);
improps.width = size(im,2);
improps.nframes = nframes/length(channel);
