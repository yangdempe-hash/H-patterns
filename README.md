# H-patterns

Nextflow pipeline for ten stereo-EEG seizures. The steps are the MATLAB scripts from the study.

1. `generate_data.m` — four contacts, bipolar montage, one window, loess
2. `pre_plots.m` — trace and spectrum
3. `TFM_cwt.m` — Morlet map, using `Spectrog.m`
4. `phlg_decouple.m` — below and above 100 Hz
5. `bicoher_all.m` — bicoherence
6. `prop_all.m` — transfer function both ways, using `tf_estimation.m`

Raw EDF and MAT files stay in `data/` and are not in this repository. This run is ten seizures. It is not the published cohort.

```bash
NXF_OFFLINE=true nextflow run main.nf -offline -resume
```

The MATLAB program is set in `nextflow.config`.
