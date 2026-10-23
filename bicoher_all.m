range_i = 1:N;

nfft = 2^9;
for ni = 1:numel(range_i)
    i = range_i(ni);
    
    fs = FS(i);     fmax = 200;%.*sqrt(fs/2000);
    XLIM    = XLIMs(i,:);
    range   = fs*(XLIM(1)-lag):fs*(XLIM(2)+lag);
    t_range = range/fs;
    
    srange  = lag*fs:(length(range)-lag*fs);
    EZ = LVFAm_EZ{i}(srange); EZ = EZ';
    PZ = LVFAm_PZ{i}(srange); PZ = PZ';
    EZ = EZ(1:fix(length(EZ)/(nfft/2))*nfft/2);
    PZ = PZ(1:fix(length(EZ)/(nfft/2))*nfft/2);

%     info_EZ = bicoher(EZ,nfft,5,nfft,50,fs,fmax,folders{i},'/EZ');
%     info_PZ = bicoher(PZ,nfft,5,nfft,50,fs,fmax,folders{i},'/PZ');
    
    info_EZ = bicoher(EZ,nfft,5,nfft,50,fs,fmax,'./figs','/EZ',i);
    info_PZ = bicoher(PZ,nfft,5,nfft,50,fs,fmax,'./figs','/PZ',i);
    save(['./figs/bic_Pat_',num2str(i),'.mat'],'info_EZ','info_PZ');
end