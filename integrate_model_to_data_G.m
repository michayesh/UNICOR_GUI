function y_data = integrate_model_to_data_G(x,y,x_data,shape,width,N_shape)
% The function integrates the spectral data of a model to the requested
% x_data points. usually used to compare model spectra to measured spectra.
% INPUT:
% x - a vector, the lambda values vector of the model.
% y - a vector, the spectral value for each lambda in "x".
% x_data - a vector, the points where you want to calculate the integrated
% model data.
% shape - a string, will hold the name of the shape you want to use in
% convolution with the data. can be: 'gauss' or 'box'
% width - a number, if the shape is gauss then it is the sigma. if the
% shape is box then it is simply the width of the box. given in units of x.
% N_shape - the number of points used in the integration for a single data point.
% OUTPUT:
% y_data - a vector, the same length of "x_data" will hold for each value
% of x_data the integrated spectral data according to the given model "x"
% and "y".

% Checking the oddity of N
if ~exist('N_shape','var')
    N_shape = 31; % Number of points in a shape, should be odd number
elseif mod(N_shape,2) == 0
    N_shape = N_shape + 1;
end

% Creating the shape
% ------------------

if strcmp(shape,'gauss')
    total_width = 6*width; % This is the area used to calculate the shape and normalize it.
    x_s = linspace(-total_width/2,total_width/2,N_shape);
    y_s = exp( -x_s.^2 ./ (2*width^2) );
    y_s = y_s / sum(y_s);
elseif strcmp(shape,'box')
    total_width = width;
    x_s = linspace(-total_width/2,total_width/2,N_shape);
    y_s = ones(size(x_s))/N_shape;
end

% Checking that the x_data doesn't go over the edges of the model data
% given
if min(x_data) + x_s(1) < min(x)
    y_data = zeros(size(x_data));
    disp('requested data below lower boundary');
    return
elseif max(x_data) + x_s(end) > max(x)
    y_data = zeros(size(x_data));
    disp('requested data above upper boundary');
    return
end

% Checking if convolution is needed
if width <= 0 % Do without convolution
    y_data = interp1(x,y,x_data,'spline','extrap');
    return
end
 
% Creating a matrix with the values of x that you want to interpolate, each
% row is N_shape number of points centerd around a value of "x_data". so
% there are "N_shape" number of columns and length(x_data) number of rows.
[int_X, int_Y] = meshgrid(x_s,x_data);
%[int_X, int_Y] = griddedInterpolant(x_s,x_data,'spline','extrap');

X_mat = int_X + int_Y;

% Creating the interpulated values for the X matrix
Y_mat = interp1(x,y,X_mat);

% Convolving with the shape
y_data = Y_mat*y_s(:);



