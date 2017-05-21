function [par] = mk_par_unicorr()
% Function:
%  function [par] = mk_par_unicorr()
% 
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
% par.prnt_flag - print each correlation , For debugging.
% updated: 20130521, by Sahar Shahaf.

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
    par.obs_file_def = 'SOP*';