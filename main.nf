/*
 * The study chain, on ten seizures.
 * generate_data: bipolar, notch step, LVFA window, loess.
 * pre_plots: trace and spectrum.
 * TFM_cwt: Morlet map, Spectrog.m, morlet parameter 100.
 * phlg_decouple: below 100 Hz and above 100 Hz.
 * bicoher_all: bicoherence.
 * prop_all: transfer function, tf_estimation.m.
 *
 * Raw EDF and the full MAT files stay in data/ and are gitignored.
 */

nextflow.enable.dsl = 2

params.only = ''

process generate_data {
    publishDir "${params.out}", mode: 'copy'
    output:
        path 'data.mat'
    script:
    """
    ${params.matlab} -batch "set(0,'DefaultFigureVisible','off'); addpath('${projectDir}'); generate_data"
    """
}

process pre_plots {
    publishDir "${params.out}", mode: 'copy'
    input:
        path cohort
    output:
        path 'figs'
    script:
    """
    mkdir -p figs
    ${params.matlab} -batch "set(0,'DefaultFigureVisible','off'); addpath('${projectDir}'); load('data.mat'); pre_plots"
    """
}

process TFM_cwt {
    publishDir "${params.out}", mode: 'copy'
    input:
        path cohort
    output:
        path 'figs'
    script:
    """
    mkdir -p figs
    ${params.matlab} -batch "set(0,'DefaultFigureVisible','off'); addpath('${projectDir}'); load('data.mat'); TFM_cwt"
    """
}

process phlg_decouple {
    publishDir "${params.out}", mode: 'copy'
    input:
        path cohort
    output:
        path 'figs'
    script:
    """
    mkdir -p figs
    ${params.matlab} -batch "set(0,'DefaultFigureVisible','off'); addpath('${projectDir}'); load('data.mat'); phlg_decouple"
    """
}

process bicoher_all {
    publishDir "${params.out}", mode: 'copy'
    input:
        path cohort
    output:
        path 'figs'
    script:
    """
    mkdir -p figs
    ${params.matlab} -batch "set(0,'DefaultFigureVisible','off'); addpath('${projectDir}'); load('data.mat'); bicoher_all"
    """
}

process prop_all {
    publishDir "${params.out}", mode: 'copy'
    input:
        path cohort
    output:
        path 'figs'
    script:
    """
    mkdir -p figs
    ${params.matlab} -batch "set(0,'DefaultFigureVisible','off'); addpath('${projectDir}'); load('data.mat'); prop_all"
    """
}

workflow {
    cohort = generate_data()
    pre_plots(cohort)
    TFM_cwt(cohort)
    phlg_decouple(cohort)
    bicoher_all(cohort)
    prop_all(cohort)
}
