function [ x, y ] = findInCell( var,cellArray )

% Description: Find the index of element ina cell array

%  Input: var: value to be seached

%             cellArray: cell array to search var

% Output: x: row index y: correspondingcolum index

% demo: suppose A and B are two cell arraies,

%       [x y] = findInCell(A{1},B) searches the first element of A in B


   [x, y] =ind2sub(size(cellArray),find(cellfun(@(x)strcmp(x,var),cellArray)));

end