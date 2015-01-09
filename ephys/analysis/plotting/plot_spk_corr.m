function plot_spk_corr(fig_props,SPK_CORR)

% create figure if properties specified
if ~isempty(fig_props)
    figure(fig_props.id)
    clf(fig_props.id)
    set(gcf,'Position',fig_props.position)
end
cla

if iscell(SPK_CORR)
    gap = [0.01 0.01];
    marg_h = [0.01 0.01];
    marg_w = [0.01 0.01];
    num_plots_h = size(SPK_CORR,2);
    num_plots_w = size(SPK_CORR,1);
    full_mod = zeros(num_plots_h,num_plots_w);
    ind = 1;
    for ij = 1:size(SPK_CORR,1)
        for ik = 1:size(SPK_CORR,2)
            subtightplot(num_plots_h,num_plots_w,ind,gap,marg_h,marg_w)
			hold on
            phandle = bar(1000*SPK_CORR{ij,ik}.edges,SPK_CORR{ij,ik}.dist,'histc');
            set(phandle,'FaceColor','k')
            set(phandle,'EdgeColor','k')
            
            plot(1000*[SPK_CORR{ij,ik}.edges(1) SPK_CORR{ij,ik}.edges(end)],[SPK_CORR{ij,ik}.mean SPK_CORR{ij,ik}.mean],'r','LineWidth',2)
                        text(.75,.75,num2str(SPK_CORR{ij,ik}.num_spikes_range),'Units','Normalized','Color','r')

            %xlabel('Time (ms)');
            %ylabel('Fraction of events');
            xlim([-100 100])
            set(gca,'ytick',[])
            set(gca,'xtick',[])
            ymax = max(SPK_CORR{ij,ik}.dist);
            if ymax == 0 || isnan(ymax) || isempty(ymax)
                ymax = 1;
            end
            ylim([0 ymax]);
            h = plot([0 0],[0 ymax],'r','LineWidth',1,'LineStyle','--');
            ind = ind+1;
            if SPK_CORR{ij,ik}.num_spikes_range > 200
                full_mod(ij,ik) = SPK_CORR{ij,ik}.mod;
            else
                full_mod(ij,ik) = 0;
            end
        end
    end
    figure
    hold on
    h = imagesc(full_mod,[-2 2])
    set(h, 'AlphaData', ~isnan(full_mod))
    set(gca,'ydir','rev')
    % for ij = 1:size(SPK_CORR,1)
    %     for ik = 1:size(SPK_CORR,2)
    %         text(ij,ik,num2str(SPK_CORR{ij,ik}.num_spikes_range))
    %     end
    % end

else
    hold on
    phandle = bar(1000*SPK_CORR.edges,SPK_CORR.dist,'histc');
    set(phandle,'FaceColor','k')
    set(phandle,'EdgeColor','k')
    
    plot(1000*[SPK_CORR.edges(1) SPK_CORR.edges(end)],[SPK_CORR.mean SPK_CORR.mean],'r','LineWidth',2)

    
                set(gca,'ytick',[])

    xlabel('Time between events (milliseconds)');
    ylabel('Fraction of events');
    xlim([-100 100])
    
    ymax = max(SPK_CORR.dist);
    if ymax == 0 || isnan(ymax) || isempty(ymax)
        ymax = 1;
    end
    ylim([0 ymax]);
    h = plot([0 0],[0 ymax],'r','LineWidth',1,'LineStyle','--');
end