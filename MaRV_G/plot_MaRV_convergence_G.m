function [ ] = plot_MaRV_convergence_G( axis,MaRV_struct )
%Plot MaRV Convergence plot
%   Inputs:
%       axis - axis to plot 
%       MaRV_struct 
%       uses here: MaRV_struct.v
v= MaRV_struct.v;
tmp_mat   = cell2mat(v);
        diff_mat  = (diff(tmp_mat'))';
        diff_scat = mean(abs(diff_mat));    
%         figure6=figure('name','Convergence');
%         axes6=axes('parent',figure6);
        plot(axis,diff_scat,'ok','markerfacecolor','k');
        hold(axis,'on');
        grid(axis,'on');
        plot(axis,diff_scat,'-','color',[0.4,0.4,0.4]);
        xlabel(axis,'Iteration number','fontsize',18);
        ylabel(axis,'$$\hat{\Delta v}$$ [km/s]' ,'Interpreter','Latex','fontsize',18);

end

