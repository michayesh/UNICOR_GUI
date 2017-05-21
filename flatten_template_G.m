function f_template = flatten_template_G( template )
%Flatten template usning clean_norm funcion
% Uses clean_norm, quntfilt, quantfiltdiff
%   Input: unicor template structure
%   output: flattened template in a similar structure
% 


f_template=template; % init the structure
n_orders=template.orderN;


for order=1:n_orders
 % flatten the template order by order
        templ_spec.lam=template.wv(:,order);
        templ_spec.data=template.sp(:,order);
       [ntempl,~]=clean_norm(templ_spec,5,0.7,'simple-robust');
       padsize=[size(templ_spec.lam,1)-size(ntempl.lam,1) 0];
       ntempl.lam=padarray(ntempl.lam,padsize,'post');
       ntempl.data=padarray(ntempl.data,padsize,'post');
%        d=padarray(ntempl.data,padsize);
%        l=padarray(ntempl.lam,padsize);
        f_template.sp(:,order)=ntempl.data;
        f_template.wv(:,order)=ntempl.lam;
end

