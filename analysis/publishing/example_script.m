%% TEST fig 1
% text aaa
figure;
set(gcf,'Position',[0 551 1441 246])
subplot(1,2,1)
plot([1:10],[1:10],'b')
subplot(1,2,2)
plot(-[1:10],[1:10],'g')

%% TEST fig 2
% text bbb
figure;
plot([1:10],-[1:10],'r')