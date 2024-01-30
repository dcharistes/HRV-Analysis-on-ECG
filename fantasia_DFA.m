%Dimitrios Bismpas 2037
%Dimitrios Charistes 2031
%Ομάδα χρηστών 16

%%Experiment segment
function fantasia_DFA
clc;
folderPath = 'ecg_dataset';

fileList = dir(fullfile(folderPath, '*.txt'));

DATA = cell(1, numel(fileList));

for k = 1:numel(fileList)
    filePath = fullfile(folderPath, fileList(k).name);
    DATA{k} = load(filePath);
end

for k = 1:numel(fileList)
    figure(k)
    [d,a,slope,N]=DFA_call_p(DATA{k});grid on;
    disp('----')
    disp("ECG No.: "+k)
    disp("dimension= "+d);
    disp("average slope of the whole graph is: "+a);
    for j=1:N-1
    disp("slope("+j+"): "+slope(j,1))
    end
end

end