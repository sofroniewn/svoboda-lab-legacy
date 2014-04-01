
global session_bv;
global session_ca;


session_bv.data_names
bv_ca_data = session_bv.data_mat(:,logical(session_bv.data_mat(24,:)));


figure(1);
clf(1);
hold on 
plot(session_ca.time,session_ca.dff(:,:))
plot(session_ca.time,bv_ca_data(22,:),'r')
plot(session_ca.time,bv_ca_data(3,:),'k')