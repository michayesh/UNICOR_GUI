% MaRV test
%
close all;
load('handles.mat');
[MaRV_struct ] = MaRV_micha_G(handles.par,handles.unicor_RV_mat_struct);
figure1=figure('name','RV_plot');
axes1=axes('parent',figure1);
RVplot_G( axes1, MaRV_struct);

figure2=figure('name','Convergence plot');
axes2=axes('parent',figure2);
plot_MaRV_convergence_G( axes2,MaRV_struct )

figure3=figure('name','Order Scatter plot');
axes3=axes('parent',figure3);
plot_RV_scatter_vs_order_G(axes3,MaRV_struct,51 )

figure4=figure('name','RV plot iter');
axes4=axes('parent',figure4);
RVplot_iter_G( axes4, MaRV_struct,3 )
