

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
X = uint8(zeros((m-1) * (n-1), 9));
for i = 2 : m-1
    for j = 2 : n-1
        % get the neighbor cells' states
        temp = [ Z(i-1, j-1),  Z(i-1, j),   Z(i-1, j+1);...
                        Z(i, j-1),     Z(i, j),      Z(i, j+1); ...
                        Z(i+1, j-1), Z(i+1, j) ,  Z(i+1, j+1)];
        temp2 = reshape(temp', 9, 1); % pay attention to the reshape is column-wise arrangement!
        X((i-1) * (j-1), :) = temp2';
    end
end

%% Reference ending configuration and output data
 




%% optimal transition function and edge purification






%% 






%%


