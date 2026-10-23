function Data = read_edf_data(edf, channels)
% Data is channels-by-samples, physical units converted to volts.
% channels are 1-based indices after dropping an EDF Annotations channel,
% which is the same row order as the MAT files.
fid = fopen(edf, 'r', 'ieee-le');
if fid < 0
    error('Cannot open %s', edf);
end
cleaner = onCleanup(@() fclose(fid));

main = fread(fid, 256, 'uint8')';
ns = str2double(strtrim(char(main(253:256))));
nrec = str2double(strtrim(char(main(237:244))));
labels = char(fread(fid, [16, ns], 'uint8')');
fseek(fid, 80 * ns, 'cof');
dims = char(fread(fid, [8, ns], 'uint8')');
physmin = read8(fid, ns);
physmax = read8(fid, ns);
digmin = read8(fid, ns);
digmax = read8(fid, ns);
fseek(fid, 80 * ns, 'cof');
spr = read8(fid, ns);
fseek(fid, 32 * ns, 'cof');

is_ann = false(ns, 1);
for k = 1:ns
    if contains(lower(strtrim(labels(k, :))), 'annotation')
        is_ann(k) = true;
    end
end
data_ids = find(~is_ann);
if any(channels < 1) || any(channels > numel(data_ids))
    error('Channel index is outside 1..%d', numel(data_ids));
end
want = data_ids(channels(:));
if any(spr(want) ~= spr(want(1)))
    error('Requested channels do not share one length');
end

nkeep = numel(want);
nsamp = nrec * spr(want(1));
Data = zeros(nkeep, nsamp);
scale = (physmax - physmin) ./ (digmax - digmin);
shift = physmin - scale .* digmin;
row_of = zeros(ns, 1);
row_of(want) = 1:nkeep;

for r = 1:nrec
    at = (r - 1) * spr(want(1));
    for k = 1:ns
        raw = fread(fid, spr(k), 'int16');
        if row_of(k) == 0
            continue
        end
        samples = double(raw).' * scale(k) + shift(k);
        unit = lower(strtrim(dims(k, :)));
        if contains(unit, 'uv')
            samples = samples / 1e6;
        elseif contains(unit, 'mv')
            samples = samples / 1e3;
        end
        Data(row_of(k), at + (1:spr(k))) = samples;
    end
end
end

function v = read8(fid, ns)
raw = fread(fid, [8, ns], 'uint8')';
v = zeros(ns, 1);
for k = 1:ns
    v(k) = str2double(strtrim(char(raw(k, :))));
end
end
