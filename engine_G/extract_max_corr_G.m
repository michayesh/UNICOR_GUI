function [max_x,max_ind, max_x_err, max_corr , poly_coeffs] = extract_max_corr_G(corr_vec,x_vec,N)
% The function fits a shape around the maximum peak and returns the
% maximum value of the fit.
% INPUT:
% corr_vec  - a vector, the correlation value.
% x_vec     - a vector, the x vector of the correlations.
% N         - number of points to take around the maximum point for the fit.
% OUTPUT:
% max_x       - a number, the x coordinate of the maximum point in the fit.
% max_ind     - The index of the x value for the maximal correlation.
% max_x_err   - The error on max_x.
% max_corr    - a number, the correlation of the maximum point in fit.
% poly_coeffs - a number. The coeffitients of the polynomial fitted to the
%                         peak of the correlation vector.


N_half = floor(N/2);

% Finding the highest point
[~, max_ind] = max(corr_vec);

if max_ind-N_half<1
    max_ind = N_half+1;
elseif max_ind+N_half>length(corr_vec)
    max_ind = max_ind - (N_half+1);
end

    
% Taking N points around the maximum
x = x_vec(max_ind-N_half:max_ind+N_half);
y = corr_vec(max_ind-N_half:max_ind+N_half);

% Fitting a polynom
XX = [x(:) x(:).^2];

[poly_coeffs, stats] = robustfit(XX,y);

% Finding the maximum
max_x    = -poly_coeffs(2)/(2*poly_coeffs(3));
max_corr = poly_coeffs(2)^2/(4*poly_coeffs(3)) - poly_coeffs(2)^2/(2*poly_coeffs(3)) + poly_coeffs(1);

% Estimating the error from the scatter around the fit.
se = stats.se;
% max_x_err = abs( max_x*sqrt( (se(2)/a(2))^2 + (se(3)/a(3))^2) );
max_x_err = sqrt( (se(2)/(2*poly_coeffs(3)))^2 + ( poly_coeffs(3)*se(2)/(2*se(3)) )^2 );


end

