%% calculate the input "fc" for VLFeat the impletementation of SIFT
% Input R value image (local non-minima suppressed), graidient direction as
% well as a scale constant.
% fc will have size (4, N), where N is your number of interest points
% each column should be like this: [100;200;10;-pi/8] 
function fc = prep_fc_for_sift(R,grad_dir,scale)
    [x_grid ,y_grid] = meshgrid(1:size(R,2),1:size(R,1));
    fc = [x_grid(R>0) y_grid(R>0)];
    fc = [fc ones(size(fc,1),1)*scale];
    fc = [fc grad_dir(R>0)];
    fc = fc';
end