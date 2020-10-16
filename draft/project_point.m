function p_img = project_point(p, f)
    PM = [1 0 0 0; 0 1 0 0; 0 0 1/f 0];
    p_img_homo = PM * [p 0]';
    p_img = p_img_homo(1:2)./p_img_homo(3);
    
end