function y = persistence_diagram(x,thresh,max_min,plot_on)
[maxima, max_loc] = findpeaks(x);
[minima, min_loc] = findpeaks(-x);
minima = -minima;


 if max_loc(1) < min_loc(1)
          minima = [x(1);minima];
          min_loc = [1;min_loc];
 else
          maxima = [x(1);maxima];
          max_loc = [1;max_loc];
 end

 if max_loc(end) < min_loc(end)
          maxima = [maxima;x(end)];
          max_loc = [max_loc;length(x)];
 else
          minima = [minima;x(end)];
          min_loc = [min_loc;length(x)];
 end

% if length(maxima) > length(minima)
%     if max_loc(1) < min_loc(1)
%         minima = [x(1);minima];
%         min_loc = [1;min_loc];
%     else
%         minima = [minima;x(end)];
%         min_loc = [min_loc;length(x)];
%     end
% elseif length(maxima) < length(minima)
%     if max_loc(1) > min_loc(1)
%         maxima = [x(1);maxima];
%         max_loc = [1;max_loc];
%     else
%         maxima = [maxima;x(end)];
%         max_loc = [max_loc;length(x)];
%     end
% end

critical_pts = [[maxima max_loc ones(length(maxima),1)];[minima min_loc zeros(length(minima),1)]];

critical_pts = sortrows(critical_pts);

P_D = zeros(length(minima),4);

R = [];
j = 1;
for i = 1:length(critical_pts)
    % for birth label new component by minima
    if critical_pts(i,3) == 0
    R = [R; critical_pts(i,1:2)];
    R = sortrows(R,2);
    % for death find two components merging
    else
        C_r_ind = find(R(:,2)>critical_pts(i,2),1);
        C_l_ind = find(R(:,2)<critical_pts(i,2),1);
        if isempty(C_r_ind) == 1
            c_ind = size(R,1);
        elseif isempty(C_l_ind) == 1
            c_ind = 1;
        else
            c_ind = size(R,1);
        end

        P_D(j,:) = [R(c_ind,:) critical_pts(i,1:2)];
        R(c_ind,:) = [];
        j = j+1;

        % C_r_ind = find(R(:,2)>critical_pts(i,2),1);
        % if isempty(C_r_ind) == 1
        %     P_D(j,:) = [R(end,:) critical_pts(i,1:2)];
        %     R(end,:) = [];
        %     j = j+1;
        % elseif C_r_ind == 1
        %         P_D(j,:) = [R(C_r_ind,:) critical_pts(i,1:2)];
        %         R(C_r_ind,:) = [];
        %         j = j+1;   
        % else
        %     if R(C_r_ind,1) > R(C_r_ind-1,1)
        %         P_D(j,:) = [R(C_r_ind,:) critical_pts(i,1:2)];
        %         R(C_r_ind,:) = [];
        %         j = j+1;
        %     else
        %         P_D(j,:) = [R(C_r_ind-1,:) critical_pts(i,1:2)];
        %         R(C_r_ind-1,:) = [];
        %         j = j+1;
        %     end
        % end
    end
end

%P_D

lrg_pks = P_D;
    length(lrg_pks(:,2));
%lrg_pks(lrg_pks(:,1) > 11,:) = [];
%lrg_pks(lrg_pks(:,3) < 11,:) = [];
lrg_pks((lrg_pks(:,3) - lrg_pks(:,1)) < thresh,:) = []; 
    length(lrg_pks(:,2))
    if max_min == 1
        y = lrg_pks(:,4);
    else
        y = lrg_pks(:,2);
    end
    
if plot_on == 1
figure(111)
clf(111)
hold on
plot(x,'r','LineWidth',2)
plot(min_loc,minima,'Marker','.','Markeredgecolor','g','LineStyle','none','MarkerSize',15)
plot(max_loc,maxima,'Marker','.','Markeredgecolor','b','LineStyle','none','MarkerSize',15)
plot(lrg_pks(:,4),lrg_pks(:,3),'Marker','.','Markeredgecolor','c','LineStyle','none','MarkerSize',25)
plot(lrg_pks(:,2),lrg_pks(:,1),'Marker','.','Markeredgecolor','m','LineStyle','none','MarkerSize',25)

figure(112)
clf(112)
hold on
plot([-200:.1:200],[-200:.1:200],'r','LineWidth',2,'LineStyle','-')
%plot(11*ones(4001,1),[-200:.1:200],'g','LineWidth',2,'LineStyle','--')
%plot([-200:.1:200],11*ones(4001,1),'g','LineWidth',2,'LineStyle','--')
plot([-200:.1:200],thresh*ones(1,4001)+[-200:.1:200],'r','LineWidth',2,'LineStyle','--')
plot(P_D(:,1),P_D(:,3),'Marker','.','Markeredgecolor','b','LineStyle','none','MarkerSize',25)
plot(lrg_pks(:,1),lrg_pks(:,3),'Marker','.','Markeredgecolor','g','LineStyle','none','MarkerSize',25)
axis equal
xlabel('Births','FontSize',12)
ylabel('Deaths','FontSize',12)
xlim([0 ceil(max(maxima)/5)*5])
ylim([0 ceil(max(maxima)/5)*5])

% figure(3)
% clf(3)
% hold on
% plot(x,'r','LineWidth',2)
% for i = 1:length(minima)
%     c = rand(1,3);
%     plot(P_D(i,2),P_D(i,1),'Marker','.','Markeredgecolor',c,'LineStyle','none','MarkerSize',35)
%     plot(P_D(i,4),P_D(i,3),'Marker','.','Markeredgecolor',c,'LineStyle','none','MarkerSize',35)
% end
else
end