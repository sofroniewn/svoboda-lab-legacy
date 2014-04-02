function func_scim_align_6(num_files)
%%
disp(['--------------------------------------------']);
disp(['GENERATE SCIM ALIGNMENT']);
display([]);

% NEED TO DETERMINE CORRESPONDANCE BETWEEN NUM TRIALS & NUM FILES
% if numel(scim_info) ~=  numel(session.data);
%     error('WRONG NUM FILES')
% end

remove_first = 0;
display(['Start alignment ']);
for ij = 1:num_files
   
    fprintf('(scim_align) loading file %g/%g \n',ij,num_files);
    %%% ALIGN
    trial_num_session = ij;
    trial_num_im_session = ij;
    remove_first = func_scim_align_session(trial_num_session,trial_num_im_session,remove_first);
end

disp(['SCIM ALIGNED']);
disp(['--------------------------------------------']);





