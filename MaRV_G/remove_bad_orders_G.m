function [ v_new , RejOrd ] = remove_bad_orders_G( vmat,v,bad_ord ,scat_thresh )
% Function: [ v_new ] = remove_bad_orders( v,bad_ord )
%
% Remove bad orders from a given RV matrix.
%
% Input: vmat       - matrix of RV, under the specifications from run_unicor output.
%        v          - An estimate of the actual velocity.
%        bad_ord    - orders to remove, if needed
%        scat thresh- A scatter threshold for the orders. orders which
%                     present larger scatter will be removed. (scatter in
%                     km/s)
%
% Output: v_new     - bad oreders removed.
%         RejOrd    - orders rejected due to scatter
%         
% Last update 20130717 by Sahar Shahaf

v_new  = vmat;
RejOrd = NaN;

if ~isnan(bad_ord)        
    v_new(bad_ord,:) = NaN;
end

[sigma,~]  =  Get_velocity_matrix(v_new,v,NaN);
if ~isnan(scat_thresh) 
    RejOrd  = sigma > scat_thresh;
    v_new( RejOrd,:) = NaN;
end



end

