 function [MaRV_struct ] = MaRV_micha_G(par,unicor_RV_mat_struct)
% ==============================================================
% ==============================================================
%
%FUNCTION:  [MaRV_struct] = MaRV_micha(par,iterN,unicor_RV_mat_struct)
% The function Calculates Radial Velocity for a given data set.
%
% INPUT   : par - structure with data required for MaRV (bad orders...)
%          par.iterN - nomber of iterations for MaRV
%          unicor_RV_mat_struct - unicor RV matrix form unicor*.OUT file
%                  
%
% OUTPUT  :
% MaRV struct:
%           MaRV_struct.v     - velocity cell vector, first entry is raw data median
%                   estimation. the other entries are for the iteration
%                   where the last element is the last iteration result
%            MaRV_struct.dv    - error cell vector. (same structure as v
%            MaRV_struct.t     -  time vector 
%            MaRV_struct.par   - MaRV parameter structure:
%               MaRV_struct.par.bad_ord - predefined bad orders (vector of order
%               numbers)
%               MaRV_struct.par.sig_thresh - sigma threshold value
%               MaRV_struct.par.ord_scat_thresh
%               MaRV_struct.par.name
%               MaRV_struct.par.ord_n number of orders
%               MaRV_struct.par.obs_n number of observations
%               MaRv_struct.par.RejOrd ord_n x 1 logical array
%             MaRV_struct.RejOrd - cell array 1xNiter each cell containig
%             logical vector of  size ord_n of bad orders (1=bad order)
%             MaRV_struct.model_median;
%             MaRV_struct.model_mean;
%             MaRV_struct.model_scatt;
%             MaRV_struct.model_mean_err;
%
% ==============================================================
% ==============================================================


% 1) Initialize Important variables:
%     -------------------------------
%     In this part, the basic variables of the code are initialized.

% Read data from RV structure.  
t                   = unicor_RV_mat_struct.t;                
v_raw               = unicor_RV_mat_struct.v_mat;
par.name            = unicor_RV_mat_struct.name;

num                 = size(v_raw);
par.ord_n           = num(1);
ord_n           = num(1);
par.obs_n           = num(2);
%obs_n           = num(2); %not used in this function ?



% par.sig_thresh      = NaN;
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
par.bad_ord         = NaN;
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% par.ord_scat_thresh = NaN;

iterN=par.iterN; % number of MaRV iterations to run


v_wrk               = v_raw;
v_median            = (nanmedian(v_raw))';
nan_mat             = ~isnan(v_raw);
dv_median           = 1.482*mad(v_raw,1)./sqrt(sum(nan_mat));

v{1}                = v_median;
dv{1}               = dv_median';







%     est_n              = length(v); % number of cells in v array -each column is an iteration
   

% --------------------------------------------------------------------------------------------------
% Go to identify bad orders:

%         [par]      = identify_bad_orders_micha_G(t,v_raw,v{1},par);
% This function was replaced by its code
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
V_MAT                 = remove_bad_orders_G( v_raw,v{1},par.bad_ord,par.ord_scat_thresh );
v_med                 = nanmedian(V_MAT);
par_tmp               = par;



% 
% 

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
 % This section was removed - seems out of place
%         v_wrk_tmp  = v_raw;
%         if ~isnan(par.bad_ord)        
%               v_wrk_tmp(par.bad_ord,:) = NaN;
%         end
%         v{1}       = (nanmedian(v_wrk_tmp))';
%         dv{1}      = 1.482*mad(v_wrk_tmp,1)./sqrt(sum(par.ord_n - length(par.bad_ord))); 
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

% Remove \ refresh median shift & OLRM:

%     elseif selection == '3'
%         v_wrk                = remove_bad_orders( v_raw,v{1},par.bad_ord,par.ord_scat_thresh);       
%         [orders_sigma,v_wrk] = Get_velocity_matrix(v_wrk,v{1},par.sig_thresh); 

% --------------------------------------------------------------------------------------------------
% Inspect fixed DATA:

%     elseif selection == '3'
    % Option #1: Inspection meny for the fixed data.    
    %   inspect_fixed_data(t,v_wrk,par);
    
    
        
 % Zeroth iteration
 
 
    % get the difference between the velocities and the first estimate
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Function replaced by code
  
%    orig:  [epsilon]         = reduct_RV_model_per_obs_G(v_raw,v{1});
%calculate first estimate for model velocity
v_model = nanmedian(v_raw); %column medians
% ord_n          = num(1);
% duplicate the model velocity row to all obsevations
v_model_mesh = meshgrid(v_model,1:1:ord_n);
epsilon = v_raw - v_model_mesh; 

