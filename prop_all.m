range_i = 1:N;

duration = [620, 622;
    624, 626;
    246, 248;
    156, 158;
    108, 110;     % P5, first two seconds of the marked interval
    192, 194;
    480, 482;
    650, 652;
    596, 598;
    923, 925];
folder   = './figs';

E2P_peak = zeros(N,1);
P2E_peak = zeros(N,1);
fontsize = 20;

for ni = 1:numel(range_i)
    i = range_i(ni);
    
    fs = FS(i);   
    XLIM    = XLIMs(i,:);
    range   = fs*(XLIM(1)-lag):fs*(XLIM(2)+lag);
    t_range = range/fs;
    du = duration(i,:);
    
    srange  = du(1)*fs-range(1):du(2)*fs-range(1);
    EZ = LVFAm_EZ{i}(srange); EZ = EZ';
    PZ = LVFAm_PZ{i}(srange); PZ = PZ';
    t  = t_range(srange);     t  = t';
    
    tf_estimation
    save([folder,'/prop_Pat_',num2str(i),'.mat'],'EZtoPZ','PZtoEZ');
    saveas(findobj('Name','EZ to PZ'), [folder,'/prop_EZtoPZ_Pat_',num2str(i),'.pdf']);
    saveas(findobj('Name','PZ to EZ'), [folder,'/prop_PZtoEZ_Pat_',num2str(i),'.pdf']);
    close all
    
    E2P_peak(i) = EZtoPZ.peak;
    P2E_peak(i) = PZtoEZ.peak;
end

save([folder,'/prop_all.mat'],'E2P_peak','P2E_peak','duration');
% figure('position',[600 100 600 200],'Name','peak');
% plot((1:N)', E2P_peak, '-o', 'linewidth',1); hold on;
% plot((1:N)', P2E_peak,' r-*','linewidth',1);
% xlabel('Patient #','interpreter','latex');
% title('Estimating percentage');
% set(gca,'fontsize',20);

