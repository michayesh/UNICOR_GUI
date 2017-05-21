function par = set_par_unicor_G
%function par = set_par_unicor_G(current_par,dir)
% Function: par = set_par_unicor(par)
% By Sahar
% Modified for GUI by Micha
% Initialize the par structure
% INPUT:  par  - a parameter struct containing all the fields that appear
%                below.
%                If no input was given, defaults will be set in the output.
%
% OUTPUT: par  - a modified parameters vector.

%if ~isstruct(current_par)
   %if ~exist([dir 'last_run_par.mat'],'file')
               
        % Advanced settings switch: 
        par.advanced_settings_switch = false;
        par.instrumental_PSF_FWHM    = 0.768; % In angstroms. This is a fitted value. The calculated value is 0.45. 
        % CCF controlparameters
        par.v_max              = 500;
        par.dv                 = 1;
        par.N_parabole         = 1 + 10*round(1/par.dv);
        par.min_data_per       = 0.5;
        par.deblaze_flag       = false;
        
        % Convolution parametes. Turned off as a default.
        par.shape              = 'gauss';
        par.width              = 0; % When width is 0 Convultion is turned off. 
        par.N_shape            = 31;
    
        % Debaze defaults:
        par.blaze_fit_thresh   = 50;
        par.blaze_fit_sigma    = 0.5;
        par.blaze_fit_bin_size = 1;
        par.blaze_fit_span     = 30;
        par.deblaze_flag       = false;
        
        % Object auxil. data defaults:
        par.name               = 'Undefined';
        par.obs_file_def       = '*.mat';
        par.name               = 'Anonymous';
        par.obs_n               = 0;
    % MaRV section
%               MaRV_s.par.bad_ord - predefined bad orders (vector of order
%               numbers)
%               MaRV_s.par.sig_thresh - sigma threshold value
%               MaRV_s.par.ord_scat_thresh
%               MaRV_s.par.name
%               MaRV_s.par.ord_n number of orders
%               MaRV_s.par.obs_n number of observations
%               MaRv_s.par.RejOrd cell array 1xNiter each cell containig logical vector of
%           size ord_n of bad orders (1=bad order)
%              
        par.iterN=50;
        par.sig_thresh=3;
        par.ord_scat_thresh=5; %km/s
        par.ord_n=20; % number of orders
        par.RejOrd=[];
        
        
        
        


   
    
end
