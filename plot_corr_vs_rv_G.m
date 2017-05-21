function [] = plot_corr_vs_rv_G( corr_struct,axis,current_ord )
%Plots correlation function vs RV
% Input:
% unicor_Out structure UNICOR_RV_corr_struct 
%   axis - the axes wher the plot goes
% current_ord - the order to be plotted
% based on Sahar function - Prepared by Micha for the GUI
obsN=size(corr_struct.velocities,2);

% hold(axis,'off');
        
        for obs_loop_ind = 1:obsN
            
            plot(axis,corr_struct.velocities{obs_loop_ind},corr_struct.corr_mat{obs_loop_ind}(:,current_ord)  - 1*obs_loop_ind + 1);
            grid(axis,'on');
            hold(axis,'on');   
            v_ind_tmp =  corr_struct.v_ind_mat(current_ord,obs_loop_ind);
            if (v_ind_tmp - floor(corr_struct.N_parabole/2) > 0) & (v_ind_tmp + floor(corr_struct.N_parabole/2) <= length(corr_struct.velocities{obs_loop_ind}) )
      
                left_ind  =  v_ind_tmp - floor(corr_struct.N_parabole/2); 
                right_ind =  v_ind_tmp + floor(corr_struct.N_parabole/2);
                parabula_x = corr_struct.velocities{obs_loop_ind}(left_ind:right_ind);
      
                c = corr_struct.corr_poly_coeffs{obs_loop_ind}(current_ord,1);
                b = corr_struct.corr_poly_coeffs{obs_loop_ind}(current_ord,2);
                a = corr_struct.corr_poly_coeffs{obs_loop_ind}(current_ord,3);
                parabula_y = a*parabula_x.^2 + b*parabula_x + c;
      
      
                plot(axis, parabula_x,parabula_y  - 1*obs_loop_ind + 1,'r','linewidth',2);
            

            end
            
        %title({['\bf' corr_struct.name '\rm Order ' num2str(current_ord) ' CCF']; ['Template: \bf' template.name '\rm '] }  );
        title(axis,{['\bf' corr_struct.name '\rm Order ' num2str(current_ord) ' CCF'] }  );
        xlabel(axis,'v [km/Sec]');
        ylabel(axis,'Score');     
        end

end

