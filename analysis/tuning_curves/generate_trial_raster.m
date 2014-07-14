function trial_raster = generate_trial_raster(roi_id,stim_type_name,keep_type_name,trial_range)

global session_bv;
global session_ca;

	global handles_roi_ts
                switch handles_roi_ts.type
                    case 'dff'
                        respones_vect = session_ca.dff(roi_id,:);
                    case 'events'
                        respones_vect = session_ca.events(roi_id,:);
                    case 'event_dff'
                        respones_vect = session_ca.event_dff(roi_id,:);
                    case 'raw'
                        respones_vect = session_ca.rawRoiData(roi_id,:);
                    case 'deconv'
      					caES = session_ca.event_array{roi_id};
                        rescale = 5;
                        caES.decayTimeConstants = caES.decayTimeConstants/rescale;
                        respones_vect = getDffVectorFromEvents(caES, session_ca.time, 2);
                        caES.decayTimeConstants = caES.decayTimeConstants*rescale;
          		    case 'neuropil'
                        respones_vect = session_ca.neuropilData(roi_id,:);
                    otherwise
                        respones_vect = session_ca.dff(roi_id,:);
                end


if strcmp(keep_type_name,'openloop')
 scim_frames = logical(session_bv.data_mat(24,:));
 iti_vect = session_bv.data_mat(9,scim_frames);
 tmp = session_bv.data_mat(25,:);
 % correction for bug in anm0227254 data
 if iti_vect(1) == 0
 tmp = [tmp(501:end),repmat(tmp(end),1,501)];
  end
 trial_num_vect = tmp(scim_frames);
 respones_vect = subtract_iti_dff(respones_vect,iti_vect,trial_num_vect);
end

trial_raster = get_full_trial_vars(stim_type_name,keep_type_name,trial_range,respones_vect);




