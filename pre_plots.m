for i = 1:N
    fs      = FS(i);
    XLIM    = XLIMs(i,:);
    range   = fs*(XLIM(1)-lag):fs*(XLIM(2)+lag);
    t_range = range/fs;
    
    %% plots
    figure()
    subplot(2,1,1)
    plot(t_range,LVFA_EZ{i},t_range,modu_EZ{i},'k--'); hold on;
    plot([XLIM(1),XLIM(1)],[min(LVFA_EZ{i}),max(LVFA_EZ{i})],'r--');
    plot([XLIM(2),XLIM(2)],[min(LVFA_EZ{i}),max(LVFA_EZ{i})],'r--');
    title(['Patient ',int2str(i), ': EZ'], 'interpreter','latex');
    xlim(XLIM+[-lag,lag])
    set(gca,'YDir','normal','fontsize',20);
    subplot(2,1,2)
    plot(t_range,LVFA_PZ{i},t_range,modu_PZ{i},'k--');  hold on;
    plot([XLIM(1),XLIM(1)],[min(LVFA_PZ{i}),max(LVFA_PZ{i})],'r--');
    plot([XLIM(2),XLIM(2)],[min(LVFA_PZ{i}),max(LVFA_PZ{i})],'r--');
    xlim(XLIM+[-lag,lag])
    xlabel('Time (second)','interpreter','latex');
    title(['Patient ',int2str(i), ': PZ'],'interpreter','latex');
    set(gca,'fontsize',20);
    savefig(['./figs/ts_origin_Pat_',int2str(i),'.fig']);
    saveas(gcf,['./figs/ts_origin_Pat_',int2str(i),'.pdf']);
    close all
    
    figure()
    subplot(2,1,1)
    plot(t_range,LVFAm_EZ{i}); hold on
    plot(t_range,stdm_EZ{i}.*ones(size(t_range))./2,'g--');
    plot(t_range,-stdm_EZ{i}.*ones(size(t_range))./2,'g--');
    plot([XLIM(1),XLIM(1)],[min(LVFAm_EZ{i}),max(LVFAm_EZ{i})],'r--');
    plot([XLIM(2),XLIM(2)],[min(LVFAm_EZ{i}),max(LVFAm_EZ{i})],'r--');
    title(['Patient ',int2str(i), ': EZ'], 'interpreter','latex');
    xlim(XLIM+[-lag,lag])
    set(gca,'YDir','normal','fontsize',20);
    subplot(2,1,2)
    plot(t_range,LVFAm_PZ{i}); hold on
    plot(t_range,stdm_PZ{i}.*ones(size(t_range))./2,'g--');
    plot(t_range,-stdm_PZ{i}.*ones(size(t_range))./2,'g--');
    plot([XLIM(1),XLIM(1)],[min(LVFAm_PZ{i}),max(LVFAm_PZ{i})],'r--');
    plot([XLIM(2),XLIM(2)],[min(LVFAm_PZ{i}),max(LVFAm_PZ{i})],'r--');
    xlim(XLIM+[-lag,lag])
    xlabel('Time (second)','interpreter','latex');
    title(['Patient ',int2str(i), ': PZ'],'interpreter','latex');
    set(gca,'fontsize',20);
    savefig(['./figs/ts_smooth_Pat_',int2str(i),'.fig']);
    saveas(gcf,['./figs/ts_smooth_Pat_',int2str(i),'.pdf']);
    close all
    
    figure()
    subplot(2,1,1)
    [base_EZ,base] = pwelch(pre_EZ{i},2^10,2^9,2^10,fs);
    plot(base,pow2db(fs.*base_EZ),'Displayname','base EZ'); hold on
    [pxx,f]=pwelch(LVFA_EZ{i}(lag*fs:(end-lag*fs)),2^10,2^9,2^10,fs);
    plot(f,pow2db(pxx.*fs),'Displayname',types{i});
    xlim([0,150]);
    xlabel('Frequency $f$ (Hz)','interpreter','latex');
    ylabel('$P$/$f$ (dB/Hz)','interpreter','latex');
    legend show
    title(['Patient ',int2str(i), ': Baseline vs. ',types{i},' EZ'],'interpreter','latex');
    set(gca,'fontsize',20);
    subplot(2,1,2)
    [base_PZ,base] = pwelch(pre_PZ{i},2^10,2^9,2^10,fs);
    plot(base,pow2db(fs.*base_PZ),'Displayname','base EZ'); hold on
    [pxx,f]=pwelch(LVFA_PZ{i}(lag*fs:(end-lag*fs)),2^10,2^9,2^10,fs);
    plot(f,pow2db(pxx.*fs),'Displayname',types{i});
    xlim([0,150]);
    xlabel('Frequency $f$ (Hz)','interpreter','latex');
    ylabel('$P$/$f$ (dB/Hz)','interpreter','latex');
    legend show
    title(['Patient ',int2str(i), ': Baseline vs. ',types{i},' PZ'],'interpreter','latex');
    set(gca,'fontsize',20);
    savefig(['./figs/pwd_Pat_',int2str(i),'.fig']);
    saveas(gcf,['./figs/pwd_Pat_',int2str(i),'.pdf']);
    close all
end