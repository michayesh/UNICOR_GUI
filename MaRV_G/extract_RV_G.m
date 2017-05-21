function [ v_vec, dv ] = extract_RV_G( v_mat,sigma)
% ------------------------------------------------------------------------
% FUNCTION: [ v_vec, dv ,v_mat,sigma ] = extract_RV( v_raw,par )
%
% INPUT : v_raw - matrix of velocities (ORDER_N X OBS_N)
%         par   - a stricture of parameters.
%
% OUTPUT: v_vec  - two cells each with calculated RV (the first one is from
%                 the median and the second one is from the wmean.
%         dv     - errors correspond with the above.
%         v_mat  - matrices after the outlier removal (for each calc method).
%         sigma  - sigma of the scatter for each calc method.
% ------------------------------------------------------------------------
%
% Updated: 20130708 by Sahar Shahaf

% 1) Around median:
%    --------------
% Get sigma from scatter, and remove outliers. (around the median);

%[v_vec] = wmean_unicorr( v_mat, sigma); % without outliers.
 v_vec  = nanmedian(v_mat);
% estimate error per mesurment (NOT ORDER) from scatter.
%nan_mat = ~isnan(v_mat);
%dv      = 1.482*mad(v_mat,1)./sqrt(sum(nan_mat));
dv      = 1.482*mad(v_mat,1);

v_vec = v_vec(:);
dv    = dv(:);




end

