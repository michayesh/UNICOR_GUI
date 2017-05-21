function [template]                     = load_saved_template_G(par)      
% Based on load_default_template by Sahar
%                   Search criteria: *.template
% Input:
% UNICOR_GUI handles.par structure
%        
%
% Output: template - a template structure.

% Stage 1: Find default template (if exists) and load.
%     file_list_temp       = dir(fullfile(tmp_dir,'*.template'));
%     file_list_temp       = {file_list_temp.name};
%     name_chk             = ~cellfun(@isempty,file_list_temp);
% 
%     if sum(name_chk) == 0
%        fprintf('\nNo default template found.\n'); pause(0.6);
%        template = NaN;
%        return;
%     elseif sum(name_chk) == 1
%        tmp_name = file_list_temp(find(name_chk));
%        tmp_name = tmp_name{1};
%        fprintf('\nDefault template found:  %s  \n',tmp_name); pause(0.4);
%     else
%        fprintf('\nError: No default template found. Please check filenames in obs. directory!\n');pause(0.6);
%        template = NaN; 
%        return;
%     end
def_dir=par.data_path;    
[fn,pn]=uigetfile(fullfile(def_dir,'*.template'));
template=load(fullfile(pn,fn),'-mat');
template=template.template;
%     if tmp_dir(end)=='\' || tmp_dir(end)=='/'
%        template = txt2tod([tmp_dir tmp_name]);
%     elseif isunix
%        template = txt2tod([tmp_dir '/' tmp_name]);
%     else
%        template = txt2tod([tmp_dir '\' tmp_name]);
%     end

% Stage 2: Gaussian broadening.   
     
%       template_size_vec = size(template.wv);
%       ordN              = template_size_vec(2);
%       
%    Generate instrumental broadening (At the moment by constant value) -
%     !! Not needed - templates are broadened by the optimizer !!
%    ------------------------------------------------------------------
%       inst_broaden         = input('Please enter inst. broadening factor (Angstrom): ','s');
%       inst_broaden         = str2double(inst_broaden);

%       inst_broaden = 0.5*par.instrumental_PSF_FWHM;  % A typical value of Gaussian beroadening for eShell is half of the PSF (= 0.225)


%     Find the mean difference in angstrons for the middle order.
%       ang_diff             = mean(diff(template.wv(:,round(ordN))));
      
%     Create the Gaussian for the convolution:
%     Sigma is calculated as shown below. area under gaussian should be
%     normlized to 1 with miu = 0;
% 
%       broaden_sigma        = inst_broaden;
%       normalization_factor = (sqrt(2*pi)*broaden_sigma)^(-1);
%       broadening_gaussian  = normalization_factor*gaussmf([-3*broaden_sigma:ang_diff:3*broaden_sigma],[broaden_sigma 0]);

%     Convolve the gaussian with the different orders. 
%     Should be preformed with FFT in order to multiply directly the entire
%     matrix. 
%       template.sp          = filtfilt(broadening_gaussian,1,template.sp);
%       template.name        = [template.name '-GB' num2str(inst_broaden)];

      
      
  
end

