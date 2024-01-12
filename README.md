# ECG Analysis with DFA - files info-desc

functions:
DFA.m - Just the code of the DFA algorithm to analyze a signal (ECG signal). 
DFA_call_p.m - The argument of the function loads a signal. This function pre-processes the signal and then analyzes it by calling the DFA function. 

Run files:
DFA_final.m: In this function, the DATA of one signal (e.g. O1.txt) is loaded and analyzed by calling DFA_call_p. 
fantasia_DFA: Here we load a folder containing all the signals (.txt files) we must process. Then for each signal (.txt file), we call the DFA_call_p to analyze it and plot the corresponding graphs. 

text file O1.txt used for testing the algorithm's integrity.
