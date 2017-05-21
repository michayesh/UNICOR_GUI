function [] = plot_RV_scatter_vs_order_G(axis,MaRV_struct,iter )
% Plot scatter of RV vs order
% Plot sigma{iter} vs order
% taken from  'identify_bad_orders' function
% Inputs:
%   MaRV_struct
%
%   iter - number of iteration to plot
% Micha 20/5/17
% 
ord_n=size(MaRV_struct.sigma{end},2); % number of orders
obj_name=MaRV_struct.par.name;
% sigma_original        = MaRV_struct.sigma{iter};
sigma_orig   = MaRV_struct.sigma0;
sigma_iter=MaRV_struct.sigma{iter};
sigma_nonrej=sigma_orig;
sigma_nonrej(isnan(sigma_iter))=NaN; % set all rejected orders to NaN

% RejOrd=MaRV_struct.RejOrd{iter}; %logical array of rejected order in iter
% sigma_rej=sigma;
% sigma_rej(~RejOrd)=NaN;
%    sigma_plot = nan(size(sigma)); 
    ord_vec = 1:1:ord_n;
%    indx_vec= setdiff(ord_vec,par_tmp.bad_ord );
%    if ~isnan(indx_vec)
%     sigma_plot(:,indx_vec) = sigma(:,indx_vec);
%    end
    plot(axis,ord_vec,sigma_orig,'.r'); %plot all red
   
   hold(axis,'on'); grid(axis,'on');
   plot(axis,ord_vec,sigma_nonrej,'.b'); % replot non rejected blue
   plot(axis,ord_vec,sigma_iter,'.g'); % plot current green
   xlabel(axis,'ORDER'); ylabel('\sigma=1.48 mad(RV) [km/s]');
   title(axis,{'\bfScatter per order (1.48 MAD)',['\bfObject: \rm' obj_name]});
   legend(axis,'not removed','removed','current');

end

