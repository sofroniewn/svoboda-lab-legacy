function update_plot = load_spark_maps_streaming(data_dir)

global im_session
num_planes = im_session.ref.im_props.numPlanes;
num_chan = im_session.ref.im_props.nchans;
update_plot = 0;
%data_dir = fullfile(data_dir,'streaming','results');
full_data_path = fullfile(data_dir,'*.bin');

tot_files = dir(full_data_path);

if isempty(im_session.spark_output.streaming.stats{1})
    for ij = 1:numel(im_session.spark_output.regressor.names)
        im_session.spark_output.streaming.stats{ij} = cell(num_planes,num_chan);
        im_session.spark_output.streaming.tune{ij} = cell(num_planes,num_chan);
        im_session.spark_output.streaming.tune_var{ij} = cell(num_planes,num_chan);
    end
end

for ij = 1:numel(im_session.spark_output.regressor.names)
    output_files_r2 = dir(fullfile(data_dir,['r2-' im_session.spark_output.regressor.names{ij} '-*.bin']));
    output_files_tune = dir(fullfile(data_dir,['tuning-' im_session.spark_output.regressor.names{ij} '-*.bin']));
    if numel(output_files_r2) > im_session.spark_output.streaming.tot_num_files(ij) && numel(output_files_tune) > im_session.spark_output.streaming.tot_num_files(ij)
        for ig = im_session.spark_output.streaming.tot_num_files(ij)+1:numel(output_files_r2)
            r2_fid = fopen(fullfile(data_dir,output_files_r2(ig).name),'r');
            r2_mat = fread(r2_fid,'double','ieee-be');
            fclose(r2_fid);
            %r2_mat = dlmread(fullfile(data_dir,output_files_r2(end).name));
            r2_mat = reshape(r2_mat,[im_session.ref.im_props.height, im_session.ref.im_props.width, num_planes]);
            r2_mat(isnan(r2_mat)) = 0;
            tune_fid = fopen(fullfile(data_dir,output_files_tune(ig).name),'r');
            tune_mat = fread(tune_fid,'double','ieee-be');
            tune_mat(isnan(tune_mat)) = 0;
            fclose(tune_fid);
            %tune_mat = dlmread(fullfile(data_dir,output_files_tune(end).name));
            tune_mat = reshape(tune_mat,[im_session.ref.im_props.height, im_session.ref.im_props.width, num_planes]);
            tune_var_mat = zeros(size(tune_mat));
            if ~isempty(im_session.spark_output.streaming.stats{ij}{1,1}(:,:,end))
                if any(squeeze(r2_mat(:,:,1)') - im_session.spark_output.streaming.stats{ij}{1,1}(:,:,end))
                    for ik = 1:num_planes
                        for ih = 1:num_chan
                            im_session.spark_output.streaming.stats{ij}{ik,ih} = cat(3,im_session.spark_output.streaming.stats{ij}{ik,ih},squeeze(r2_mat(:,:,ik)'));
                            im_session.spark_output.streaming.tune{ij}{ik,ih} = cat(3,im_session.spark_output.streaming.tune{ij}{ik,ih},squeeze(tune_mat(:,:,ik)'));
                            im_session.spark_output.streaming.tune_var{ij}{ik,ih} = cat(3,im_session.spark_output.streaming.tune_var{ij}{ik,ih},squeeze(tune_var_mat(:,:,ik)'));
                        end
                    end
                end
            else
                for ik = 1:num_planes
                    for ih = 1:num_chan
                        im_session.spark_output.streaming.stats{ij}{ik,ih} = cat(3,im_session.spark_output.streaming.stats{ij}{ik,ih},squeeze(r2_mat(:,:,ik)'));
                        im_session.spark_output.streaming.tune{ij}{ik,ih} = cat(3,im_session.spark_output.streaming.tune{ij}{ik,ih},squeeze(tune_mat(:,:,ik)'));
                        im_session.spark_output.streaming.tune_var{ij}{ik,ih} = cat(3,im_session.spark_output.streaming.tune_var{ij}{ik,ih},squeeze(tune_var_mat(:,:,ik)'));
                    end
                end
            end
        end
        im_session.spark_output.streaming.tot_num_files(ij) = numel(output_files_r2);
        update_plot = 1;
    end
end



