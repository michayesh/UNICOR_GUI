function [] = RVplot_iter_G( axis, MaRV_struct,iter )
% Plot the final RV plot
%   Inputs:
%       MaRV_struct uses here:
%                MaRV_struct.v, MaRV_struct.t, MaRV_struct.model_median
% figure5 = figure('name','RV Plot');
%             axes5=axes('parent',figure5);
t=MaRV_struct.t;
v=MaRV_struct.v;
dv=MaRV_struct.dv;
obs_n=MaRV_struct.par.obs_n;
obj_name=MaRV_struct.par.name;
% model_median=MaRV_struct.model_median;
% model_mean=MaRV_struct.model_mean;
% model_scatt=MaRV_struct.model_scatt;
% model_mean_err=MaRV_struct.model_mean_err;

% n_iter=length(v); %get the last iteration
            plot_err(axis,t'-floor(t(1)),v{iter},zeros(length(t),1)',dv{iter},'b','.k'); grid on;
            titlestr=sprintf('Calculated RV vs. time \n Object: %s Itr # %d   N Obs: %d',obj_name,iter,obs_n);
            title(axis,titlestr);
            xlabel(['t - ' num2str(floor(t(1))) ' [days]']); ylabel('RV [km/s]');

end

