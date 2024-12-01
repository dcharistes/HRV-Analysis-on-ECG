# ECG Analysis with DFA-files desc.

## Functions
DFA.m - Just the code of the DFA algorithm part repeated for a given window size and computes the fluctuation value to analyze a signal (ECG signal). 
DFA_call_p.m - The argument of the function loads a signal. This function pre-processes the signal and then analyzes it by calling the DFA function for different window sizes. 

## Execution files
DFA_final.m: In this function, the DATA of one signal (e.g. O1.txt) is loaded and analyzed by calling DFA_call_p. Then the function prints the Hurst exponents of the final graph.
fantasia_DFA: This function is the experiment. It loads a folder containing all the signals (.txt files) we must process. Then for each signal (.txt file), we call the DFA_call_p to analyze it and plot the corresponding figures. 

text file O1.txt is used to test the algorithm's integrity.
