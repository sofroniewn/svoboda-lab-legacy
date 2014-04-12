
% analysis works with two objects 
% session_ca and session_bv

global session_bv;
global session_ca;

session_bv.data_names
scim_frames = logical(session_bv.data_mat(24,:));
bv_ca_data = session_bv.data_mat(:,scim_frames);


figure(1);
clf(1);
hold on 
plot(session_ca.time,30*nanmean(session_ca.dff(:,:),1))
%plot(session_ca.time,bv_ca_data(22,:),'k')
%plot(session_ca.time,bv_ca_data(3,:),'k')
plot(session_ca.time,bv_ca_data(22,:),'r')
plot(session_ca.time,bv_ca_data(3,:),'k')
