function [t, v_mat, dv_mat , velocities , corr_mat ,v ,dv , c]  = run_unicor(path_obs,path_tmp,par,out_filename)
%
% Function [t, v_vec, dv_vec , velocities , corr_vec ,v ,dv , c]  = 
%          run_unicor(path_obs,path_tmp,par)
% 
% An exectution function for UNICOR.
% ----------------------------------
%
% INPUT:path_obs     - string - containing the directory of the observed data.
%       path_tmplt   - string - containing the directory of the observed
%                               data, and the templates name.
%       out_filename - string - containing the output filename
%
% OUTPUT: t             - time vector.
%         v             - velocity vector.
%         dv            - velocity error vector.
%         velocities    - velocity matrix for the corr matrix values.
%         corr_vec      - matrix of corr vectors.
%         combined_corr_pars - the parameters fitted from the combines
%                              correlation 
% -----------------------------------
% 
% NOTE: The function "calc_multi_order_velocity" can return more
%       parameters. Read the relevant help for more details.
%
% Last update: 20130617  by  Sahar Shahaf.

addpath('/home/corot-tau/gil/matlabfiles/functions/unicor');
addpath('/home/corot-tau/gil/matlabfiles/functions');


file_list = dir(out_filename);
if ~isempty(file_list)
   out_filename = input('Output filename exists. Please choose another: >> ','s');
end

% Sets default parameters, if none was given.
% -------------------------------------------
if ~exist('par','var')
    par.v_max        = 2000;
    par.dv           = 1;
    par.min_data_per = 0.5;
    
    par.shape        = 'gauss';
    par.width        = 0;
    par.N_shape      = 31;
    
    par.N_parabole         = 10;
    par.blaze_fit_thresh   = 50;
    par.blaze_fit_sigma    = 0.5;
    par.blaze_fit_bin_size = 1;
    par.blaze_fit_span     = 30;
    par.obs_file_def       = '*.txt';
end


% Create file List
% ----------------
file_list = dir([path_obs '/' par.obs_file_def]);

% 
t                  = nan(1,length(file_list));
v                  = nan(1,length(file_list));
dv                 = nan(1,length(file_list));
c                  = nan(1,length(file_list));

v_vec              = cell(1,length(file_list));
dv_vec             = cell(1,length(file_list));
velocities         = cell(1,length(file_list)); 
corr_vec           = cell(1,length(file_list));

% Run Unicorr per observation.
% ---------------------------
for i = 1:length(file_list)
    
    disp(i)
    
    path_obs_tmp = [path_obs file_list(i).name];
    [ t(i), v_vec{i}, dv_vec{i}, velocities{i} ,corr_vec{i}, v(i) , dv(i) , c(i)] = calc_multi_order_velocity(path_obs_tmp,path_tmp,par);

    

end

v_mat          = cell2mat(v_vec) ;
dv_mat         = cell2mat(dv_vec);
velocities     = cell2mat(velocities);
corr_mat       = cell2mat(corr_vec);


save(out_filename,'t','v_mat','dv_mat','velocities','corr_mat','v','dv','c');

