clear; close all; clc;
% Same chain as before: bipolar montage, notch where it was needed,
% then the LVFA window, loess trend, and the detrended segment.
% Paths are the new P1-P10 EDF files. Only the four named contacts are read.
% The numbers are the same study table, ordered to these ten files.
% The full MAT files are not loaded: P1.mat is larger than this machine
% can hold inside MATLAB, and P5.mat does not match P5.edf.

root = fileparts(mfilename('fullpath'));

files = {'P1.edf';'P2.edf';'P3.edf';'P4.edf';'P5.edf'; ...
         'P6.edf';'P7.edf';'P8.edf';'P9.edf';'P10.edf'};
types = {'FA';'FA';'PS';'PS';'NA'; 'PS';'PS';'PS';'PS';'FA'};
FS       = [2000, 2000, 1000, 1000, 2000, 2000, 1000, 1000, 500, 500];
Chan_EZ1 = [19,   1,    7,    13,   1,    71,   19,   65,   53,  27];
Chan_EZ2 = [21,   2,    8,    14,   2,    72,   20,   66,   54,  28];
Chan_PZ1 = [23,   26,   18,   6,    56,   26,   2,    16,   78,  10];
Chan_PZ2 = [24,   27,   19,   7,    57,   27,   3,    17,   79,  11];
N = numel(FS);

data_EZ = cell(N,1);
data_PZ = cell(N,1);

for i = 1:N
    fs = FS(i);
    chs = [Chan_EZ1(i), Chan_EZ2(i), Chan_PZ1(i), Chan_PZ2(i)];
    Data = read_edf_data(fullfile(root, 'data', 'raw', sprintf('P%d.edf', i)), chs);

    data_EZ{i}=Data(1,:)-Data(2,:);
    data_PZ{i}=Data(3,:)-Data(4,:);
    if ((i==12 || i==15) || i==11)|| i==19
        data_EZ{i}=bandstop(data_EZ{i},[49.5 50.5],fs);
        data_EZ{i}=bandstop(data_EZ{i},[99.5 100.5],fs);
        data_EZ{i}=bandstop(data_EZ{i},[149.5 150.5],fs);
        data_EZ{i}=bandstop(data_EZ{i},[198 202],fs);
        data_EZ{i}=bandstop(data_EZ{i},[248 252],fs);

        data_PZ{i}=bandstop(data_PZ{i},[49.5 50.5],fs);
        data_PZ{i}=bandstop(data_PZ{i},[99.5 100.5],fs);
        data_PZ{i}=bandstop(data_PZ{i},[149.5 150.5],fs);
        data_PZ{i}=bandstop(data_PZ{i},[198 202],fs);
        data_PZ{i}=bandstop(data_PZ{i},[248 252],fs);
    end

    fprintf('P%d bipolar fs=%g channels=%s samples=%d\n', i, fs, mat2str(chs), size(Data,2));
    fidp = fopen('progress.txt','a'); fprintf(fidp,'loaded P%d\n',i); fclose(fidp);
    clear Data;
end

XLIMs = [619,626;
         622,627;
         245,251;
         148,158;
         108,112;
         189,197;
         478,485;
         647,658;
         595,605;
         922,932];

LVFA_EZ  = cell(N,1);
LVFA_PZ  = cell(N,1);
pre_EZ   = cell(N,1);
pre_PZ   = cell(N,1);
LVFAm_EZ = cell(N,1);
LVFAm_PZ = cell(N,1);
modu_EZ  = cell(N,1);
modu_PZ  = cell(N,1);
stdm_EZ  = cell(N,1);
stdm_PZ  = cell(N,1);
spans_EZ = [0.01, 0.01, 0.05, 0.1, 0.05, 0.05, 0.05, 0.05, 0.05, 0.01];
spans_PZ = [0.01, 0.01, 0.05, 0.1, 0.05, 0.05, 0.05, 0.05, 0.05, 0.01];
lag = 3;

for i = 1:N
    fs      = FS(i);
    XLIM    = XLIMs(i,:);
    range   = fs*(XLIM(1)-lag):fs*(XLIM(2)+lag);
    t_range = range/fs;

    %% EZ data
    pre_EZ{i} = data_EZ{i}(range-40*fs);
    LVFA_EZ{i}= data_EZ{i}(range);
    modu_EZ{i}= smooth(t_range,LVFA_EZ{i},spans_EZ(i),'loess'); modu_EZ{i} = modu_EZ{i}';
    LVFAm_EZ{i}= LVFA_EZ{i}-modu_EZ{i};
    stdm_EZ{i}= std(LVFAm_EZ{i});

    %% PZ data
    pre_PZ{i} = data_PZ{i}(range-40*fs);
    LVFA_PZ{i}= data_PZ{i}(range);
    modu_PZ{i}= smooth(t_range,LVFA_PZ{i},spans_PZ(i),'loess'); modu_PZ{i} = modu_PZ{i}';
    LVFAm_PZ{i}= LVFA_PZ{i}-modu_PZ{i};
    stdm_PZ{i}= std(LVFAm_PZ{i});
    fprintf('P%d window %.0f-%.0f s\n', i, t_range(1), t_range(end));
end

save('data.mat','files','types','FS','N','Chan_EZ1','Chan_EZ2','Chan_PZ1','Chan_PZ2');
save('data.mat','data_EZ','data_PZ','-append');
save('data.mat','LVFA_EZ','LVFA_PZ','LVFAm_EZ','LVFAm_PZ','pre_EZ','pre_PZ','lag','-append');
save('data.mat','modu_EZ','modu_PZ', 'stdm_EZ', 'stdm_PZ', 'spans_PZ','spans_EZ', 'XLIMs','-append');
