function [par] = identify_bad_orders_micha_G(t,v_raw,v,par)
% 
% bad_ord_tmp           = par.bad_ord;
% T                     = t-floor(t(1));
% quit                  = false;     

% Initialize RV data:
V_MAT                 = remove_bad_orders_G( v_raw,v,par.bad_ord,par.ord_scat_thresh );
v_med                 = nanmedian(V_MAT);
par_tmp               = par;
% here Get Velocity matrix will use the default sigma_threshold=3
[sigma,~]             = Get_velocity_matrix(v_raw,v_med',NaN);

v_red_original        = sigma;
v_red                 = sigma;

% Run menu:
% =========
% while ~quit

% selection = identify_bad_orders_menu_header(par,bad_ord_tmp); % Get users request.

% if selection=='1'                 % plot RV vs. order (Bad oreders removed)
% close all; % close all figures
%    figure1=figure('name','RV vs Order');
%    axes1=axes('parent',figure1);
%    plot(axes1,V_MAT);hold on; grid on;
%    colormap(jet(20));
%    legend(axes1,'show')
%    xlabel('ORDER'); ylabel('RV [Km/Sec]');
%    title({'\bf RV vs. order',['\bfObject: \rm' par.name '\bf   Modified at: \rm' datestr(now,0)]});
% elseif selection=='2'             % plot RV vs. t per order (Bad orders removed)
%     figure2=figure('name','RV vs time');
%     axes2=axes('parent',figure2);
%     plot(axes2,T,V_MAT','-x','markerfacecolor','k'); 
%     colormap(jet(20));
%     hold on;grid on;
%     legend(axes2,'show')
%     title({'\bf RV vs. t per order ',['\bfObject: \rm' par.name '\bf   Modified at: \rm' datestr(now,0)]});
%     xlabel(['t - ' num2str(floor(t(1))) ' [days]']); ylabel('RV [Km/Sec]');
%     hold off
    

% elseif selection=='3'             % plot Scatter chart
%    figure3=figure('name','scatter');
%    axes3=axes('parent',figure3);
%    v_red_plot = nan(size(v_red)); 
%    ord_vec = 1:1:par.ord_n;
%    indx_vec= setdiff(ord_vec,par_tmp.bad_ord );
%    if ~isnan(indx_vec)
%     v_red_plot(:,indx_vec) = v_red(:,indx_vec);
%    end
%    plot(axes3,v_red_original,'.r');hold on; grid on;
%    plot(axes3,(v_red_plot'),'.');
%    xlabel('ORDER'); ylabel('1.48\sigma [Km/Sec]');
%    title({'\bfScatter per order (1.48 MAD)',['\bfObject: \rm' par.name '\bf   Modified at: \rm' datestr(now,0)]});
%    legend(axes3,'removed','not removed');

% return
% elseif selection=='4'             % Choose bad orders.
%     bad_ord_tmp = input('Please enter bad order ( [ #1 , #2 , ... ] ) >> ','s');   
%     par.bad_ord = str2num(bad_ord_tmp);
% 
% % elseif selection=='5'             % Choose bad orders.
%     scat_thresh         = input('Set scatter threshold (in km/s) >> ','s');  
%     par.ord_scat_thresh = str2double(scat_thresh);
%     
    
% elseif selection=='b'             % Return to main menu.
%     quit = true; 
% else
%     fprintf('Undefined input.\nPress any key to continue...\n'); pause;

% end % if for menu selection

% Manage data before executing a new loop.

% par_tmp.bad_ord           = bad_ord_tmp;
%  
% if ~isnan(par_tmp.bad_ord)
%   
%     [ V_MAT ] = remove_bad_orders( v_raw,par_tmp.bad_ord );
%     
% else
%     V_MAT = v_raw;
% end


end



