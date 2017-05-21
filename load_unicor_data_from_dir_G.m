function [obs,par] = load_unicor_data_from_dir_G(par)
% function [obs,par] = load_unicor_data_from_dir_G(obs_dir,format,par)
% Load observation data for Unicor.
% for now treat only eShel format
format=par.obs_data_format;
 obs_pathname            = uigetdir(par.data_path, 'Choose Obs. dirctory');
 if obs_pathname ~=0
             obs_dir         = obs_pathname;
             par.data_path   = obs_dir;
 end % if obs_pathname ~=0
file_list = dir(fullfile(obs_dir,par.obs_file_def));  
obs_n     = length(file_list);
par.obs_n=obs_n;

if obs_n == 0
   msgbox('No observations found.');
   obs = NaN;
   return;
end

obs       = cell(obs_n,1);
fprintf ('Loading spectra........\n')
switch (format)
    case 'eShel'
        for i = 1:obs_n
            if ((0.05*i)==floor( 0.05*i)) 
                fprintf('.\n')
            else
                fprintf('.')
            end
            
            max_vec_size  = 0;
            fname_tmp = file_list(i).name;
            obs_tmp   = load(fullfile(obs_dir,fname_tmp));
            ord_n     = length(obs_tmp.spect);
            % TEMPORARY: take Reject orders > 20 to fit current
            % template size.
            
            if ord_n > 20
                for k = 2:21
                    spect_new(k-1) = obs_tmp.spect(k);
                end
                obs_tmp.spect = spect_new;
            end
            ord_n     = length(obs_tmp.spect);
            
            % End of temporary stage.
            
            par.ord_n=ord_n;
            wv_tmp    = cell(ord_n,1);
            sp_tmp    = cell(ord_n,1);
            

            
           t_tmp    =   obs_tmp.obs_data.HJD;
           name_tmp =   obs_tmp.obs_data.obj_name;
           hcv_tmp   = obs_tmp.obs_data.VHELIO;
            
            for j = 1:ord_n
                tmp_vec   = obs_tmp.spect(j).lam ; 
                wv_tmp{j} = tmp_vec;
                tmp_vec   = obs_tmp.spect(j).data ; 
                sp_tmp{j} = tmp_vec;
                if length(sp_tmp{j})>max_vec_size
                    max_vec_size = length(sp_tmp{j});
                end 
            end
            
            for j = 1:ord_n
                padsize    = max_vec_size - length(wv_tmp{j});
                
                dlam       = obs_tmp.spect(j).deltalam;
                wv_padval  = obs_tmp.spect(j).lamstart;
                padfix_arr = dlam.*(padsize:-1:1)';
                
                wv_tmp_arr            = padarray(wv_tmp{j},padsize,wv_padval,'pre');
                wv_tmp_arr(1:padsize) = wv_tmp_arr(1:padsize) - padfix_arr;
                wv_tmp1{j}            = wv_tmp_arr;
                
                sp_tmp1{j}            = padarray(sp_tmp{j},padsize,0,'pre');
            end
            
            wv_tmp = cell2mat(wv_tmp1);
            sp_tmp = cell2mat(sp_tmp1);
            
 
            % Save data into output cell array:
            obs{i}.wv       = wv_tmp;
            obs{i}.sp       = sp_tmp;
            obs{i}.jd       = t_tmp;
            obs{i}.name     = name_tmp;
            obs{i}.filename = fname_tmp;
            obs{i}.hcv      = hcv_tmp;

            % TEMPORARY: take only bad orders from 2:21 to fit current
            % template size.
            obs{i}.bad_ord  = obs_tmp.obs_data.bad_orders(2:21);
            % End of temporary stage.
            
            if isfield(obs_tmp,'signal')
               obs{i}.signal = obs_tmp.signal;
            else
               obs{i}.signal = NaN;
            end

            if isfield(obs_tmp,'snr')
               obs{i}.snr = obs_tmp.snr;
            else
               obs{i}.snr = NaN;
            end

        par.name= name_tmp;  
        end
        
    case 'todcor ASCII'
        for i = 1:obs_n
            if ((0.05*i)==floor(0.05*i)) 
                fprintf('.\n')
            else
                fprintf('.')
            end
            obs_tmp = txt2tod([obs_dir '/' file_list(i).name] );
            obs{i}  = obs_tmp;
        end
        
        
end
 
end


