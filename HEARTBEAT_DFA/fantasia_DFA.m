function fantasia_DFA
fileNames = {'Y1.txt', 'Y2.txt', 'Y3.txt', 'Y4.txt', 'Y5.txt', 'O1.txt', 'O2.txt', 'O3.txt', 'O4.txt', 'O5.txt'};
% Initialize a cell array to store the loaded data
DATA = cell(1, numel(fileNames));

% Load data from each file and store it in the cell array
for k = 1:numel(fileNames)
    DATA{k} = load(fileNames{k});
   
end


for k = 1:numel(fileNames)
    figure(k)
     DFA_TEST(DATA{k});
end

end


