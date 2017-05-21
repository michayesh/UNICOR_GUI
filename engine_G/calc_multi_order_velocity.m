function [ t, v_vec, dv_vec , velocities ,corr_vec , v ,dv, c ] = calc_multi_order_velocity(obs,path_tmp,par)
% FUNCTION: [ t, velocities , v_vec, dv_vec , corr_vec , combined_corr ] = calc_multi_order_velocity(obs,path_tmp,par)
% -------------------------------------------------------------------------------------------------------------------
% The function calculate the velocity of an observed spectra according to a given
% template.
% -------------------------------------------------------------------------------------------------------------------
%
% INPUT:
% obs     - a string containing the full path to a todcor text file with an observed
%           spectra. for example:
%                            Star: C000310181333_RED-cln
%                            JD: 2456147.884044
%                            HCV: -17.4190
%                            Velocity:    0.0000
%                            number_of_orders: 1
%                            8341.470703	    1.015087
%                            8341.715019	    1.033305
%                               ...               ...
%
% path_tmp   -a string, the full path to a todcor text file with a template the format is the same.
% par        -a structure holding all the parameters needed to run the code:
%             see description in "spectra_cross_corr.m"
% -------------------------------------------------------------------------------------------------------------------
%
%OUTPUT:
% t                  - a number, the BJD of the observation
% v_vec              - a vector of fitted velocites per order.
% dv_veec            - a vector of fitted velocities errors per order.
% velocities         - a vector, the velocities vector that was used in the correlation
%                      calculation.
% corr_vec           - a vector, the correlation for each velocity value.
% combined_corr_pars - a struct containing the fitted v,dv and max
%                      correlation value from combining the correlations of all orders.
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

spec = txt2tod(obs);
tmp  = txt2tod(path_tmp);

t = spec.jd;

% Calculate the cross-correlation ( with heliocentric correction )
% -------------------------------

N_order = size(spec.wv,2);
corr_mat = zeros(2*floor(par.v_max/par.dv) + 1,N_order);
v_mat = zeros(2*floor(par.v_max/par.dv) + 1,N_order);

for i = 1:N_order
    
    disp(['Calculating order: ' num2str(i)]);
    
    % Removing continuum (blaze)
    [det_x, det_y, ~] = remove_continuum(spec.wv(:,i),spec.sp(:,i),par);
    
    if length(det_x) > 0.1*length(spec.wv(:,i))
    
        % Removing telluric lines
        det_y = remove_telluric(det_x,det_y);
            
        % Running the cross correlation
        [corr_mat(:,i), v_mat(:,i)] = spectra_cross_corr(tmp.wv(:,i),tmp.sp(:,i),det_x,det_y,tmp.hcv,spec.hcv,tmp.vel,par);
        
    end 
 
end

% Finding the maximum correlation velocity
% -------------------------------------

% Finding the orders that where used.
good_ind = find(v_mat(1,:) ~= 0); 
N_good_order = length(good_ind);

% Combining the correlations with weights according to max correlation
corr_vec = combine_corr_weighted(corr_mat(:,good_ind));
velocities = v_mat(:,good_ind(1)); % Should be the same for all orders!

[v, dv, c] = extract_max_corr(corr_vec,velocities,par.N_parabole);

%--------------------------------------------------------------------------
% Another method: calculate the median velocity
% by first solving v for each order
v_vec  = zeros(N_good_order,1);
dv_vec = zeros(N_good_order,1);
c_vec  = zeros(N_good_order,1);

for i = good_ind
    
    [v_vec(i), dv_vec(i), c_vec(i)] = extract_max_corr(corr_mat(:,i),v_mat(:,i),par.N_parabole);
    
end

