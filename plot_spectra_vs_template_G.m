function [] = plot_spectra_vs_template_G(axis,template,obs,obsgroup,order )
%plots spectra vs template of a subgroup of observations for a specific
%order
% based on Sahar function 
% prepared for UNICOR_GUI by Micha
% Depends on template and obs structures
%  Inputs:
% figh-figure handle
% axish-axis handle
% template - unicor template structure
% obs - unicor obs structure (observations)
% obsgroup- vector of obs numbers to display (sub group of observations)
% order - order number to display

% define variable
% ordN          = size(obs{1}.wv,2);
obsN          = size(obs,1);
obsgroup=obsgroup(:);
obsvector=1:obsN;
obsgroup=intersect(obsgroup,obsvector); % allow only members of obs
itempl.data=interp1(template.wv(:,order),template.sp(:,order),obs{1}.wv(:,order));
itempl.lam=interp1(template.wv(:,order),template.wv(:,order),obs{1}.wv(:,order));

hold(axis,'on');
% % flatten the template
% %         y_tmp = template.sp(:,order);
% %         x_tmp = template.wv(:,order);
%         templ_spec.lam=template.wv(:,order);
%         templ_spec.data=template.sp(:,order);
         [ntempl,~]=clean_norm(itempl,5,0.7,'simple-robust');
        

        plot(axis,ntempl.lam,ntempl.data,'r'); hold on;
        title(axis,{['\bf' obs{1}.name '\rm Order ' num2str(order) ' spectra']; ...
        ['Template: \bf' template.name '\rm '] } );
        xlabel(axis,'wv [A]'); 
        ylabel(axis,'Normlized flux');
        xlim(axis,'auto')
        grid(axis,'on');    
        
for obs_loop_ind = obsgroup' % needs to be a line vector
        
            % Initialize parameters per loop run.
            y_obs = obs{obs_loop_ind}.sp(:,order);
            x_obs = obs{obs_loop_ind}.wv(:,order);


            %Cut zero padding.
            last_zero_ind = find(y_obs>0,1,'first') - 1;
            if last_zero_ind > 0
                cut_ind_vec       = 1:1:last_zero_ind;
                y_obs(cut_ind_vec)=[];
                x_obs(cut_ind_vec)=[];
            end
 
            % Plot 
%             hold on
            plot(axis,x_obs,y_obs/nanmedian(y_obs) - 0.5*obs_loop_ind,'b'); 
end % for obs_loop_ind = obsgroup 

          legend('Template','Obs');
     
    
        hold(axis,'off');



end

