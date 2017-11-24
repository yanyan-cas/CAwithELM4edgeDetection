function output = generateOutputfromImage(edgeImage)
    
    [m, n] = size(edgeImage);
    
    output =  false(m * n, 2); % the indicator vector
    
for i = 1 : m
    for j = 1 : n
        % get the neighbor cells' states
       if (edgeImage(i, j) == 0)
           output((i - 1) * m + j, :) = [0 1];
       else
            output((i - 1) * m + j, :)= [1 0];
       end
    end
end

end