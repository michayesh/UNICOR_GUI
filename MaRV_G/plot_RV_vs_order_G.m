function [] = plot_RV_vs_order_G( axis,V_MAT,par)
%plots RV vs order
%   Inputs:
%       axis - where this plot goes
%       V_mat - RV matrix V(order,obs)
%       par - parameter structure (here par.name is needed);
%    figure1=figure('name','RV vs Order');
%    axes1=axes('parent',figure1);
   plot(axis,V_MAT);
   hold(axis,'on'); 
   grid(axis,'on');
   colormap(jet(20));
%    legend(axis,'show')
   xlabel(axis,'ORDER');
   ylabel(axis,'RV [Km/Sec]');
   
   title(axis,{'\bf RV vs. order';['\bfObject: \rm' par.name]});

end