% end of replacement
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   
    delta0            = nanmedian(epsilon');
    sigma0            = 1.48*mad(epsilon',1);
    sigma{1}=sigma0;
   %***************** to be implemented later *****************************
%     figure;
%     subplot(2,1,1);
%     plot(sigma0,'ok','markerfacecolor','k'); grid on; hold on
%     xlabel('Order');
%     ylabel('\sigma^0 [km/s]');
%     
%     subplot(2,1,2);
%     errorbar(1:length(delta0),delta0,sigma0/sqrt(length(t)),'ok','markerfacecolor','k'); grid on; hold on;
%     xlabel('Order');
%     ylabel('\delta^0 [km/s]');
%     xlim([0,length(delta0)]);  
%**************************************************************************
% --------------------------------------------------------------------------------------------------
% Start iterations
%   

 RejOrd{1} = NaN;
        
 for i = 1:iterN
          
        [v_wrk , RejOrdTmp]        = remove_bad_orders_G( v_raw,v{i},par.bad_ord,par.ord_scat_thresh);       
%    orig:     [orders_sigma,v_wrk]       = Get_velocity_matrix_G(v_wrk,v{i},par.sig_thresh);  
        [sigma_i,v_wrk]       = Get_velocity_matrix_G(v_wrk,v{i},par.sig_thresh);  
% not needed - is implemented by extrac_RV
%         v{i+1}                     = (nanmedian(v_wrk))';
%         [~, dv{i+1} ]              = extract_RV( v_wrk,orders_sigma );



%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%           [v{i+1}, dv{i+1} ]              = extract_RV_G( v_wrk,orders_sigma );
% extract_RV_G function replaced by code:
% v_vec  = nanmedian(v_mat);
v{i+1}  = nanmedian(v_wrk);

% 
% estimate error per mesurment (NOT ORDER) from scatter.
% nan_mat = ~isnan(v_mat);
nan_mat = ~isnan(v{i+1});
dv{i+1}      = 1.482*mad(v{i+1},1)./sqrt(sum(nan_mat));
sigma{i+1}=sigma_i;
% instead of:
% dv{i+1}      = 1.482*mad(v_wrk,1);

v{i+1} = v{i+1}(:);
dv{i+1}    = dv{i+1}(:);




%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        % [v{i+1}, dv{i+1} ]  check compatibility
        %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        if ~isnan(par.bad_ord)
             % forces par.bad_ord on the rej orders if it is defined
            RejOrdTmp(par.bad_ord) = true; 
            RejOrd{i + 1}          = RejOrdTmp(:);
        else
            %RejOrd{i + 1}          = NaN;
            RejOrd{i + 1}          = RejOrdTmp(:);
        end
         
%      par.RejOrd                    = RejOrd{end};
        
 end % iterN loop
       
 %======================End of Iterations ==================================  
      
     par.RejOrd                    = RejOrd; % store the whole history of RejOrd


% % plot the scatter with rejected orders
% [sigma,~]             = Get_velocity_matrix(v_raw,v_med',NaN);
% v_red_original        = sigma;
% v_red                 = sigma;
%   figure3=figure('name','Final_scatter');
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

       




       
       % update est_n
%        est_n=length(v);
% --------------------------------------------------------------------------------------------------



 num=length(v); %get the last iteration
%        if num < est_n

% Create  MaRV_struct
        MaRV_struct.model_median   = nanmedian(v{num});
        MaRV_struct.model_mean     = nanmean(v{num});
        MaRV_struct.model_scatt    = 1.48*mad(v{num},1);
        MaRV_struct.model_mean_err = nanmean(dv{num});
        MaRV_struct.v=v;
        MaRV_struct.dv=dv;
        MaRV_struct.t=t;
        MaRV_struct.par=par;
        MaRV_struct.RejOrd=RejOrd;
        MaRV_struct.delta0=delta0;
        MaRV_struct.sigma0=sigma0;
        MaRV_struct.sigma=sigma;
        
        
               
%        % if ~isnan(num) && (num<est_n) && (num>=0) 
%             figure5 = figure('name','RV Plot');
%             axes5=axes('parent',figure5);
%             plot_err(axes5,t'-floor(t(1)),v{num},zeros(length(t),1)',dv{num},'b','.k'); grid on;
%             title({'\bf calculated RV vs. time \rm',['\bfObject: \rm' par.name ,' , Itr #' num2str(num),'\bf   Modified at: \rm' datestr(now,0) '\bf    Obs N: \rm' num2str(par.obs_n)],['Median: ' num2str(model_median) '  |  Mean: ' num2str(model_mean) '  |  1.48\sigma : ' num2str(model_scatt) '  |  mean err : ' num2str(model_mean_err) ]});
%             xlabel(['t - ' num2str(floor(t(1))) ' [days]']); ylabel('RV [km/sec]');
 % not used anymore           
%             if iscell(obs)
%                 [data_cell headers] = make_output_matrix(v,dv,obs,est_n);
%                 %celldisp(data_cell); pause;
%             end
        %end  
%        else
%             fprintf('Undefined plot number.\n'); pause(1.1);
%        end
    
%    par.name  = RV.name;
       
% --------------------------------------------------------------------------------------------------
% Close all figures:

%     elseif selection == 'i'
%         tmp_mat   = cell2mat(v);
%         diff_mat  = (diff(tmp_mat'))';
%         diff_scat = mean(abs(diff_mat));    
%         figure6=figure('name','Convergence');
%         axes6=axes('parent',figure6);
%         plot(axes6,diff_scat,'ok','markerfacecolor','k'); hold on; grid on;
%         plot(axes6,diff_scat,'-','color',[0.4,0.4,0.4]);
%         xlabel('Iteration number','fontsize',18);
%         ylabel('$$\hat{\Delta v}$$ [km/s]' ,'Interpreter','Latex','fontsize',18);

% Save
%     elseif selection == 's'
%         if exist('v','var')
%            
% %             output_folder_name = uigetdir(pwd,'Where should I save the data?');
%             f_name1            = fullfile(unicor_data_path, [par.name '_MaRV_' datestr(now,30) '.mat']);
%             save(f_name1,'v' , 'dv' , 't','par' ,'RejOrd' );
% %             home_dir = pwd;
%          %   wrt_txt_orbo_MaRV(t,v{2},dv{2},par.name,unicor_data_path);
%          wrt_txt_orbo_MaRV(t,v{end},dv{end},par.name,unicor_data_path);
%          
%         end



  
 end % marv function




