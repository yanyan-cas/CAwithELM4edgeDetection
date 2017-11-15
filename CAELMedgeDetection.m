

%% Initial configuration and input data
fprintf('Loading image data file\n'); 
addpath('/Users/Yanyan/Documents/MATLAB/DATASET/SIPI_Database/aerials');

image = imread('2.1.01.tiff');

imageGray = rgb2gray(image);

B = imageGray;

bouTempRow = uint8(zeros(1, size(B, 2)));
bouTempColumn = uint8(zeros(size(B, 1) + 2, 1));

Z = horzcat(bouTempColumn,  vertcat(bouTempRow, B, bouTempRow), bouTempColumn);

[m, n] = size(Z);

% the whole neighborhood state vectors form the input data-set as:
X = uint8(zeros((m-2) * (n-2), 9));
for i = 2 : m-1
    for j = 2 : n-1
        % get the neighbor cells' states
        temp = [ Z(i-1, j-1),  Z(i-1, j),   Z(i-1, j+1);...
                        Z(i, j-1),     Z(i, j),      Z(i, j+1); ...
                        Z(i+1, j-1), Z(i+1, j) ,  Z(i+1, j+1)];
        temp2 = reshape(temp', 9, 1); % pay attention to the reshape is column-wise arrangement!
        X((i-2) * (n-2) + j-1, :) = temp2';
    end
end

%% Reference ending configuration and output data

temp = imbinarize(imageGray);
edgeImage = edge(B, 'sobel');
%edgeImage = edge(B, 'canny');
%edgeImage = edge(B, 'Roberts');

[m, n] = size(edgeImage);

Y = false(m * n, 2); % the indicator vector

for i = 1 : m
    for j = 1 : n
        % get the neighbor cells' states
       if (edgeImage(i, j) == 0)
           Y((i - 1) * 512 + j, :) = [0 1];
       else
            Y((i - 1) * 512 + j, :)= [1 0];
       end
    end
end


%% optimal transition function and edge purification

% X, Y
% to 

numHiddenNode = 100;
numInputNode = size(X, 2);
numTrainData= size(X, 1);
train_data = mapminmax(double(X'), -1 , 1);
clear X;


startTime = cputime;

inputWeight = rand(numHiddenNode, numInputNode)*2 - 1;
biasHiddenNeurons=rand(numHiddenNode,1);

tempH=inputWeight * train_data;

ind=ones(1,numTrainData);
%   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
biasMatrix=biasHiddenNeurons(:,ind);            
tempH=tempH+biasMatrix;

activationFunction = 'sig';
%%%%%%%%%%% Calculate hidden neuron output matrix H
switch lower(activationFunction)
    case {'sig','sigmoid'}
        %%%%%%%% Sigmoid 
        H = 1 ./ (1 + exp(-tempH));
    case {'sin','sine'}
        %%%%%%%% Sine
        H = sin(tempH);    
    case {'hardlim'}
        %%%%%%%% Hard Limit
        H = hardlim(tempH);            
        %%%%%%%% More activation functions can be added here                
end

temp = pinv(H');
outputWeight = temp * double(Y);






%% 






%%


