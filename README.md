# Detrended Fluctuation Analysis (DFA) Implementation

## Overview
This project implements Detrended Fluctuation Analysis (DFA), a method for scaling analysis in non-stationary time series data. The project includes pre-processing ECG signals, removing noise, and analyzing fractal properties using DFA.

## Features
- **Signal Pre-processing**:
  - Removes powerline interference using a notch filter.
  - Smooths the signal with wavelet decomposition.
- **DFA Implementation**:
  - Computes scaling exponents to detect long-range correlations.
  - Provides visualization for easier interpretation of results.
- **Visualization**:
  - Plots raw, filtered, and detrended data.
  - Generates DFA log-log plots to analyze scaling properties.

## Project Files
1. **`DFA.m`**:
   - Contains the DFA algorithm.
   - **Inputs**:
     - `DATA`: Input time-series data.
     - `win_length`: Window length for segmenting the data.
     - `order`: Polynomial order for detrending.
   - **Outputs**:
     - `sum1`: Fluctuation measure.
     - `y`: Integrated signal.
     - `y_n`: Polynomial-detrended signal.
     - `N1`: Effective data length.

2. **`DFA_call_p.m`**:
   - Performs pre-processing and calls the DFA function.
   - Steps:
     1. Removes powerline noise from the ECG signal.
     2. Decomposes the signal using wavelets and smooths it.
     3. Runs DFA for various window lengths and visualizes results.
   - Outputs: Visualized steps of the processing and calculated DFA slopes.

## Prerequisites
- **MATLAB or compatible environment.**
- **Required Toolboxes**:
  - Signal Processing Toolbox.
  - Wavelet Toolbox.

## Outputs
- **Filtered Signal**: Displays the denoised ECG signal.
- **DFA Results**:
  - Log-log plot showing fluctuation function ($F(n)$) vs. window size ( $n ).
  - Slope of the log-log plot ($alpha$) representing scaling properties.
  - Fractal dimension ( $D$ ) derived as ( $D$ = $3$ - $alpha$ ).

## Key Visualizations
1. **Raw ECG Signal**: Plotted before filtering.
2. **Filtered Signal**: After noise removal and smoothing.
3. **DFA Signal Fitting**:
   - Integrated series ( $y(n)$ ) and detrended signal ( $y_n(n)$ ).
4. **Log-Log Plot**:
   - Displays the relationship between ( $F(n)$ ) and ( $n$ ) with computed slopes.

## References
- Peng, C.-K., et al. *"Quantification of scaling exponents and crossover phenomena in nonstationary heartbeat time series"*, Physical Review E, 1995.

## Author
[Dimitris Charistes, Dimitris Bismpas]  
