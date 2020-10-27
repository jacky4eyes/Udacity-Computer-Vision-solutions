%%
% im_out = append_1r1c(im_in)
function im_out = append_1r1c(im_in)
    im_out = im_in;
    im_out(end+1,:) = im_out(end,:);
    im_out(:,end+1) = im_out(:,end);
end