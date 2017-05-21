function [template]    = load_and_broad_template_G(par)
% function [template]    = load_and_broad_template(par,tmp_dir,temporary_dir)
% Load a template, Broaden & rotate it according to instrumental broadening
% and vsini. 
%save it to temporary dir 
% Inputs:
% par - unicor parameter structure
% tmp_dir - templates dir
% temporary_dir - a folder to save the template
% NOTE: the PSF FWHM is hardcoded in the 'set_par_unicor' function.
% by Sahar
% modified by Micha for unicor GUI
%    Load template:
%    -------------
tmp_dir=par.template_dir;
temporary_dir=par.temporary_dir;
     [tmp_name2, tmp_dir2] = uigetfile([tmp_dir '/*.txt'], 'Choose template');
      if (tmp_dir2 ~= 0 ) 
           tmp_name            = tmp_name2;
           tmp_dir             = tmp_dir2;
           template            = txt2tod_G([tmp_dir tmp_name]); % same as txt2tod - just for seclusion          
      else
           msgbox('No template was selected.\n');
           template = NaN;
      end
     
      template_size_vec = size(template.wv);
      ordN              = template_size_vec(2);
      
%    Generate instrumental broadening (At the moment by constant value)
%    ------------------------------------------------------------------
%       inst_broaden         = input('Please enter inst. broadening factor (Angstrom): ','s');
%       inst_broaden         = str2double(inst_broaden);

      inst_broaden = 0.5*par.instrumental_PSF_FWHM;  % A typical value of Gaussian beroadening for eShell is half of the PSF


%     Find the mean difference in angstrons for the middle order.
      ang_diff             = mean(diff(template.wv(:,round(ordN))));
      
%     Create the Gaussian for the convolution:
%     Sigma is calculated as shown below. area under gaussian should be
%     normlized to 1 with miu = 0;

      broaden_sigma        = inst_broaden;
      normalization_factor = (sqrt(2*pi)*broaden_sigma)^(-1);
      broadening_gaussian  = normalization_factor*gaussmf([-3*broaden_sigma:ang_diff:3*broaden_sigma],[broaden_sigma 0]);

%     Convolve the gaussian with the different orders. 
%     Should be preformed with FFT in order to multiply directly the entire
%     matrix. 
      template.sp          = filtfilt(broadening_gaussian,1,template.sp);
      template.name        = [template.name '-GB' num2str(inst_broaden)];
      save(fullfile(temporary_dir,'unicor_template_tmp.mat'),'template');
      
      

end
