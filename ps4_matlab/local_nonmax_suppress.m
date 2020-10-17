%% return adjusted R-value image by taking 2 steps:
% 1) threshold by 0.995 quantile.
% 2) suppres elements that are not local maxima.
function R_sup = local_nonmax_suppress(R,local_size)

    th = quantile(reshape(R,1,[]),0.995);
    R_temp = R;
    R_temp(R<th) = 0;
    R_sup = zeros(size(R));    
    v = floor(local_size/2);  % half-size
    for i = v+1:(size(R,1)-v)
        R_sup(i,:) = max(R_temp(i-v:i+v,:),[],1);
    end
    R_temp = R_sup;
    for i = v+1:(size(R,2)-v)
        R_sup(:,i) = max(R_temp(:,i-v:i+v),[],2);
    end
    R_sup = R.*(R_sup==R);

end