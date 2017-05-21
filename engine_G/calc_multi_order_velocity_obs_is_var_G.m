function [ t, v_vec, v_ind_vec, dv_vec  ,corr_poly_coeffs_vec, velocities ,corr_mat , corr_max_val_vec ,V0_data, err_msg] = calc_multi_order_velocity_obs_is_var_G(spec,tmp,obs_n,par)
% FUNCTION: [ t, velocities , v_vec, dv_vec , corr_vec , combined_corr ] = calc_multi_order_velocity(obs,path_tmp,par)
% -------------------------------------------------------------------------------------------------------------------
% The function calculate the velocity of an observed spectra according to a given
% template.
% -------------------------------------------------------------------------------------------------------------------
%
% INPUT:
% *****
% obs       - A struct, a specific cell from unicor cell array format,
%             containing data for a single observation.
% tmp       - A struct, a specific cell from unicor cell array format,
%             containing data of a template.
% obs_n     - observation number.
% par       -a structure holding all the parameters needed to run the code:
%             see description in "spectra_cross_corr.m"
% -------------------------------------------------------------------------------------------------------------------
%
% OUTPUT:
% ******
% t                  - a number, the BJD of the observation
%
% Data per order:
% --------------
% v_vec              - a vector of fitted velocites per order.
% v_ind_vec          - a vector of the indices of the correlation peak.
% dv_vec             - a vector of fitted velocities errors per order.
% velocities         - a vector, the velocities vector that was used in the
%                      correlation calculation.
% poly_coeffs        - a number. The coeffitients of the polynomial fitted to the
%                      peak of the correlation vector.                   
% corr_vec           - a vector, the correlation for each velocity value.
%
% Data from combined correlation:
% ------------------------------
% v                  - velocity vector from combined correlation.
% v_ind              - max value index from the combined correlation.
% dv                 - velocity error from combined correlation.
% c
%
% err_msg            - a binary variable. 
%
% Last modified: 20130617 Sahar Shahaf



if ~exist('par','var')
    par.v_max = 2000;
    par.dv = 1;
    par.min_data_per = 0.5;
    par.shape = 'gauss';
    par.width = 0;
    par.N_shape = 31;
    par.N_parabole = 10;
    par.blaze_fit_thresh = 50;
    par.blaze_fit_sigma = 0.5;
    par.blaze_fit_bin_size = 1;
    par.blaze_fit_span = 30;
end


% Loading the text files to matlab format
% ---------------------------------------

% tmp.sp_interp = interp1(tmp.wv,tmp.sp,spec.wv,'spline');
t           = spec.jd;

% Calculate the cross-correlation ( with heliocentric correction )
% -------------------------------

N_order     = size(spec.wv,2);
corr_mat    = zeros(2*floor(par.v_max/par.dv) + 1,N_order);
v_mat       = zeros(2*floor(par.v_max/par.dv) + 1,N_order);

fprintf('Calculating order:  ');

for i = 1:N_order
    
    fprintf([num2str(i) ' ']);
 %=======================GGGG cancelled the deblaze function ==============
 %=======================GGGG cancelled remove telluric lines =============
%     % Removing continuum (blaze)
%     if par.deblaze_flag
%         [det_x, det_y, ~] = remove_continuum(spec.wv(:,i),spec.sp(:,i),par);
%     else
        det_x = spec.wv(:,i);
        det_y = spec.sp(:,i);
%    end
    
%     % If there is enough data left, Remove telluric lines &         
%     if length(det_x) > 0.1*length(spec.wv(:,i))
%     
%         % Removing telluric lines
%         det_y = remove_telluric(det_x,det_y);
%==========================================================================

        % Running the cross correlation
        [corr_mat(:,i), v_mat(:,i)] = spectra_cross_corr(tmp.wv(:,i),tmp.sp(:,i),det_x,det_y,tmp.hcv,spec.hcv,tmp.vel,i,obs_n,par);
        
    end 
 
end


fprintf('\n');

% Finding the maximum correlation velocity
% -------------------------------------

% Finding the orders that where used.
good_ind     = find(v_mat(1,:) ~= 0); 
N_good_order = length(good_ind);

% Combining the correlations with weights according to max correlation
V0_data.corr_vec = combine_corr_weighted(corr_mat(:,good_ind));

if numel(good_ind)>0
    err_msg    = 0;
    velocities = v_mat(:,good_ind(1)); % Should be the same for all orders!
    [V0_data.v, V0_data.v_ind, V0_data.dv, V0_data.c , V0_data.corr_poly_coeffs] = extract_max_corr(V0_data.corr_vec,velocities,par.N_parabole);
    
    % Calculate the median velocity
    % by first solving v for each order
    v_vec                = zeros(N_good_order,1);
    dv_vec               = zeros(N_good_order,1);
    corr_max_val_vec     = zeros(N_good_order,1);
    v_ind_vec            = zeros(N_good_order,1);
    corr_poly_coeffs_vec = zeros(N_good_order,3);

    for i = good_ind
    
      [v_vec(i),v_ind_vec(i), dv_vec(i), corr_max_val_vec(i),corr_poly_coeffs_vec(i,:)] = extract_max_corr(corr_mat(:,i),v_mat(:,i),par.N_parabole);
    
    end

else
    err_msg          = 1;
    t                = NaN;
    v_vec            = NaN;
    dv_vec           = NaN;
    corr_max_val_vec = NaN;
    velocities       = NaN;
    corr_mat         = NaN;
    v_ind_vec        = NaN;
    V0_data          = NaN;
    corr_poly_coeffs_vec = NaN;
    
end

