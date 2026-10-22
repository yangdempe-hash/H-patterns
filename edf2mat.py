import mne
from scipy.io import savemat

raw = mne.io.read_raw_edf('./data/raw/example.edf', encoding='latin1')
# raw.pick_channels(['EEG A1-Ref'])
data = raw.get_data()


savemat('./results/example.mat', {'Data': data})