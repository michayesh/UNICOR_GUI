function [] = RVplot_G( axis, MaRV_struct )
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
model_median=MaRV_struct.model_median;
model_mean=MaRV_struct.model_mean;
model_scatt=MaRV_struct.model_scatt;
model_mean_err=MaRV_struct.model_mean_err;

n_iter=length(v); %get the last iteration
            plot_err(axis,t'-floor(t(1)),v{n_iter},zeros(length(t),1)',dv{n_iter},'b','.k'); grid on;
            title(axis,{'\bf calculated RV vs. time \rm',['\bfObject: \rm' obj_name ,...
                ' , Itr #' num2str(n_iter), '\bf    N Obs: \rm' num2str(obs_n)],...
                ['Median: ' num2str(model_median) '  |  Mean: ' num2str(model_mean) '  |  1.48\sigma : ' num2str(model_scatt) '  |  mean err : ' num2str(model_mean_err) ]});
            xlabel(['t - ' num2str(floor(t(1))) ' [days]']); ylabel('RV [km/s]');

end

