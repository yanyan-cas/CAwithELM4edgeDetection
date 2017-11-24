
clc
clear all
%% Initial configuration and input data
fprintf('Loading image data file\n'); 
addpath('/Users/Yanyan/Documents/MATLAB/DATASET/SIPI_Database/aerials');

image = imread('3.2.25.tiff');

%imageGray = rgb2gray(image);
B= image;
%B = imageGray;

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
edgeImage1 = edge(B, 'sobel');

edgeImage2 = edge(B, 'canny');

edgeImage3 = edge(B, 'Roberts');

%generate the indicator vector (elm output)
Y1 = generateOutputfromImage(edgeImage1);
Y2 = generateOutputfromImage(edgeImage2);
Y3 = generateOutputfromImage(edgeImage3);
Y = Y1 | Y2 | Y3;

edgeImage = edgeImage1 | edgeImage2 | edgeImage3;
%% optimal transition function and edge purification

errorRate = 1;
elmRound = 10;

%*********Initialization***********
numHiddenNode = 500; 
numInputNode = size(X, 2);
numTrainData= size(X, 1);




inputWeight = rand(numHiddenNode, numInputNode)*2 - 1;
biasHiddenNeurons=rand(numHiddenNode,1);
ind=ones(1,numTrainData);
biasMatrix=biasHiddenNeurons(:,ind);          


iteration = 0;
while (errorRate < 0.001) || (iteration < 10)
        iteration = iteration +1;
        train_data = double(X');
        tempH=inputWeight * train_data;
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
        
        outputWeight =  pinv(H') * double(Y);
        tempY= H' * outputWeight - 0.5;     
        outputY = tempY>=0;
        %errorRate evaluation
        k = 0;
        for i = 1 : size(Y, 1)
            if isequal(Y(i,:), logical(outputY(i, :)))
                k = k +1;
            end
        end
        errorRate = 1 - k / size(Y, 1);

        
end

displayInfo = sprintf("ELM error rate is %2f, training round = %d\n", errorRate, iteration );
fprintf(displayInfo);

[Iedge1, I_puri1] = imagePurication(X, edgeImage, inputWeight, numHiddenNode, biasHiddenNeurons, outputWeight);

%%
%%%%%%%%%%test below
Y = generateOutputfromImage(Iedge1);
errorRate = 1;
while errorRate > 0.05
        train_data = double(X');
        tempH=inputWeight * train_data;
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
        
        outputWeight =  pinv(H') * double(Y);
        tempY= H' * outputWeight - 0.5;     
        outputY = tempY>=0;
        %errorRate evaluation
        k = 0;
        for i = 1 : size(Y, 1)
            if isequal(Y(i,:), logical(outputY(i, :)))
                k = k +1;
            end
        end
        errorRate = 1 - k / size(Y, 1);

        
end

[I_edge2, I_puri2] = imagePurication(X, edgeImage, inputWeight, numHiddenNode, biasHiddenNeurons, outputWeight);


