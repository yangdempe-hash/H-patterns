# Practice: Git and a two-step Nextflow pipeline

Toy files only. Not the stereo-EEG study.

- `data/raw/` is the file I received.
- `organise` makes one small output per file.
- `standardise` applies one fixed setting and writes `results/`.
- `work/` is Nextflow's cache and is not committed.

The cache in work/ and the copied files in results/ are recreated by the pipeline. They are not part of the repository.
