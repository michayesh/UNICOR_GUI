function [sigma_ord,v_new] = Get_velocity_matrix_G(v,v_model,sig_thresh)
% Function: [sigma_ord,v_new] = Get_velocity_matrix_G(v,v_model,sig_thresh)
% 
% Calculates the sigma from scatter around the median\model of an RV matrix.
% Removes systematic deviation from velocity matrix
% Removes outliers from velocity matrix.
%
%
% Inputs: v - matrix of RV, under the specifications from run_unicor output.
%        v_model - RV model vector. if not given - median will be taken.
%        sig_thresh - a number, sigma threshhold - for order significance criterion.
%        in units of sigma!!!!!
%        
%
% Outputs: sigma  - vector of scatter estimation values per order.
%          v_new  - bad oreders removed & systematics removed.
%
% Last update 20160912 by Sahar Shahaf
% Modified  by Micha for pipeline operation 19/5/17

num                 = size(v);
ord_n               = num(1);
obs_n               = num(2);

% Default for sigma threshhold (for outlier rejection)
if ~exist('sig_thresh','var')||isnan(sig_thresh)
    sig_thresh      = 3;
end

% Take the median of the radial velocity per observation, if no model given
if ~exist('v_model','var')
    v_model         = nanmedian(v);                        
end;

% Subtract the RV model from the mesured velocity to get epsilon_ij
%**************************************************************************

% [epsilon]         = reduct_RV_model_per_obs(v,v_model);
v_model_mesh = meshgrid(v_model,1:1:ord_n);
% the result is the difference
% epsilon = v_raw - v_model_mesh; 
epsilon = v - v_model_mesh;
% Find systematics in the reduced velocity matrix & remove from velocity matrix  (delta_i)
delta  = nanmedian(epsilon');

% Find scatter per order (sigma_i)
sigma_ord  = 1.48*mad(epsilon',1);

% Find the error on delta_i
sys_dev_err       = sigma_ord/sqrt(obs_n);

% Remove only significant deviations:
delta(abs(delta) < sig_thresh*sys_dev_err) = 0;
sys_dev_mat                                = meshgrid(delta,1:1:obs_n);
v_new                                      = v - sys_dev_mat';





