

end1 = 'C:\Users\João Carlos\Google Drive\Estudo\Mestrado\Projetos\Super Duplex Retangulo\PEC\Sensor Bobina\Sinais\1\';
 
d = dir([end1, '\*.txt']);
x=length(d)-1;

for i = 1:x
s = strcat(end1,'test_',int2str(i),'.txt');
delimiter = '\t';
formatSpec = '%*s%s%[^\n\r]';
fileID = fopen(s,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
rawData = dataArray{1};
for row=1:size(rawData, 1)
    % Create a regular expression to detect and remove non-numeric prefixes and
    % suffixes.
    regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\.]*)+[\,]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\.]*)*[\,]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
    try
        result = regexp(rawData(row), regexstr, 'names');
        numbers = result.numbers;
        
        % Detected commas in non-thousand locations.
        invalidThousandsSeparator = false;
        if numbers.contains('.')
            thousandsRegExp = '^\d+?(\.\d{3})*\,{0,1}\d*$';
            if isempty(regexp(numbers, thousandsRegExp, 'once'))
                numbers = NaN;
                invalidThousandsSeparator = true;
            end
        end
        % Convert numeric text to numbers.
        if ~invalidThousandsSeparator
            numbers = strrep(numbers, '.', '');
            numbers = strrep(numbers, ',', '.');
            numbers = textscan(char(numbers), '%f');
            numericData(row, 1) = numbers{1};
            raw{row, 1} = numbers{1};
        end
    catch
        raw{row, 1} = rawData{row};
    end
end
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw);
raw(R) = {NaN};
Sinal(:,i) = cell2mat(raw);
clc; fprintf("Sinal ==> "); disp(i);
end
Sinais = Sinal;

clearvars d end1 i n x s filename delimiter formatSpec row regexstr numbers;
clearvars fileID dataArray ans raw col numericData rawData result; 
clearvars invalidThousandsSeparator thousandsRegExp R;
clc;

% Sinais = [Amostra_solu Amostra_5 Amostra_15 Amostra_30 Amostra_45 Amostra_60 Amostra_90
%     Amostra_120 Amostra_150 Amostra_180 ];


% target= [1:1:1000]*0;
% target(1,1:100) = 1;
% target(2,101:200) = 1;
% target(3,201:300) = 1;
% target(4,301:400) = 1;
% target(5,401:500) = 1;
% target(6,501:600) = 1;
% target(7,601:700) = 1;
% target(8,701:800) = 1;
% target(9,801:900) = 1;
% target(10,901:1000) = 1;