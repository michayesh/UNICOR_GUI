function [ ] = corr_report_generator_all_obs_view_unicor( template,obs,output_path,corr_struct,inspect_flag )
%FUNCTION: [ ] = unicor_report_generator( input_args )
%
%The function will generate a PDF report of the given correlations.
%
%INPUT:  
%
%
% *********************************************************************

% Initialize variables:
y_template    = template.sp;
x_template    = template.wv;
data_mat_size = size(template.wv);
ordN          = data_mat_size(2);
obsN          = length(obs);
kill_loop     = false; 
current_obs   = 1;
current_ord   = 1;
h             = figure;
spectra_corr_plot_switch = 'spectra';
corr_peaks_switch        = 'off';

%         Main Loop:
% **************************
while ~ kill_loop
  if strcmp(corr_peaks_switch,'off')
    if strcmp(spectra_corr_plot_switch,'spectra')
        
        hold off
        y_tmp = y_template(:,current_ord);
        x_tmp = x_template(:,current_ord);
        plot(x_tmp,y_tmp/nanmedian(y_tmp),'r'); hold on;
        title({['\bf' obs{1}.name '\rm Order ' num2str(current_ord) ' spectra']; ...
        ['Template: \bf' template.name '\rm '] } );
        xlabel('wv [A]'); ylabel('Normlized flux'); grid on;    
      
        
        for obs_loop_ind = 1:obsN
        
            % Initialize parameters per loop run.
            y_obs = obs{obs_loop_ind}.sp(:,current_ord);
            x_obs = obs{obs_loop_ind}.wv(:,current_ord);


            %Cut zero padding.
            last_zero_ind = find(y_obs>0,1,'first') - 1;
            if last_zero_ind > 0
                cut_ind_vec       = 1:1:last_zero_ind;
                y_obs(cut_ind_vec)=[];
                x_obs(cut_ind_vec)=[];
            end
 
            % Plot 
            hold on
            plot(x_obs,y_obs/nanmedian(y_obs) - 0.5*obs_loop_ind,'b'); 
        end 
          legend('Template','Obs');
    else 
    
        hold off
        
        for obs_loop_ind = 1:obsN
            
            plot(corr_struct.velocities{obs_loop_ind},corr_struct.corr_mat{obs_loop_ind}(:,current_ord)  - 1*obs_loop_ind + 1); grid on; hold on   
            v_ind_tmp =  corr_struct.v_ind_mat(current_ord,obs_loop_ind);
            if (v_ind_tmp - floor(corr_struct.N_parabole/2) > 0) & (v_ind_tmp + floor(corr_struct.N_parabole/2) <= length(corr_struct.velocities{obs_loop_ind}) )
      
                left_ind  =  v_ind_tmp - floor(corr_struct.N_parabole/2); 
                right_ind =  v_ind_tmp + floor(corr_struct.N_parabole/2);
                parabula_x = corr_struct.velocities{obs_loop_ind}(left_ind:right_ind);
      
                c = corr_struct.corr_poly_coeffs{obs_loop_ind}(current_ord,1);
                b = corr_struct.corr_poly_coeffs{obs_loop_ind}(current_ord,2);
                a = corr_struct.corr_poly_coeffs{obs_loop_ind}(current_ord,3);
                parabula_y = a*parabula_x.^2 + b*parabula_x + c;
      
      
                plot(parabula_x,parabula_y  - 1*obs_loop_ind + 1,'r','linewidth',2);
            

            end
        title({['\bf' obs{1}.name '\rm Order ' num2str(current_ord) ' CCF']; ['Template: \bf' template.name '\rm '] }  );
        xlabel('v [Km/Sec]');
        ylabel('Score');     
        end
    end
        
  elseif strcmp(corr_peaks_switch,'on')
     corr_max_mat =  corr_struct.corr_max_mat;
     hold off;
     plot(corr_max_mat);
%      for obs_loop_ind = 1:obsN
%         plot( corr_max_mat(ord_loop_ind,:) + ord_loop_ind ,'b'); hold on;
%         plot( corr_max_mat(ord_loop_ind,:) + ord_loop_ind ,'*k');
%      end
%      
     
     title({['\bf' obs{1}.name '\rm CCF Max Val']; ['Template: \bf' template.name '\rm '] }  )  
     xlim([-0.5 , ordN + 0.5]); xlabel('Order');
     ylim([-0.1 , 1.1]);        ylabel('Correlation');
     grid on;hold off;
  end
    % Display menu, if inspect_flag is on. otherwise save & continue.
    % ================================================================
    
    if ~inspect_flag  %If no inspection is requires - run & save all spectra.
                      %-------------------------------------------------------
        
        if strcmp(spectra_corr_plot_switch,'spectra')                     
            hgsave(h,[fullfile(output_path,'fig_dir',filesep) 'SPECTRA_' num2str(current_ord) '_'  obs{1}.name ]);
        else
            hgsave(h,[fullfile(output_path,'fig_dir',filesep) 'CCF_' num2str(current_ord) '_'  obs{1}.name ]); 
        end
        
        if current_ord < ordN
            current_ord = current_ord +1;
        elseif strcmp(spectra_corr_plot_switch,'spectra')
            current_ord              = 1;
            spectra_corr_plot_switch = 'correlation';
        else
            kill_loop = true;
        end
    else             % If inspection is required - use user's input.
                     %----------------------------------------------
        
        % Show menu:
        % ---------
        choice = menu('Inspect Spectra Menu','Spectra/Correlation Switch','Next ORD','Prev ORD','Corr Peaks review ON/OFF','Save','Quit');
        
        % Manage Choices:
        % ---------------
        switch choice
            
            case 1
                if strcmp(spectra_corr_plot_switch,'spectra')
                    spectra_corr_plot_switch = 'correlation';
                else
                    spectra_corr_plot_switch = 'spectra';
                end
            
            case 2
                if current_ord < ordN
                    current_ord = current_ord +1;
                elseif current_obs < obsN
                    current_ord = 1;
                    current_obs = current_obs +1;   
                end
                
            case 3
                if current_ord > 1
                    current_ord = current_ord - 1;
                elseif current_obs > 1
                    current_ord = ordN;
                    current_obs = current_obs - 1;   
                end
                
            case 4 
                if strcmp(corr_peaks_switch,'on')
                    corr_peaks_switch = 'off';
                else
                    corr_peaks_switch = 'on';
                end

                
            case 5
                if strcmp(spectra_corr_plot_switch,'spectra') && strcmp(corr_peaks_switch,'off')
                    hgsave (gcf, [output_path  obs{1}.name '_Spectra_ord' num2str(current_ord) '_Tmplt_' template.name '.fig'  ]    );
                elseif strcmp(spectra_corr_plot_switch,'correlation') && strcmp(corr_peaks_switch,'off')
                    hgsave (gcf, [output_path  obs{1}.name '_CCF_ord' num2str(current_ord) '_Tmplt_' template.name '.fig'  ]    );
                else
                    hgsave (gcf, [output_path  obs{1}.name '_MaxCorr_ord' num2str(current_ord) '_Tmplt_' template.name '.fig'  ]    ); 
                end
                
                
            case 6
                kill_loop = true;
               
                
        end
    end
end
                
                             
close(h);

                
                
  
