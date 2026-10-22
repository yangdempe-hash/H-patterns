/*
 * Practice only. take H-patterns as an exammple, local executor.
 * This is for the stereo-EEG analysis.
 */
 
process receive {
    publishDir 'results', mode: 'copy'
    output:
    path '01_received.txt'
    script:
    """
    echo "From the hospital: EDF, discharge times, electrod sites,clinical metadata." > 01_received.txt
    echo "These files stay in data/ and are not in the repository." >> 01_received.txt
    """
}

process organise {
    publishDir 'results', mode: 'copy'
    input:
    path received
    output:
    path '02_organised.txt'
    script:
    """
    echo "one folder per patient. Python and MNE, edf2mat.py, into MATLAB." > 02_organised.txt
    echo "Input: ${received}" >>02_organised.txt
    """
}

process standardise {
    publishDir 'results', mode: 'copy'
    input:
    path organised
    output:
    path '03_standardised.txt'
    script:
    """
    echo "Bipolar montage. -10 s to +100 s. one wavelet for every seizure. TFM_cwt.m." > 03_standardised.txt
    echo "Input: ${organised}" >> 03_standardised.txt
    """
}

process pattern {
    publishDir 'results', mode: 'copy'
    input:
    path standardised
    output:
    path '04_pattern.txt'
    script:
    """
    echo "H-pattern: evenly spaced bands. dH-pattern: band count above the upper quartile." > 04_pattern.txt
    echo "Input: ${standardised}" >> 04_pattern.txt
    """
}

process check {
    publishDir 'results', mode: 'copy'
    input:
    path named
    output:
    path '05_checked.txt'
    script:
    """
    echo "Same settings for every seizure, then the surgical outcome." > 05_checked.txt
    echo "Input: ${named}" >> 05_checked.txt
    """
}

process share {
    publishDir 'results', mode: 'copy'
    input:
    path checked
    output:
    path '06_shared.txt'
    script:
    """
    echo "Paper and code can be public. Raw recordings stay controlled." > 06_shared.txt
    echo "Input: ${checked}" >> 06_shared.txt
    """
}

workflow {
    receive() | organise | standardise | pattern | check | share
}
