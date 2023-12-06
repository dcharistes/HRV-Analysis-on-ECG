function fantasia_DFA
folderPath = 'DATASET';

% Get a list of all text files in the folder
fileList = dir(fullfile(folderPath, '*.txt'));

% Initialize a cell array to store the loaded data
DATA = cell(1, numel(fileList));

% Load data from each file and store it in the cell array
for k = 1:numel(fileList)
    filePath = fullfile(folderPath, fileList(k).name);
    DATA{k} = load(filePath);
end


for k = 1:numel(fileList)
    figure(k)
     DFA_TEST(DATA{k});
end

end


