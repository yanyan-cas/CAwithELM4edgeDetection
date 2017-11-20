function I_purification = imReplace(I_edge, I_ref)
    [m, n] = size(I_edge);
    I_purification = I_edge;
%% inner part
for i = 2 : m -1
for j = 2 : n -1
            %pixels in the reference image
              temp1 = [ I_ref(i-1, j-1),  I_ref(i-1, j),   I_ref(i-1, j+1);...
                         I_ref(i, j-1),     I_ref(i, j),      I_ref(i, j+1); ...
                         I_ref(i+1, j-1), I_ref(i+1, j) ,  I_ref(i+1, j+1)];
             %pixels in the edge image       
              temp2 = [ I_edge(i-1, j-1),   I_edge(i-1, j),   I_edge(i-1, j+1);...
                                 I_edge(i, j-1),      I_edge(i, j),       I_edge(i, j+1); ...
                                 I_edge(i+1, j-1),   I_edge(i+1, j) ,  I_edge(i+1, j+1)];            
            %judge the 
            if I_edge(i, j) == 0         
                temp2(temp1 == 0) = 0;
                I_purification(i-1 : i +1, j -1 : j + 1) = temp2;                
            else
                I_purification(i-1 : i +1, j -1 : j + 1) = temp2;
            end
            
end
end
    
%% 
% first row
for i = 1 
for j = 2 : n -1
            temp1 = [  I_ref(i, j-1),     I_ref(i, j),      I_ref(i, j+1); ...
                         I_ref(i+1, j-1), I_ref(i+1, j) ,  I_ref(i+1, j+1)];
            temp2 = [  I_edge(i, j-1),      I_edge(i, j),       I_edge(i, j+1); ...
                               I_edge(i+1, j-1),   I_edge(i+1, j) ,  I_edge(i+1, j+1)];                            
        if I_edge(i, j) == 0         
                temp2(temp1 == 0) = 0;
                I_purification(i : i +1, j -1 : j + 1) = temp2;                
         else
                I_purification(i : i +1, j -1 : j + 1) = temp2;
        end
end
end
    
%%
%last row 
for i = m
for j = 2 : n -1
            temp1 = [ I_ref(i-1, j-1),  I_ref(i-1, j),   I_ref(i-1, j+1);...
                         I_ref(i, j-1),     I_ref(i, j),      I_ref(i, j+1)];
            temp2 = [ I_edge(i-1, j-1),   I_edge(i-1, j),   I_edge(i-1, j+1);...
                                 I_edge(i, j-1),      I_edge(i, j),       I_edge(i, j+1)];              
          if I_edge(i, j) == 0         
                temp2(temp1 == 0) = 0;
                I_purification(i-1 : i, j -1 : j + 1) = temp2;                
          else
                I_purification(i-1 : i, j -1 : j + 1) = temp2;
          end                    
end
end
   
%%
% first column
for i = 2 : m - 1
for j = 1
    %pixels in the reference image
              temp1 = [   I_ref(i-1, j),   I_ref(i-1, j+1);...
                             I_ref(i, j),      I_ref(i, j+1); ...
                         I_ref(i+1, j) ,  I_ref(i+1, j+1)];
             %pixels in the edge image       
              temp2 = [   I_edge(i-1, j),   I_edge(i-1, j+1);...
                                   I_edge(i, j),       I_edge(i, j+1); ...
                                  I_edge(i+1, j) ,  I_edge(i+1, j+1)];            
            %judge the neighbor states
            if I_edge(i, j) == 0         
                temp2(temp1 == 0) = 0;
                I_purification(i-1 : i +1, j  : j + 1) = temp2;                
            else
                I_purification(i-1 : i +1, j  : j + 1) = temp2;
            end           
     
end
end

%% last column
for i = 2 : m - 1
for j = n
            %pixels in the reference image
              temp1 = [ I_ref(i-1, j-1),  I_ref(i-1, j);...
                         I_ref(i, j-1),     I_ref(i, j); ...
                         I_ref(i+1, j-1), I_ref(i+1, j)];
             %pixels in the edge image       
              temp2 = [ I_edge(i-1, j-1),   I_edge(i-1, j);...
                                 I_edge(i, j-1),      I_edge(i, j); ...
                                 I_edge(i+1, j-1),   I_edge(i+1, j)];            
            %judge the 
            if I_edge(i, j) == 0         
                temp2(temp1 == 0) = 0;
                I_purification(i-1 : i +1, j -1 : j ) = temp2;                
            else
                I_purification(i-1 : i +1, j -1 : j ) = temp2;
            end
            
end
end



    %%
    %%NorthEast Corner
for i = 1
    for j = 1
        temp1 = [I_ref(1, 1), I_ref(1, 2);...
                        I_ref(2, 1), I_ref(2,2)];
        temp2 = [I_edge(1, 1), I_edge(1, 2);...
                        I_edge(2, 1), I_edge(2,2)];
                    
        if I_edge(i, j) == 0         
                temp2(temp1 == 0) = 0;
                I_purification(i : i +1, j : j+1) = temp2;                
            else
                I_purification(i : i +1,  j : j+1 ) = temp2;
        end
            
    end
end

%% NorthWest Corner
for i = 1
    for j = n
        temp1 = [I_ref(1, n-1), I_ref(1, n);...
                        I_ref(2, n-1), I_ref(2,n)];
        temp2 = [I_edge(1, n-1), I_edge(1, n);...
                        I_edge(2, n-1), I_edge(2, n)];
                    
        if I_edge(i, j) == 0         
                temp2(temp1 == 0) = 0;
                I_purification(i : i +1, j-1 : j) = temp2;                
            else
                I_purification(i : i +1,  j-1 : j ) = temp2;
        end
            
    end
end

%% SouthEast Corner
for i = m
    for j = 1
        temp1 = [I_ref(m-1, 1), I_ref(m-1, 2);...
                        I_ref(m, 1), I_ref(m, 2)];
        temp2 = [I_edge(m-1, 1), I_edge(m-1, 2);...
                        I_edge(m, 1), I_edge(m, 2)];
                    
        if I_edge(i, j) == 0         
                temp2(temp1 == 0) = 0;
                I_purification(i - 1 : i,  j : j + 1) = temp2;                
            else
                I_purification(i - 1 : i,  j : j + 1) = temp2;
        end
            
    end
end
    

%% SouthWest Corner
for i = m
    for j = n
        temp1 = [I_ref(m-1, n-1), I_ref(m-1, n);...
                        I_ref(m, n-1), I_ref(m,n)];
        temp2 = [I_edge(m-1, n-1), I_edge(m-1, n);...
                        I_edge(m, n-1), I_edge(m, n)];                    
        if I_edge(i, j) == 0         
                temp2(temp1 == 0) = 0;
                I_purification(i-1 : i, j-1 : j) = temp2;                
            else
                I_purification(i-1 : i ,  j-1 : j ) = temp2;
        end
            
    end
end
    
end