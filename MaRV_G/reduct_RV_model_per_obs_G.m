function [v_reduced] = reduct_RV_model_per_obs_G(v_raw,v_model)
%FUNCTION:  [v_reducted] = reduct_RV_model_per_obs(v_raw,v_model)
%
% Prefrom a reduction of an RV model from RV observation matrix. 
%
% INPUT : v_raw   - matrix of velocities' as given from unicor.
%         v_model - vector of modeled velocities per observation.
%
% OUTPUT: v_reducted - matrix of reduced velocity.

% If no model given - take the median per observation as model.
if ~ exist('v_model','var')
    v_model = nanmedian(v_raw); %column medians
end

num            = size(v_raw);
ord_n          = num(1);
% duplicate the model velocity row to all obsevations
v_model_mesh = meshgrid(v_model,1:1:ord_n);
% the result is the difference
v_reduced     = v_raw - v_model_mesh; 

