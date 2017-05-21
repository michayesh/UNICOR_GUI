function [ ] = plot_RV_vs_time_G(axis,t,V_MAT,par )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    T = t-floor(t(1));
    plot(axis,T,V_MAT','-x','markerfacecolor','k'); 
    colormap(axis,jet(20));
    hold(axis,'on');
    grid(axis,'on');
%     legend(axis,'show')
    title(axis,{'\bf RV vs. t per order ';['\bfObject: \rm' par.name]});
    xlabel(axis,['t - ' num2str(floor(t(1))) ' [days]']); 
    ylabel(axis,'RV [km/Sec]');
    hold(axis,'off');

end

