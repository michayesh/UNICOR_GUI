function corr_vec = combine_corr_shay(corr_mat)
% The function gets a correlation matrix where each row is an order and
% each column is a correlation value, and combines them in order to create
% a single correlation vector.
% INPUT:
% corr_mat - a matrix, the correlation values for each order. different
% velocities in each row, different orders in each column.
% OUTPUT:
% corr_vec - a vector, the combined correlation matrix
%
% See S.Zucker (2003) - "cross-correlation and maximum liklyhood analysis"
% paper for details on the mathematics.

C = corr_mat'; % The columns should be the velocities
M = size(C,1);

corr_vec = sqrt( 1 - prod(1 - C.^2).^(1/M) );

