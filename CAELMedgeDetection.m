

%% Initial configuration and input data
fprintf('Loading image data file\n'); 
addpath('/Users/Yanyan/Documents/MATLAB/DATASET/SIPI_Database/aerials');

image = imread('2.1.09.tiff');

imageGray = rgb2gray(image);

B = imageGray;

% bouTempRow = uint8(zeros(1, size(B, 2)));
% bouTempColumn = uint8(zeros(size(B, 1) + 2, 1));
% 
% Z = horzcat(bouTempColumn,  vertcat(bouTempRow, B, bouTempRow), bouTempColumn);
% 
% [m, n] = size(Z);
% 
% % the whole neighborhood state vectors form the input data-set as:
% X = uint8(zeros((m-2) * (n-2), 9));
% for i = 2 : m-1
%     for j = 2 : n-1
%         % get the neighbor cells' states
%         temp = [ Z(i-1, j-1),  Z(i-1, j),   Z(i-1, j+1);...
%                         Z(i, j-1),     Z(i, j),      Z(i, j+1); ...
%                         Z(i+1, j-1), Z(i+1, j) ,  Z(i+1, j+1)];
%         temp2 = reshape(temp', 9, 1); % pay attention to the reshape is column-wise arrangement!
%         X((i-2) * (n-2) + j-1, :) = temp2';
%     end
% end
X = stateMatrixGen(B);
%% Reference ending configuration and output data

%temp = imbinarize(imageGray);
figure;
imshow(B);
edgeImage = edge(B, 'sobel');
figure;
imshow(edgeImage);
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

numHiddenNode = 100;
numInputNode = size(X, 2);
numTrainData= size(X, 1);
train_data = double(X');
%train_data = mapminmax(double(X'), -1 , 1);



%startTime = cputime;

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

outputY=logical(round(H' * outputWeight));     

right = 0;
for i = 1 : size(Y, 1)
    if isequal(Y(i,:), outputY(i, :))
        right = right +1;
    else
        right = right;
    end
end

accuracy = right / size(Y, 1);

%% 
[m, n] = size(edgeImage);

%input = mapminmax(double(X), -1 , 1);
T = 3;
temp = zeros(numHiddenNode, 1);
temp2 = zeros(numHiddenNode, 1);
temp3 = zeros(numHiddenNode, 1);
temp4 = zeros(numHiddenNode, 1);
nextState = zeros(m * n, 1);
edgeTemp = false(m * n, 1);

I_ref = edgeImage;

for t = 1 : T
    if t == 1
        input = X;
    else
        input = stateMatrixGen(uint8(reshape(nextState, m, n)'));
    end
for i = 1 : m * n
    for j = 1 : numHiddenNode
       temp(j, 1) = inputWeight(j, :) * input(i, :)' + biasHiddenNeurons(j,:);
       temp2(j, 1) = 1 ./ (1 + exp(-temp(j, 1)));
       temp3(j, 1) = temp2(j, 1) * outputWeight(j, 1);
       temp4(j, 1) = temp2(j, 1) * outputWeight(j, 2);
    end
        nextState(i, 1) = fix(sum(temp3) / sum(temp4)) * 255;
        if nextState(i, 1) >= 255
            nextState(i, 1) = 255;
            edgeTemp(i, 1) = 1;
        else
            nextState(i, 1) = 0;    
            edgeTemp(i, 1) = 0;
        end
end

    figure;
    I_edge = reshape(edgeTemp, m, n)';
    imshow(I_edge);
    
    I_puri = imReplace(I_edge, I_ref);
    figure;
    imshow(I_puri);
    
end
    

for round = 1 : T
    
    
end

%%


