
f_thres = 100;
for i = 1:N
    fs      = FS(i);
    XLIM    = XLIMs(i,:);
    range   = fs*(XLIM(1)-lag):fs*(XLIM(2)+lag);
    t_range = range/fs;
    
    x1 = XLIM(1);
    x2 = XLIM(2);
    
    gamma_EZ = highpass(LVFAm_EZ{i}, f_thres, fs);
    low_EZ   = lowpass(LVFAm_EZ{i},  f_thres, fs);
    
    figure('position',[600 100 600 350]);
    subplot(2,1,1)
    plot(t_range,LVFAm_EZ{i}); hold on
    xlim([x1,x2]);
    box off
    title(['Patient ',int2str(i), ': EZ'], 'interpreter','latex');
    set(gca,'fontsize',15);
    %ylim([-8,8].*1e-4);
    %set(gca,'xtick',[],'ytick',[],'fontsize',20);
    %axis off
    subplot(2,1,2)
    plot(t_range,gamma_EZ); hold on;
    box off
    xlim([x1,x2]);
    %ylim([-2,2].*1e-4);
    xlabel('time (s)','interpreter','latex');
    set(gca,'fontsize',15);
    %set(gca,'xtick',[],'ytick',[],'fontsize',20);
    %axis off
    savefig(['./figs','/EZ_phlg_Pat_',num2str(i),'.fig']);
    saveas(gcf,['./figs','/EZ_phlg_Pat_',num2str(i),'.pdf']);
    close all;
    
    
    gamma_PZ = highpass(LVFAm_PZ{i}, 100, fs);
    low_PZ   = lowpass(LVFAm_PZ{i}, 100, fs);
    
    figure('position',[600 100 600 350]);
    subplot(2,1,1)
    plot(t_range,LVFAm_PZ{i}); hold on
    xlim([x1,x2]);
    box off
    title(['Patient ',int2str(i), ': EZ'], 'interpreter','latex');
    set(gca,'fontsize',15);
    %ylim([-8,8].*1e-4);
    %set(gca,'xtick',[],'ytick',[],'fontsize',20);
    %axis off
    subplot(2,1,2)
    plot(t_range,gamma_PZ); hold on;
    box off
    xlim([x1,x2]);
    %ylim([-2,2].*1e-4);
    xlabel('Time (s)','interpreter','latex');
    set(gca,'fontsize',15);
    %set(gca,'xtick',[],'ytick',[],'fontsize',20);
    %axis off
    savefig(['./figs','/PZ_phlg_Pat_',num2str(i),'.fig']);
    saveas(gcf,['./figs','/PZ_phlg_Pat_',num2str(i),'.pdf']);
    close all;
end