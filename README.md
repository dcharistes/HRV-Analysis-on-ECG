#ECG Analysis with DFA

desc.: 
Unmerged functions:
DFA.m - Just the code of the DFA algorithm to analyze a signal (ECG signal). 
DFA_call.m - The argument of the function loads a signal. 
First step->Pre-processing
Second step-> Calling DFA.m to analyze the filtered signal and then plot the needed graphs. You can just run it in TEST.m

Merged functions - final files:
DFA_final.m: Runs only the function DFA_final. In this function, the DATA of one signal is loaded. Inside this function, the function DFA_call_F (line 4) is called to analyze the signal loaded above, using the DFA algorithm (DFA algorithm function is called inside DFA_call_F). 
All the functions (DFA_call_F, DFA) are merged-written inside this.m file (lines 8 and 86 accordingly)
fantasia_DFA: Here we load a folder containing all the signals(.txt files) we must process. Then for each signal (.txt file), we call the DFA_call_fant to analyze the signal and plot the corresponding graphs. All the functions called, are written inside this .m file

TEST.m- Use it if you want to test the functions DFA_call and DFA 

text files Y1.txt used for testing the algorithm's integrity
