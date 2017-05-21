function [ ] = save_MaRV_data_G( MaRV_struct,start_path )
% Saves MaRV results in  both mat file and orb txt file
% Both files are saved in the same place
%  Input:
%       MaRV_strct
%       start_path - for save
  
           
          output_dir = uigetdir(start_path,'Where should I save the data?');
          f_name1   = fullfile(output_dir, [par.name '_MaRV_' datestr(now,30) '.mat']);
            save(f_name1,'MaRV_struct' );
%            
         %   wrt_txt_orbo_MaRV(t,v{2},dv{2},par.name,unicor_data_path);
         wrt_txt_orbo_MaRV(t,v{end},dv{end},par.name,unicor_data_path);
         
        num =length(MaRV_struct.t);
        name=MaRV_struct.par.name;
        t=MaRV_struct.t;
        v=MaRV_struct.v{end};
        dv=MaRV_struct.dv{end};
FID = fopen(fullfile( output_dir,[name '_ORBODATA'  '.orb']),'w+');
fprintf (FID,'STAR: %s \n',name);

for i = 1: num
fprintf (FID,'A %f %f %f\n' ,t(i),v(i),dv(i));
end

fprintf (FID,'END');

fclose(FID);

end

