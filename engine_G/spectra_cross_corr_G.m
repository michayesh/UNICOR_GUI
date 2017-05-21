function [corr_vec, v_vec] = spectra_cross_corr_G(x_tmp,y_tmp,x_obs,y_obs,hcv_tmp,hcv_obs,vel_tmp,ord_n,obs_n,par)
% The function gets a template spectra and an observed spectra and runs
% cross-correlation on them.
% INPUT:
% x_tmp - a vector, the wavelength vector of the template.
% y_tmp - a vector, the intensity of each wavelength in "x_tmp"
% x_obs - a vector, the wavelength vector of the observed spectra.
% y_obs - a vector, the intensity of each wavelength in "x_obs"
% hcv_tmp - a number, the heliocntric correction for the template.
% hcv_obs - a number, the heliocntric correction for the observed data.
% vel_tmp - a number, the velocity of the template.
% par - a structure with different parameters used in the cross correlation
% process:
% par.max_shift - a number, the maximum shift in velocity [km/sec]
% par.dv = a number, the jumps in the speeds vector that will be used to
% calculate the correlation.
% par.shape - a string, will hold the name of the shape you want to use in
% convolution with the data. can be: 'gauss' or 'box'
% par.width - a number, if the shape is gauss then it is the sigma. if the
% shape is box then it is simply the width of the box. given in units of x.
% par.N_shape - the number of points used in the integration for a single data point.

% OUTPUT:
% corr_vec - the correlation vector for each speed in "v_vec"
% v_vec - the vector of speeds in km/sec 

% ========================================================================

% 1) Set constants.
%    -------------

c = 299792.458; % speed of light in vacuum (km/sec)

% Translating max shift to number of points

% maxlags      = abs(floor(log(par.v_max) / log( 1 + par.dv / c)));
maxlags      = floor(par.v_max / par.dv);
min_data_per = par.min_data_per; % The minimum precentage of data to be used in the correlation

% =========================================================================

% 2) Cut unrelevant data points.
%    ---------------------------

%Remove zero zero padding from the left side of the vectors:
last_zero_ind = find(y_obs>0,1,'first') - 1;
if last_zero_ind > 0
    cut_ind_vec       = 1:1:last_zero_ind;
    y_obs(cut_ind_vec)=[];
    x_obs(cut_ind_vec)=[];
    y_tmp(cut_ind_vec)=[];
    x_tmp(cut_ind_vec)=[];
end

% cutting the data to fit the model bounderies
lower = min(x_tmp) + 4*par.width;
upper = max(x_tmp) - 4*par.width;
ind   = x_obs < lower | x_obs > upper;
if sum(ind) > 0 
    fprintf('Cut ') %('The data was cut to fit the bounderies of the model');
end
x_obs(ind) = [];
y_obs(ind) = [];

% remove NaNs in the data!!!
nan_ind        = isnan(y_obs);
x_obs(nan_ind) = [];
y_obs(nan_ind) = [];

nan_ind        = isnan(x_obs);
x_obs(nan_ind) = [];
y_obs(nan_ind) = [];
%==========================================================================

% 2) Move to log scale on the wavelength & interpulate.
%    ---------------------------

% Choosing the log scale that will give evenly spaced data in the log.
% x_vec = logspace(log10(x_obs(1)),log10(x_obs(end)),length(x_obs));
%delta_log_lambda = par.dv / (c * log(10));
delta_log_lambda = log( 1 + par.dv / c);
x_vec_log = log(x_obs(1)):delta_log_lambda:log(x_obs(end));
x_vec = exp(x_vec_log);

% Moving the data to the log spacing ( this is not a model no special integration is required )
y_obs_log = interp1(x_obs,y_obs,x_vec(:),'spline','extrap');%
y_obs_log = y_obs_log(:);

% Subtract mean
y_obs_log = (y_obs_log - mean(y_obs_log)) / std(y_obs_log);

% Moving the model data to log spacing 
y_tmp_log = integrate_model_to_data(x_tmp,y_tmp,x_vec,par.shape,par.width,par.N_shape);
% Subtract mean
y_tmp_log = (y_tmp_log - mean(y_tmp_log)) / std(y_tmp_log);

% Should we fit a y_obs_log = A*y_tmp_log + B ???

% Because we moved to log spacing when we did the interpolation we have
% basiclly evenly spaced in the log, so now we simply run cross corr.

%==========================================================================

% 2) Run cross-correlation (Not a final version)
%    ------------------------------------------
% It is possible to swap "xcorr" with fft and back in order to insert a
% filter. look into the function "xcorr" for an example.

% line_coeffs      = robustfit(x_vec,y_obs_log);
% y_obs_log2       = y_obs_log -(line_coeffs(2)*x_vec' + line_coeffs(1));

% Running the cross-correlation
[corr_vec, lags] = xcorr(y_tmp_log,y_obs_log,maxlags,'coeff');

% Calculating the shift in lambda vector
delta_log_lam = nanmedian(diff(log(x_vec)));

% Zero the correlation where less then half of the data is used
% -----------------------------------------
data_span = x_vec_log(end) - x_vec_log(1);
corr_span = delta_log_lam*maxlags;

if corr_span > (1 - min_data_per)*data_span
    max_corr_lag = maxlags - floor(min_data_per*data_span/delta_log_lam);
    corr_vec(1:max_corr_lag) = 0;
    corr_vec(end-max_corr_lag:end) = 0;
end

%v_vec = lags*delta_log_lam*c*log(10);
v_vec = (-1)*lags*((delta_log_lam)*c);

% Heliocentric correction
% -----------------------

v_vec = heliocentric_correction(v_vec,hcv_obs,vel_tmp,hcv_tmp);

% Transform to column vectors
corr_vec = corr_vec(:);
v_vec = v_vec(:);











