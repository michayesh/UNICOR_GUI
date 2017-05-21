function corr_vec = combine_corr_weighted(corr_mat)
% The function gets a correlation matrix where each column is an order and
% each row is a correlation value, and combines them in order to create
% a single correlation vector. the combination is a weighted average where
% the max correlation of each order is used a the weight.
% INPUT:
% corr_mat - a matrix, the correlation values for each order. different
% velocities in each row, different orders in each column.
% OUTPUT:
% corr_vec - a vector, the combined correlation matrix


% w = (max(corr_mat) ./ std(corr_mat)).^2; % The SNR of the correlation

w = max(corr_mat).^2;

w = w ./ sum(w);

corr_vec = corr_mat*w';

