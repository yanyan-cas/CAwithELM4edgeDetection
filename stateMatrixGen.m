function output = stateMatrixGen(input)

    bouTempRow = uint8(zeros(1, size(input, 2)));
    bouTempColumn = uint8(zeros(size(input, 1) + 2, 1));
    Z = horzcat(bouTempColumn,  vertcat(bouTempRow, input, bouTempRow), bouTempColumn);
    [m, n] = size(Z);
% the whole neighborhood state vectors form the input data-set as:
output = uint8(zeros((m-2) * (n-2), 9));
for i = 2 : m-1
    for j = 2 : n-1
        % get the neighbor cells' states
        temp = [ Z(i-1, j-1),  Z(i-1, j),   Z(i-1, j+1);...
                        Z(i, j-1),     Z(i, j),      Z(i, j+1); ...
                        Z(i+1, j-1), Z(i+1, j) ,  Z(i+1, j+1)];
        temp2 = reshape(temp', 9, 1); % pay attention to the reshape is column-wise arrangement!
        output((i-2) * (n-2) + j-1, :) = temp2';
    end
end
    output = double(output);
end 