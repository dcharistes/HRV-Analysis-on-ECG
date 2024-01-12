%%%DFA_final
function DFA_final
clc;
DATA=load("O1.txt");
disp("ECG Analysis of one signal")
[d,a,slope,N]=DFA_call_p(DATA);
disp("dimension= "+d);disp("average slope of the whole graph is: "+a);
for j=1:N-1 
    disp("slope("+j+"): "+slope(j,1))
end

end