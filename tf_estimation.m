% function [EZtoPZ,PZtoEZ]=tf_estimation(i,EZ,PZ,t,fs,folders,du)
% global i fs folders du;

Pat_iddata1 = iddata(PZ,EZ,1./fs);    % EZ to PZ
Pat_iddata2 = iddata(EZ,PZ,1./fs);    % PZ to EZ

opt = tfestOptions;
opt.InitializeMethod = 'all';
opt.EnforceStability = true;

%% search transfer function with peak fitting
Nn = 11;
per1 = zeros(Nn,Nn); 
per2 = zeros(Nn,Nn);
for nz = 0:Nn-1
    for np = nz:Nn-1
        try
            sys_tf1 = tfest(Pat_iddata1,np,nz,opt);
            per1(np+1,nz+1) = sys_tf1.Report.Fit.FitPercent;
        catch
            per1(np+1,nz+1) = NaN;
        end
        try
            sys_tf2 = tfest(Pat_iddata2,np,nz,opt);
            per2(np+1,nz+1) = sys_tf2.Report.Fit.FitPercent;
        catch
            per2(np+1,nz+1) = NaN;
        end
    end
end

%% for EZ to PZ
figure();   imagesc(per1);  %imagesc((per1>40).*per1);
peak1  = max(per1(:), [], 'omitnan');
[np,nz]= find(per1==peak1, 1); np1 = np-1;  nz1 = nz-1;

sys_tf1= tfest(Pat_iddata1,np1,nz1,opt)
a1     = compare(Pat_iddata1,sys_tf1);
figure('position',[600 100 600 200],'Name','EZ to PZ'); 
plot(t, Pat_iddata1.outputData,'linewidth',2); hold on;
plot(t, a1.outputData,'r-','linewidth',2); xlim(du); box off;
xlabel('Time (second)','interpreter','latex','fontsize',fontsize);
set(gca,'fontsize',fontsize);
title(['Estimating non-$d$H from $d$H'],'interpreter','latex','fontsize',25,'fontname','arial');
%savefig(['./fig3S_subfigs/fig2S_EZtoPZ.fig']);
%saveas(gcf,[folder,'/fig3S_EZtoPZ.pdf']);

EZtoPZ.sys_tf   = sys_tf1;
EZtoPZ.iddata   = Pat_iddata1;
EZtoPZ.percents = per1;
EZtoPZ.peak     = peak1;
EZtoPZ.np       = np1;
EZtoPZ.nz       = nz1;
EZtoPZ.t        = t;

%% for PZ to EZ
figure();   imagesc(per2);  %imagesc((per2>20).*per2);
peak2  = max(per2(:), [], 'omitnan');
[np,nz]= find(per2==peak2, 1); np2 = np-1;  nz2 = nz-1;

sys_tf2= tfest(Pat_iddata2,np2,nz2,opt)
a2     = compare(Pat_iddata2,sys_tf2);
figure('position',[600 100 600 200],'Name','PZ to EZ'); 
plot(t, Pat_iddata2.outputData, 'linewidth',2); hold on
plot(t, a2.outputData,'r-','linewidth',2); xlim(du); box off;
xlabel('Time (second)','interpreter','latex','fontsize',fontsize);
set(gca,'fontsize',fontsize);
title(['Estimating $d$H from non-$d$H'],'interpreter','latex','fontsize',25,'fontname','arial');
%savefig(['./fig3S_subfigs/fig3S_PZtoEZ.fig']);
%saveas(gcf,[folder,'/fig3S_PZtoEZ.pdf']);

PZtoEZ.sys_tf   = sys_tf2;
PZtoEZ.iddata   = Pat_iddata2;
PZtoEZ.percents = per2;
PZtoEZ.peak     = peak2;
PZtoEZ.np       = np2;
PZtoEZ.nz       = nz2;
PZtoEZ.t        = t;

%save('fig5_prop.mat','EZtoPZ','PZtoEZ');

%end