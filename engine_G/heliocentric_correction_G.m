function v = heliocentric_correction(v_obs,HCV_obs,v_tmp,HCV_tmp)
%function v = heliocentric_correction(v_obs,HCV_obs,v_tmp,HCV_tmp)
% do the heliocentric correction on the observed speed
% INPUT:
% v_obs - a vector, the speed with maximum correlation for the observed
% spectra.
% HCV_obs - a number. the heliocentric correction velocity of the observed
% spectra.
% v_tmp - a number, the speed of the template
% HCV_tmp - a number. the heliocentric correction velocity of the template.
% OUTPUT:
% v - the corrected velocity
%
% Last modified: 20130502 


v = v_obs + HCV_obs + v_tmp - HCV_tmp;