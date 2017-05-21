function [unicor_RV_mat_struct,unicor_RV_cor_struct]  = run_unicor_obs_is_var_G(obs,template,par)
%
% Function [unicor_RV_mat_struct,unicor_RV_struct,unicor_RV_cor_struct] = 
%          run_unicor(path_obs,path_tmp,par)
% 
% Calls:
% calc_multi_order_velocity_obs_is_var_G(obs{i},template,i,par)

% An exectution function for UNICOR.
% ----------------------------------
%
% INPUT:obs        - unicor CELL array format.
%       template   - unicor CELL array format.
%                             
%
% OUTPUT: unicor_RV_mat_struct - contains: v_mat - a matrix of velocities.
%                                          t     - a time vector.
%                                          jd    - a time vector.
%                                          name  - objects' name.
%
%                             
%         unicor_RV_struct    - contains:  v - calculated velocity from max correlation
%                                          dv- errors for v.
%                                          t - a time vector.
%                                          jd- a time vector.
%                                          c - correlation value.
%                                          name - obj. name.
%
%         unicor_RV_cor_struct - contains: correlation matrix & velocities.
%                                          jd   - a time vector.
%                                          name - obj. name.
%
% -----------------------------------
% 
% Last update: 20131205  by  Sahar Shahaf.


% 1) Sets default parameters, if none was given.
%    -------------------------------------------

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
    par.obs_file_def = '*.txt';
end


% 2) Create file variables
%    ---------------------
l                    = length(obs);
t                    = nan(1,l);
jd                   = nan(1,l);
msg                  = nan(1,l);
corr_max_mat         = cell(1,l);
v_mat                = cell(1,l);
v_ind_mat            = cell(1,l);
dv_mat               = cell(1,l);
velocities           = cell(1,l); 
corr_poly_coeffs_mat = cell(1,l); 
corr_mat             = cell(1,l);
V0_data              = cell(1,l);



%3)                 Run Unicor per observation.
%    ===============================================================

for i = 1:l  
    
   fprintf(['Obs #' num2str(i) ':']); 
   
   % Main correlation function (Per observation!).
   [ t(i), vm_tmp, v_ind_mat_tmp ,dvm_tmp, cp_coeffs_tmp, vels_tmp ,cm_tmp,corr_max_tmp,V0_data_tmp, msg(i)] = calc_multi_order_velocity_obs_is_var_G(obs{i},template,i,par);
 
   % Assign values to cell arrays:
   v_mat{i}                = vm_tmp;
   v_ind_mat{i}            = v_ind_mat_tmp;
   dv_mat{i}               = dvm_tmp;
   corr_poly_coeffs_mat{i} = cp_coeffs_tmp;
   velocities{i}           = vels_tmp;
   corr_mat{i}             = cm_tmp;
   corr_max_mat{i}         = corr_max_tmp;
   V0_data{i}              = V0_data_tmp;
   jd(i)                   = obs{i}.jd;
   % If there 
   if isfield(obs{i},'bad_ord')
      bad_ord{i} = obs{i}.bad_ord;
   else
      bad_ord{i} = zeros(size(vm_tmp));    
   end

end

     

fprintf('\n');
%    ===============================================================



% 4) Arrange data into structures:
%    -----------------------------

v_mat                                 = cell2mat(v_mat) ;
dv_mat                                = cell2mat(dv_mat);
bad_ord                               = cell2mat(bad_ord);
v_ind_mat                             = cell2mat(v_ind_mat);
corr_max_mat                          = cell2mat(corr_max_mat);

unicor_RV_mat_struct.v_mat            = v_mat;
unicor_RV_mat_struct.dv_mat           = dv_mat;
unicor_RV_mat_struct.bad_ord          = bad_ord ;
unicor_RV_mat_struct.t                = t;
unicor_RV_mat_struct.name             = obs{1}.name;
unicor_RV_mat_struct.jd               = jd;
unicor_RV_mat_struct.V0_data          = V0_data;

unicor_RV_cor_struct.corr_mat         = corr_mat;
unicor_RV_cor_struct.corr_max_mat     = corr_max_mat ;
unicor_RV_cor_struct.velocities       = velocities;
unicor_RV_cor_struct.v_ind_mat        = v_ind_mat;
unicor_RV_cor_struct.N_parabole       = par.N_parabole;
unicor_RV_cor_struct.corr_poly_coeffs = corr_poly_coeffs_mat;
unicor_RV_cor_struct.name             = obs{1}.name;
unicor_RV_cor_struct.jd               = jd;
unicor_RV_cor_struct.t                = t;

end

